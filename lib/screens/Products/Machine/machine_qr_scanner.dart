import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'machine_problem_request.dart'; // Add this package

class BeautifulQRScannerScreen extends StatefulWidget {
  final bool? fromMultipleScreen;

  const BeautifulQRScannerScreen({super.key, this.fromMultipleScreen});

  @override
  State<BeautifulQRScannerScreen> createState() => _BeautifulQRScannerScreenState();
}

class _BeautifulQRScannerScreenState extends State<BeautifulQRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? _scannedResult;
  List<String> _parsedNames = [];
  bool _isScanning = true;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _parseQRResult(String result) {
    // Split by * and clean up the names
    _parsedNames = result.split('*').map((name) {
      return name.trim(); // Remove whitespace
    }).where((name) => name.isNotEmpty).toList();
  }

  void _onQRCodeDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          _isScanning = false;
          _scannedResult = barcode.rawValue!;
          _parseQRResult(_scannedResult!);

          // Vibrate on success
          // HapticFeedback.lightImpact(); // Uncomment if you have haptic feedback package
        });

        // Stop camera after successful scan
        cameraController.stop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR Code Scanned Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _resetScanner() {
    setState(() {
      _scannedResult = null;
      _parsedNames.clear();
      _isScanning = true;
    });
    cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: cameraController,
            onDetect: _onQRCodeDetect,
          ),

          // Overlay UI
          Column(
            children: [
              // App Bar
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'QR Code Scanner',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: (){
                    if(widget.fromMultipleScreen==true){
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>MachineRepairScreen()));
                  }, icon: Icon(Icons.list))
                ],
              ),

              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isScanning ? Colors.green : Colors.blue,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Scanner animation
                        if (_isScanning)
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.green, Colors.transparent],
                                ),
                              ),
                            ),
                          ),

                        // Corner decorations
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _buildCornerPiece(true, false),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _buildCornerPiece(true, true),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: _buildCornerPiece(false, false),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _buildCornerPiece(false, true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Section
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  children: [
                    if (_scannedResult != null)
                      _buildResultSection()
                    else
                      _buildInstructions(),

                    SizedBox(height: 20),

                    // Action Button
                    _scannedResult != null?  Row(
                      children: [
                        SizedBox(width: 8,),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _scannedResult != null ? _resetScanner : null,
                            icon: Icon(Icons.qr_code_scanner),
                            label: Text(
                                'Scan Again',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if(widget.fromMultipleScreen==true){
                                Navigator.pop(context, _parsedNames);
                                return;
                              }
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=>MachineRepairScreen(machineInfo: _parsedNames,)));
                            },
                            icon: Icon(Icons.qr_code_scanner),
                            label: Text(
                                'Next',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                      ],
                    )
                        :
                    ElevatedButton.icon(
                      onPressed: _scannedResult != null ? _resetScanner : null,
                      icon: Icon(Icons.qr_code_scanner),
                      label: Text(
                        'Scanning',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCornerPiece(bool isTop, bool isRight) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.green,
            width: isRight ? 0 : 3,
          ),
          right: BorderSide(
            color: Colors.green,
            width: isRight ? 3 : 0,
          ),
          top: BorderSide(
            color: Colors.green,
            width: isTop ? 3 : 0,
          ),
          bottom: BorderSide(
            color: Colors.green,
            width: isTop ? 0 : 3,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        Icon(
          Icons.qr_code_2,
          size: 50,
          color: Colors.white,
        ),
        SizedBox(height: 10),
        Text(
          'Position QR Code within the frame',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Scan QR codes with * separated names',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Scanned Successfully',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          // SizedBox(height: 12),
          //
          // // Original string
          // Container(
          //   padding: EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade50,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Original String:',
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: Colors.grey.shade600,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       SizedBox(height: 4),
          //       Text(
          //         _scannedResult!,
          //         style: TextStyle(
          //           fontSize: 14,
          //           color: Colors.black87,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(height: 16),

          // Parsed names
          Text(
            'Parsed Names:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: _parsedNames.asMap().entries.map((entry) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: entry.key < _parsedNames.length - 1
                          ? BorderSide(color: Colors.blue.shade100)
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 8),
          Text(
            'Total Names: ${_parsedNames.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}