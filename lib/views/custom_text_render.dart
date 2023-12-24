// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:grits_task/providers/data_provider.dart';

class CustomTextRenderingWidget extends StatelessWidget {
  const CustomTextRenderingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Rendered Data',
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(200, 200),
          painter: CircleTextPainter(
            text: context.watch<DataProvider>().displayText,
          ),
        ),
      ),
    );
  }
}

class CustomTextPainter extends CustomPainter {
  final String text;
  final Path path;

  CustomTextPainter({required this.text, required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    // Implement custom text rendering logic using canvas.drawPath() and TextPainter
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CircleTextPainter extends CustomPainter {
  final String text;

  CircleTextPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final double radius = size.width / 2;
    final double angleStep = 360 / text.length;

    for (int i = 0; i < text.length; i++) {
      final double angle = i * angleStep * (pi / 180);
      final double x = radius * cos(angle) + radius;
      final double y = radius * sin(angle) + radius;
      canvas.drawText(text[i], x, y, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

extension CanvasTextDrawing on Canvas {
  void drawText(String text, double x, double y, Paint paint) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: paint.color, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        this, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }
}
