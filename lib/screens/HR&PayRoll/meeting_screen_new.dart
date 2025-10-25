// lib/screens/meetings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/meeting_card.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/riverpods/meeting_provider.dart';
import '../../providers/riverpods/purchase_order_riverpod.dart';
import 'create_a_meeting.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){

            ref.refresh(allBookingsProvider);
            ref.refresh(todaysBookingsProvider);

          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey[50], // Background color for the whole tab bar
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: myColors.primaryColor, // Background color of selected tab
                borderRadius: BorderRadius.circular(1), // Rounded corners
              ),
              indicatorSize: TabBarIndicatorSize.tab, // Make indicator cover the full tab
              labelColor: Colors.white, // Text color when selected
              unselectedLabelColor: Colors.black, // Text color when not selected
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: "Today's Bookings"),
                Tab(text: 'All Bookings'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateMeetingScreen()));
                },
                child: const Text(
                  'Create +',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today's Bookings Tab
                Consumer(
                  builder: (context, ref, child) {
                    final todaysBookings = ref.watch(todaysBookingsProvider);
                    return todaysBookings.when(
                      data: (bookings) => _buildBody(bookings, isToday: true),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.refresh(todaysBookingsProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // All Bookings Tab
                Consumer(
                  builder: (context, ref, child) {
                    final allBookings = ref.watch(allBookingsProvider);
                    return allBookings.when(
                      data: (bookings) => _buildBody(bookings, isToday: false),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.refresh(allBookingsProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Rest of your _buildBody, _buildMeetingCard methods remain the same...


  Widget _buildBody(List<BoardRoomBookingModel> data, {required bool isToday}) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isToday ? 'No meetings for today' : 'No meetings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isToday ? 'All clear for today!' : 'Create your first meeting',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final meeting = data[index];
        return MeetingCard(
          meeting: meeting,
          onDelete: (data){
            deleteItem(ref,meeting.id.toString());
          },
        );
      },
    );
  }





}