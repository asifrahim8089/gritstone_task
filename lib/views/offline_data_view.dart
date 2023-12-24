// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:grits_task/model/post_model.dart';
import 'package:grits_task/providers/data_provider.dart';
import 'package:provider/provider.dart';

class OfflineDataHandle extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  OfflineDataHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Data Handling'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Local Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildLocalPostsList(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Enter Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Enter Body'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final title = titleController.text;
                  final body = bodyController.text;
                  if (title.isNotEmpty && body.isNotEmpty) {
                    final post = Post(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: title,
                        body: body);
                    final databaseProvider =
                        Provider.of<DataProvider>(context, listen: false);
                    await databaseProvider.addPostLocally(post);
                    titleController.clear();
                    bodyController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set your desired button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Add Post Locally',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final title = titleController.text;
                  final body = bodyController.text;
                  if (title.isNotEmpty && body.isNotEmpty) {
                    final post = Post(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: title,
                        body: body);
                    final databaseProvider =
                        Provider.of<DataProvider>(context, listen: false);
                    await databaseProvider.updatePostLocally(post);
                    titleController.clear();
                    bodyController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set your desired button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Update Post Locally',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final databaseProvider =
                      Provider.of<DataProvider>(context, listen: false);
                  await databaseProvider.syncWithServer();
                  titleController.clear();
                  bodyController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set your desired button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Sync with Server',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalPostsList(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return FutureBuilder<List<Post>>(
      future: dataProvider.getLocalPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final localPosts = snapshot.data ?? [];
          return Column(
            children: localPosts
                .map((post) => ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
