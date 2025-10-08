// screens/create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../../providers/riverpods/management_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(createPostProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: isCreating ? null : _createPost,
            child: Text(
              'POST',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "What's happening in the company?",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    final notifier = ref.read(createPostProvider.notifier);
    await notifier.createPost(_contentController.text.trim());

    if (mounted) {
      Navigator.pop(context);
    }
  }
}