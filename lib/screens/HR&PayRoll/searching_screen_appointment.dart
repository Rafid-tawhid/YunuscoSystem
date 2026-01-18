// screens/network_searching_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/helper_class/firebase_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/searchig_application_request.dart';
import 'package:yunusco_group/service_class/api_services.dart';

import '../../models/appointment_model_new.dart';
import '../../providers/riverpods/meeting_provider.dart';

class NetworkSearchingScreen extends StatefulWidget {
  const NetworkSearchingScreen({Key? key}) : super(key: key);

  @override
  State<NetworkSearchingScreen> createState() => _NetworkSearchingScreenState();
}

class _NetworkSearchingScreenState extends State<NetworkSearchingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _rotationAnimation;

  bool _isSearching = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_controller);
  }

  void _startSearching() async {
    setState(() {
      _isSearching = true;
    });

    // Start animations
    _controller.repeat();

    // Update Firebase status to active
    await _firebaseService.updatePresence(DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!, true);
  }

  void _stopSearching() async {
    setState(() {
      _isSearching = false;
    });

    // Stop animations
    _controller.stop();
    _controller.reset();

    // Update Firebase status to deactive
    await _firebaseService.updatePresence(DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!, false);
  }

  @override
  void dispose() {
    // Always set to deactive when screen is disposed
    _firebaseService.updatePresence(DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!, false);

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("Available Appointments"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[600],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentBookingScreen(),
                  ),
                );
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Animated Radar Section (only show when searching)
            if (_isSearching) ...[
              Expanded(
                flex: 2,
                child: _buildRadarSection(),
              ),

              // Searching Text
              _buildSearchingText(),

              // Devices List
              Expanded(
                flex: 3,
                child: _buildDevicesList(),
              ),
            ] else ...[
              // Show placeholder when not searching
              Expanded(
                flex: 5,
                child: _buildPlaceholderSection(),
              ),
            ],

            // Single Action Button (Start/Stop)
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple[400]!,
            Colors.deepPurple[600]!,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Appointments",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching ? "Looking for appointments..." : "Ready to scan",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _isSearching ? "ACTIVE" : "INACTIVE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.wifi_find_rounded,
            color: Colors.deepPurple[400],
            size: 60,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Ready for Appointment Requests",
          style: TextStyle(
            fontSize: 22,
            color: Colors.deepPurple[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Click the 'Start Sharing' button below to begin requests for appointments from available users.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadarSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circles
        AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: RadarPainter(_waveAnimation.value),
              size: const Size(250, 250),
            );
          },
        ),

        // Rotating radar
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.deepPurple[300]!.withOpacity(0.3),
                      Colors.deepPurple[500]!.withOpacity(0.1),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: RadarSweepPainter(),
                ),
              ),
            );
          },
        ),

        // Center icon
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.deepPurple[500],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple[300]!.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.wifi_find_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),

        // Floating devices around radar
        ..._buildFloatingDevices(),
      ],
    );
  }

  List<Widget> _buildFloatingDevices() {
    return [
      _buildFloatingDevice(0, -120, Icons.phone_iphone_rounded, Colors.blue),
      _buildFloatingDevice(100, -80, Icons.phone_android_rounded, Colors.green),
      _buildFloatingDevice(-100, -80, Icons.laptop_mac_rounded, Colors.orange),
      _buildFloatingDevice(120, 60, Icons.tablet_mac_rounded, Colors.purple),
      _buildFloatingDevice(-120, 60, Icons.computer_rounded, Colors.red),
    ];
  }

  Widget _buildFloatingDevice(double x, double y, IconData icon, Color color) {
    return Positioned(
      left: 125 + x,
      top: 125 + y,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildSearchingText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Waiting for requests",
            style: TextStyle(
              fontSize: 18,
              color: Colors.deepPurple[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Text(
                ".".padRight((_controller.value * 4).floor() % 4, '.'),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    return Consumer(
      builder: (context, ref, _) {
        final appointmentsAsync = ref.watch(appointmentStreamProvider(
            DashboardHelpers.currentUser!.iDnum ?? ''));
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100]!,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              (appointmentsAsync.value == null ||
                      appointmentsAsync.value!.isEmpty)
                  ? SizedBox()
                  :
                  // List Header
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.devices_rounded,
                              color: Colors.deepPurple[600]),
                          const SizedBox(width: 10),
                          Text(
                            '${appointmentsAsync.value!.length} Request Found ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
              Expanded(
                  child: AppointmentListWidget(
                userId: '09623',
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _isSearching
          ? ElevatedButton(
              onPressed: _stopSearching,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.red[300],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stop_rounded),
                  SizedBox(width: 10),
                  Text(
                    "Stop Sharing",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: _startSearching,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[600],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.deepPurple[300],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded),
                  SizedBox(width: 10),
                  Text(
                    "Start Sharing",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}

// Custom painter for radar circles
class RadarPainter extends CustomPainter {
  final double animationValue;

  RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color =
          Colors.deepPurple[300]!.withOpacity(0.3 - (animationValue * 0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw multiple concentric circles
    for (int i = 1; i <= 3; i++) {
      final radius = (size.width / 2) * (i / 3) * (0.8 + animationValue * 0.2);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for radar sweep
class RadarSweepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final sweepGradient = SweepGradient(
      colors: [
        Colors.deepPurple[300]!.withOpacity(0.1),
        Colors.deepPurple[500]!.withOpacity(0.3),
        Colors.deepPurple[300]!.withOpacity(0.1),
      ],
    );

    final paint = Paint()
      ..shader = sweepGradient
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AppointmentListWidget extends StatelessWidget {
  final String userId;
  final FirebaseService _firebaseService = FirebaseService();

  AppointmentListWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<AppointmentModelNew>>(
      stream: _firebaseService.getAllAppointmentRequest(userId),
      builder: (context, snapshot) {
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Handle data
        final appointments = snapshot.data ?? [];

        if (appointments.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No appointment requests',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return GestureDetector(
              onTap: (){
                _showStatusAlert(context,appointment);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(appointment.status),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    appointment.bookedByUserName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.purpose),
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${appointment.appointmentType}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );



  }
  void _showStatusAlert(BuildContext context,AppointmentModelNew data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.work_outline,
                    color: Colors.blue[700],
                    size: 32,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                const Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                const Text(
                  'Select the current status of this item',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    // In Progress Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange[400]!, Colors.orange[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handleInProgress(data);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hourglass_top, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'In Progress',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Finished Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[500]!, Colors.green[700]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _handleFinished(data);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Finished',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleInProgress(AppointmentModelNew data) {
    FirebaseService fs=FirebaseService();
    fs.updateStatusAppointment("in_progress",data);
    // Add your logic here
  }

  void _handleFinished(AppointmentModelNew data) {
    FirebaseService fs=FirebaseService();
    fs.updateStatusAppointment("completed",data);
    // Add your logic here
  }




  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
