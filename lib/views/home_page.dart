// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:grits_task/providers/accessibility_provider.dart';
import 'package:grits_task/providers/data_provider.dart';
import 'package:grits_task/views/custom_text_render.dart';
import 'package:grits_task/views/offline_data_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _descriptionController = TextEditingController();
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility App',
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: false,
        elevation: 1.0,
        actions: [
          Row(
            children: [
              Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: accessibilityProvider.highContrastMode,
                  onChanged: (value) {
                    setState(() {
                      accessibilityProvider.toggleHighContrastMode();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.speaker,
              size: 100.0,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Please Type below:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5, // Adjust the number of visible lines
                keyboardType: TextInputType.multiline, // Enable multiline input
                decoration: const InputDecoration(
                  hintText: 'Type your text here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  accessibilityProvider.toggleTts();
                  accessibilityProvider.speak(_descriptionController.text);
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
                      'Submit to Speak',
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
                onPressed: () {
                  context.read<DataProvider>().displayText =
                      _descriptionController.text;
                  _descriptionController.text.isEmpty
                      ? showSnackbar(context, "Please Type Anything to render")
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CustomTextRenderingWidget(),
                          ),
                        );
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
                      'Render Text',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfflineDataHandle(),
                    ),
                  );
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
                      'Handle Data',
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
}
