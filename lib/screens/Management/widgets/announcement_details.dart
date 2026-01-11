import 'package:flutter/material.dart';

class AnnouncementDetails extends StatelessWidget {
  const AnnouncementDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Details'),
      ),
      body: const Center(
        child: Text('Announcement Details Content Here'),
      ),
    );
  }
}
