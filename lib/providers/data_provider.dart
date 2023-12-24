// ignore_for_file: depend_on_referenced_packages, unused_field, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:grits_task/model/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataProvider with ChangeNotifier {
  String _displayText = "Custom Text Rendering";
  String get displayText => _displayText;
  late Database _database;
  bool _isDatabaseInitialized = false;

  set displayText(String text) {
    _displayText = text;
    notifyListeners();
  }

  bool _isConnected = true; // Assume initially connected
  Future<void> _initializeDatabaseIfNot() async {
    if (!_isDatabaseInitialized) {
      await initDatabase();
    }
  }

  DataProvider() {
    _initializeConnectivity();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'gritsposts_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)',
        );
      },
      version: 1,
    );
    _isDatabaseInitialized = true;
    notifyListeners();
  }

  Future<void> _initializeConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
      if (_isConnected) {
        // If connection is restored, sync with the server
        syncWithServer();
      }
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  Future<void> addPostLocally(Post post) async {
    await _initializeDatabaseIfNot();
    await _database.insert('posts', post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<void> updatePostLocally(Post post) async {
    await _initializeDatabaseIfNot();
    await _database
        .update('posts', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
    notifyListeners();
  }

  Future<List<Post>> getLocalPosts() async {
    await _initializeDatabaseIfNot();
    final List<Map<String, dynamic>> maps = await _database.query('posts');
    return List.generate(maps.length, (i) {
      return Post(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
      );
    });
  }

  Future<void> syncWithServer() async {
    await _initializeDatabaseIfNot();
    if (!_isConnected) {
      return; // Don't sync if not connected
    }

    final List<Post> localPosts = await getLocalPosts();

    for (Post post in localPosts) {
      await _syncPostWithServer(post);
    }
  }

  Future<void> _syncPostWithServer(Post post) async {
    await _initializeDatabaseIfNot();
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'id': post.id,
        'title': post.title,
        'body': post.body,
      }),
    );

    if (response.statusCode == 201) {
      // Successful sync, you can update the local database accordingly
      await _database.delete('posts', where: 'id = ?', whereArgs: [post.id]);
      notifyListeners();
    }
  }
}
