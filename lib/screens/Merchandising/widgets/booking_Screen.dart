import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and filter bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search bookings...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Add filter functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Booking list header
            const Text(
              'Recent Bookings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Booking list
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with your actual data length
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text('Booking #${index + 1}'),
                      subtitle:  Text('June ${DateTime.now().day}, 2025'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to booking details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailScreen(bookingId: index + 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Add new booking button
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to create booking screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateBookingScreen()),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Booking Detail Screen
class BookingDetailScreen extends StatelessWidget {
  final int bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking #$bookingId Details'),
      ),
      body: const Center(
        child: Text('Booking details will be shown here'),
      ),
    );
  }
}

// Placeholder for Create Booking Screen
class CreateBookingScreen extends StatelessWidget {
  const CreateBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Booking'),
      ),
      body: const Center(
        child: Text('Booking creation form will be here'),
      ),
    );
  }
}