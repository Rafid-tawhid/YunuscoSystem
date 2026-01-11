// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:crop_your_image/crop_your_image.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:yunusco_group/screens/Profile/signature_Screen.dart';
// import 'package:yunusco_group/utils/colors.dart';
// import 'package:yunusco_group/utils/constants.dart';
//
//
// class NidExtractorScreen extends StatefulWidget {
//   const NidExtractorScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NidExtractorScreen> createState() => _NidExtractorScreenState();
// }
//
// class _NidExtractorScreenState extends State<NidExtractorScreen> {
//   File? frontImage;
//   File? backImage;
//   bool isLoading = false;
//
//   final nameController = TextEditingController();
//   final nidController = TextEditingController();
//   final dobController = TextEditingController();
//   final pobController = TextEditingController();
//   final bloodController = TextEditingController();
//   final issueController = TextEditingController();
//   final fatherController = TextEditingController();
//   final motherController = TextEditingController();
//   final addressController = TextEditingController();
//
//   final ImagePicker picker = ImagePicker();
//   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//
//   Future<void> pickImage(bool isFront) async {
//     // Show dialog to choose image source
//     final source = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: const Text('Select Image Source'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.blue),
//                 title: const Text('Camera'),
//                 onTap: () => Navigator.pop(context, ImageSource.camera),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.green),
//                 title: const Text('Gallery'),
//                 onTap: () => Navigator.pop(context, ImageSource.gallery),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (source == null) return; // User cancelled the dialog
//
//     final picked = await picker.pickImage(source: source);
//     if (picked != null) {
//       // Navigate to crop screen
//       final croppedImage = await Navigator.push<Uint8List?>(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ImageCropScreen(
//             imageFile: File(picked.path),
//             aspectRatio: 16 / 9, // Adjust as needed
//           ),
//         ),
//       );
//
//       if (croppedImage != null) {
//         // Save cropped image to a temporary file
//         final tempDir = await getTemporaryDirectory();
//         final croppedFile = File(
//             '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await croppedFile.writeAsBytes(croppedImage);
//
//         setState(() {
//           if (isFront) {
//             frontImage = croppedFile;
//           } else {
//             backImage = croppedFile;
//           }
//         });
//
//         // Auto-extract after short delay
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (isFront) {
//             extractFrontData();
//           } else {
//             extractBackData();
//           }
//         });
//       } else {
//         // If user cancelled cropping, use original image
//         setState(() {
//           if (isFront) {
//             frontImage = File(picked.path);
//           } else {
//             backImage = File(picked.path);
//           }
//         });
//       }
//     }
//   }
//
//
//
//   Future<void> extractFrontData() async {
//     if (frontImage == null) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       final inputImage = InputImage.fromFile(frontImage!);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       String fullText = recognizedText.text;
//       debugPrint("=== FRONT SIDE EXTRACTED TEXT ===");
//       debugPrint(fullText);
//       debugPrint("=================================");
//
//       // Extract and clean data
//       String extractField(RegExp regex, [int group = 1]) {
//         final match = regex.firstMatch(fullText);
//         if (match != null && match.groupCount >= group) {
//           String extracted = match.group(group)?.trim() ?? '';
//           // Clean common OCR errors
//           extracted = extracted.replaceAll(RegExp(r'[|]'), 'I');
//           extracted = extracted.replaceAll(RegExp(r'[{}]'), '');
//           return extracted;
//         }
//         return '';
//       }
//
//       // Extract Name
//       RegExp nameRegex = RegExp(
//           r'(?:Name|নাম)[\s:\-]*([A-Za-z\s\.]+(?:\s+[A-Za-z]+)*)',
//           caseSensitive: false
//       );
//       nameController.text = extractField(nameRegex);
//
//       // Extract NID Number
//       String extractNidNumber() {
//         String nid = '';
//
//         // Strategy 1: Look for numbers with spaces and remove spaces
//         RegExp nidWithSpaces = RegExp(r'\b\d{3}\s\d{3}\s\d{4}\b');
//         Match? spaceMatch = nidWithSpaces.firstMatch(fullText);
//         if (spaceMatch != null) {
//           nid = spaceMatch.group(0)!.replaceAll(RegExp(r'\s+'), '');
//           debugPrint("Found NID with spaces: ${spaceMatch.group(0)} -> $nid");
//         }
//
//         // Strategy 2: Look for "NID No" pattern
//         if (nid.isEmpty) {
//           List<String> lines = fullText.split('\n');
//           for (int i = 0; i < lines.length; i++) {
//             if (lines[i].contains('NID No') || lines[i].contains('NID')) {
//               // Check next 2 lines for numbers
//               for (int j = i + 1; j < lines.length && j <= i + 2; j++) {
//                 String potentialLine = lines[j].trim();
//                 String cleanNumber = potentialLine.replaceAll(RegExp(r'\s+'), '');
//                 if (RegExp(r'^\d{10}$').hasMatch(cleanNumber)) {
//                   nid = cleanNumber;
//                   debugPrint("Found NID after 'NID No' line: $nid");
//                   break;
//                 }
//               }
//               if (nid.isNotEmpty) break;
//             }
//           }
//         }
//
//         // Strategy 3: Look for any 10-digit number
//         if (nid.isEmpty) {
//           List<String> lines = fullText.split('\n');
//           for (String line in lines) {
//             String cleanLine = line.replaceAll(RegExp(r'\s+'), '');
//             Match? match = RegExp(r'\b\d{10}\b').firstMatch(cleanLine);
//             if (match != null) {
//               nid = match.group(0)!;
//               debugPrint("Found NID by removing spaces: $nid");
//               break;
//             }
//           }
//         }
//
//         return nid;
//       }
//
//       // Extract Date of Birth from front side
//       RegExp dobRegex = RegExp(
//           r'(?:Date of Birth|জন্ম তারিখ)[\s:\-]*([\d]{1,2}[/\-\s](?:[A-Za-z]{3}|[\d]{1,2})[/\-\s][\d]{4})',
//           caseSensitive: false
//       );
//
//       // Extract Father's Name
//       RegExp fatherRegex = RegExp(
//           r'(?:Father|পিতা)[\s:\-]*([A-Za-z\s\.]+(?:\s+[A-Za-z]+)*)',
//           caseSensitive: false
//       );
//
//       // Extract Mother's Name
//       RegExp motherRegex = RegExp(
//           r'(?:Mother|মাতা)[\s:\-]*([A-Za-z\s\.]+(?:\s+[A-Za-z]+)*)',
//           caseSensitive: false
//       );
//
//       // Set front side field values
//       nidController.text = extractNidNumber();
//       dobController.text = extractField(dobRegex);
//       fatherController.text = extractField(fatherRegex);
//       motherController.text = extractField(motherRegex);
//
//       // Fallback extraction for front side
//       if (nidController.text.isEmpty) {
//         _fallbackFrontExtraction(fullText);
//       }
//
//       debugPrint("Front Side - Name: ${nameController.text}");
//       debugPrint("Front Side - NID: ${nidController.text}");
//       debugPrint("Front Side - DOB: ${dobController.text}");
//
//     } catch (e) {
//       debugPrint('Error extracting front side text: $e');
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   Future<void> extractBackData() async {
//     if (backImage == null) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       final inputImage = InputImage.fromFile(backImage!);
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//
//       String fullText = recognizedText.text;
//       debugPrint("=== BACK SIDE EXTRACTED TEXT ===");
//       debugPrint(fullText);
//       debugPrint("================================");
//
//       // Extract and clean data
//       String extractField(RegExp regex, [int group = 1]) {
//         final match = regex.firstMatch(fullText);
//         if (match != null && match.groupCount >= group) {
//           String extracted = match.group(group)?.trim() ?? '';
//           extracted = extracted.replaceAll(RegExp(r'[|]'), 'I');
//           extracted = extracted.replaceAll(RegExp(r'[{}]'), '');
//           return extracted;
//         }
//         return '';
//       }
//
//       // Extract Place of Birth - More specific pattern for back side
//       RegExp pobRegex = RegExp(
//           r'(?:Place of Birth|জন্ম স্থান|Birth Place)[\s:\-]*([A-Za-z\s,\.\-]+)',
//           caseSensitive: false
//       );
//
//       // Extract Blood Group - Multiple patterns
//       RegExp bloodRegex = RegExp(
//           r'(?:Blood Group|রক্তের গ্রুপ|Blood|ব্লাড গ্রুপ)[\s:\-]*([ABO][\+\-]?|A[1-2]?B?[\+\-]?|\b(?:A|B|AB|O)[+-]?\b)',
//           caseSensitive: false
//       );
//
//       // Extract Issue Date
//       RegExp issueRegex = RegExp(
//           r'(?:Issue Date|ইস্যুর তারিখ|Issued?|Date of Issue)[\s:\-]*([\d]{1,2}[/\-\s](?:[A-Za-z]{3}|[\d]{1,2})[/\-\s][\d]{4})',
//           caseSensitive: false
//       );
//
//       // Extract Address - More comprehensive pattern for back side
//       RegExp addressRegex = RegExp(
//           r'(?:Address|ঠিকানা|Present Address|বর্তমান ঠিকানা)[\s:\-]*',
//           caseSensitive: false
//       );
//
//       // Set back side field values
//       pobController.text = extractField(pobRegex);
//       bloodController.text = extractField(bloodRegex);
//       issueController.text = extractField(issueRegex);
//       addressController.text = extractField(addressRegex);
//
//       // Fallback extraction for back side
//       _fallbackBackExtraction(fullText);
//
//       debugPrint("Back Side - POB: ${pobController.text}");
//       debugPrint("Back Side - Blood: ${bloodController.text}");
//       debugPrint("Back Side - Issue Date: ${issueController.text}");
//       debugPrint("Back Side - Address: ${addressController.text}");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Back side data extracted successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//     } catch (e) {
//       debugPrint('Error extracting back side text: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error extracting back side data: $e')),
//       );
//     }
//
//     setState(() => isLoading = false);
//   }
//
//   void _fallbackFrontExtraction(String fullText) {
//     List<String> lines = fullText.split('\n');
//
//     for (int i = 0; i < lines.length; i++) {
//       String line = lines[i].trim();
//
//       // NID number detection
//       if (nidController.text.isEmpty) {
//         if (line.contains(RegExp(r'\d{3}\s\d{3}\s\d{4}'))) {
//           String nid = line.replaceAll(RegExp(r'\s+'), '');
//           if (nid.length == 10) {
//             nidController.text = nid;
//             debugPrint("Fallback found NID: $nid");
//           }
//         }
//       }
//
//       // Date of Birth fallback
//       if (dobController.text.isEmpty) {
//         RegExp dateFallback = RegExp(r'\d{1,2}\s+[A-Za-z]{3}\s+\d{4}');
//         Match? match = dateFallback.firstMatch(line);
//         if (match != null && line.contains('Birth')) {
//           dobController.text = match.group(0)!;
//         }
//       }
//     }
//
//     // Final NID fallback
//     if (nidController.text.isEmpty) {
//       String cleanText = fullText.replaceAll(RegExp(r'\s+'), '');
//       Match? match = RegExp(r'\d{10}').firstMatch(cleanText);
//       if (match != null) {
//         nidController.text = match.group(0)!;
//         debugPrint("Final fallback found NID: ${nidController.text}");
//       }
//     }
//   }
//
//   void _fallbackBackExtraction(String fullText) {
//     List<String> lines = fullText.split('\n');
//
//     for (int i = 0; i < lines.length; i++) {
//       String line = lines[i].trim();
//
//       // Blood Group fallback
//       if (bloodController.text.isEmpty) {
//         if (line.contains('Blood') || line.contains('ব্লাড') || line.contains('গ্রুপ')) {
//           // Look for blood group in current or next line
//           RegExp bloodFallback = RegExp(r'\b(A|B|AB|O)[+-]?\b');
//           Match? match = bloodFallback.firstMatch(line);
//           if (match != null) {
//             bloodController.text = match.group(0)!;
//           } else {
//             // Check next line
//             if (i + 1 < lines.length) {
//               match = bloodFallback.firstMatch(lines[i + 1]);
//               if (match != null) {
//                 bloodController.text = match.group(0)!;
//               }
//             }
//           }
//         }
//       }
//
//       // Place of Birth fallback
//       if (pobController.text.isEmpty) {
//         if (line.contains('Birth') || line.contains('জন্ম') || line.contains('Place')) {
//           // Next line might be the place of birth
//           if (i + 1 < lines.length) {
//             String nextLine = lines[i + 1].trim();
//             if (nextLine.isNotEmpty && !nextLine.contains(RegExp(r'[0-9]')) && nextLine.length > 2) {
//               pobController.text = nextLine;
//             }
//           }
//         }
//       }
//
//       // Issue Date fallback
//       if (issueController.text.isEmpty) {
//         RegExp dateFallback = RegExp(r'\d{1,2}\s+[A-Za-z]{3}\s+\d{4}');
//         Match? match = dateFallback.firstMatch(line);
//         if (match != null && (line.contains('Issue') || line.contains('ইস্যু') || line.contains('Date'))) {
//           issueController.text = match.group(0)!;
//         }
//       }
//
//       // Address fallback - look for longer text blocks
//       if (addressController.text.isEmpty) {
//         if (line.length > 20 && line.contains(RegExp(r'[A-Za-z]')) &&
//             !line.contains('Name') && !line.contains('Date') &&
//             !line.contains('Blood') && !line.contains('Issue')) {
//           addressController.text = line;
//         }
//       }
//     }
//
//     // Final blood group fallback - search entire text
//     if (bloodController.text.isEmpty) {
//       RegExp bloodFinal = RegExp(r'\b(A|B|AB|O)[+-]?\b');
//       Match? match = bloodFinal.firstMatch(fullText);
//       if (match != null) {
//         bloodController.text = match.group(0)!;
//       }
//     }
//   }
//
//   void clearAllFields() {
//     nameController.clear();
//     nidController.clear();
//     dobController.clear();
//     pobController.clear();
//     bloodController.clear();
//     issueController.clear();
//     fatherController.clear();
//     motherController.clear();
//     addressController.clear();
//     setState(() {
//       frontImage = null;
//       backImage = null;
//     });
//   }
//
//   @override
//   void dispose() {
//     textRecognizer.close();
//     nameController.dispose();
//     nidController.dispose();
//     dobController.dispose();
//     pobController.dispose();
//     bloodController.dispose();
//     issueController.dispose();
//     fatherController.dispose();
//     motherController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('NID Info Extractor'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.sign_language_sharp),
//             onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>SignatureScreen()));
//             },
//             tooltip: 'Take Sign',
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Image selection section
//             Card(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Select NID Images',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         imageBox(frontImage, true, 'Front Side'),
//                         imageBox(backImage, false, 'Back Side'),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Front: Personal Info | Back: Additional Details',
//                       style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Action buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: isLoading ? null : () {
//                       if (frontImage != null) extractFrontData();
//                       if (backImage != null) extractBackData();
//                     },
//                     icon: Icon(isLoading ? Icons.hourglass_top : Icons.text_snippet,color: Colors.white,),
//                     label: Text(isLoading ? 'Extracting...' : 'Extract All Data',style: customTextStyle(16, Colors.white, FontWeight.w500),),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: myColors.primaryColor,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 IconButton(onPressed: clearAllFields, icon: Icon(Icons.clear,color: Colors.black,))
//
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // Data fields
//             Card(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Extracted Information',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16),
//                     buildTextField('Full Name', nameController),
//                     buildTextField('NID Number', nidController),
//                     buildTextField('Date of Birth', dobController),
//                     buildTextField('Place of Birth', pobController),
//                     buildTextField('Blood Group', bloodController),
//                     buildTextField('Issue Date', issueController),
//                     buildTextField("Father's Name", fatherController),
//                     buildTextField("Mother's Name", motherController),
//                     buildTextField('Address', addressController, maxLines: 2),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget imageBox(File? image, bool isFront, String label) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () => pickImage(isFront),
//           child: Container(
//             width: 150,
//             height: 120,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: image != null ? Colors.green : Colors.grey,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               image: image != null
//                   ? DecorationImage(
//                 image: FileImage(image),
//                 fit: BoxFit.cover,
//               )
//                   : null,
//               color: image != null ? null : Colors.grey[100],
//             ),
//             child: image == null
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
//                 SizedBox(height: 8),
//                 Text(
//                   label,
//                   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             )
//                 : Stack(
//               children: [
//                 Positioned(
//                   bottom: 5,
//                   right: 5,
//                   child: Container(
//                     padding: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Icon(Icons.check, color: Colors.white, size: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         if (image != null)
//           TextButton(
//             onPressed: () => pickImage(isFront),
//             child: Text('Change Image'),
//           ),
//       ],
//     );
//   }
//
//   Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.grey[50],
//         ),
//       ),
//     );
//   }
// }
//
//
// class ImageCropScreen extends StatefulWidget {
//   final File imageFile;
//   final double aspectRatio;
//
//   const ImageCropScreen({
//     Key? key,
//     required this.imageFile,
//     required this.aspectRatio,
//   }) : super(key: key);
//
//   @override
//   _ImageCropScreenState createState() => _ImageCropScreenState();
// }
//
// class _ImageCropScreenState extends State<ImageCropScreen> {
//   final CropController _cropController = CropController();
//   Uint8List? _imageData;
//   bool _isCropping = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadImage();
//   }
//
//   Future<void> _loadImage() async {
//     final imageBytes = await widget.imageFile.readAsBytes();
//     setState(() {
//       _imageData = imageBytes;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Crop Image'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.done),
//             onPressed: _isCropping ? null : _cropImage,
//           ),
//         ],
//       ),
//       body: _imageData == null
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Crop(
//                 controller: _cropController,
//                 image: _imageData!,
//                 aspectRatio: widget.aspectRatio,
//                 onCropped: (result) {
//                   switch (result) {
//                     case CropSuccess(:final croppedImage):
//                       Navigator.pop(context, croppedImage);
//                     case CropFailure(:final cause):
//                       _showError('Failed to crop: $cause');
//                       setState(() => _isCropping = false);
//                   }
//                 },
//                 interactive: true,
//                 fixCropRect: false,
//                 baseColor: Colors.black,
//                 maskColor: Colors.white.withOpacity(0.5),
//                 radius: 8,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   'Pinch to zoom • Drag to move',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Crop area will maintain 16:9 ratio',
//                   style: TextStyle(color: Colors.grey[500], fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _cropImage() {
//     setState(() => _isCropping = true);
//     _cropController.crop();
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//     setState(() => _isCropping = false);
//   }
// }