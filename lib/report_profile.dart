import 'package:flutter/material.dart';

void reportProfile(BuildContext context) async {
  await showEditDialog(context);
}

Future<Map<String, dynamic>?> showEditDialog(BuildContext context) async {
  final TextEditingController whyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  return showDialog<Map<String, dynamic>?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Report profile"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: whyController,
              decoration: const InputDecoration(labelText: "Enter why"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText:"Describe more about the issue"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final Map<String, dynamic> result = {
              'why': whyController.text,
              'description': descriptionController.text,
            };
            Navigator.of(context).pop(result);
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}