// screens/network_searching_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/helper_class/firebase_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/searchig_application_request.dart';

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

  final List<Device> _devices = [
    Device(name: "iPhone 14 Pro", type: "iPhone", signal: 4),
    Device(name: "Samsung Galaxy S23", type: "Android", signal: 3),
    Device(name: "iPad Air", type: "iPad", signal: 5),
    Device(name: "MacBook Pro", type: "Laptop", signal: 5),
    Device(name: "Windows PC", type: "Computer", signal: 2),
  ];

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
    await _firebaseService.updatePresence(
        DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!,
        true
    );
  }

  void _stopSearching() async {
    setState(() {
      _isSearching = false;
    });

    // Stop animations
    _controller.stop();
    _controller.reset();

    // Update Firebase status to deactive
    await _firebaseService.updatePresence(
        DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!,
        false
    );
  }

  @override
  void dispose() {
    // Always set to deactive when screen is disposed
    _firebaseService.updatePresence(
        DashboardHelpers.currentUser!.iDnum!,
        DashboardHelpers.currentUser!.userName!,
        false
    );
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
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppointmentBookingScreen(),
              ),
            );
          }, icon: Icon(Icons.person))
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
            "Network Sharing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching ? "Searching for devices..." : "Ready to scan",
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
          "Network Scanner Ready",
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
            "Click the 'Start Sharing' button below to begin scanning for nearby devices",
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
            "Scanning for devices",
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
                Icon(Icons.devices_rounded, color: Colors.deepPurple[600]),
                const SizedBox(width: 10),
                Text(
                  "Available Devices (${_devices.length})",
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Devices List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return _buildDeviceItem(_devices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(Device device) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple[100]!),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getDeviceIcon(device.type),
            color: Colors.deepPurple[600],
          ),
        ),
        title: Text(
          device.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple[800],
          ),
        ),
        subtitle: Text(
          device.type,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSignalStrength(device.signal),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple[500],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Connect",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalStrength(int strength) {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          width: 3,
          height: (index + 1) * 3.0,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: index < strength ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'iphone':
        return Icons.phone_iphone_rounded;
      case 'android':
        return Icons.phone_android_rounded;
      case 'ipad':
        return Icons.tablet_mac_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'computer':
        return Icons.computer_rounded;
      default:
        return Icons.device_unknown_rounded;
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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

class Device {
  final String name;
  final String type;
  final int signal;

  Device({required this.name, required this.type, required this.signal});
}

// Custom painter for radar circles
class RadarPainter extends CustomPainter {
  final double animationValue;

  RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.deepPurple[300]!.withOpacity(0.3 - (animationValue * 0.3))
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
      ..shader = sweepGradient.createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}