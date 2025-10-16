import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PulsingTimestamp extends StatefulWidget {
  final String? timestamp;

  const PulsingTimestamp({super.key, required this.timestamp});

  @override
  State<PulsingTimestamp> createState() => _PulsingTimestampState();
}

class _PulsingTimestampState extends State<PulsingTimestamp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime date;

      // If it's a numeric timestamp (milliseconds since epoch)
      if (RegExp(r'^\d+$').hasMatch(timestamp)) {
        date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      }
      // If it's already a datetime string
      else {
        date = DateTime.parse(timestamp);
      }

      // Format: "MMM dd, yyyy • HH:mm"
      return DateFormat('MMM dd, yyyy • HH:mm').format(date);
    } catch (e) {
      print('Error parsing timestamp: $e');
      return timestamp; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timestamp == null || widget.timestamp!.isEmpty) {
      return const SizedBox.shrink();
    }

    final formattedTimestamp = _formatTimestamp(widget.timestamp!);

    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[50]!, Colors.amber[100]!],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time_filled,
              color: Colors.orange[700],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              formattedTimestamp,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.orange[900],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}