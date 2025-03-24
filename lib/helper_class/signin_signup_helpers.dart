// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
// import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
// import 'package:help_abode_worker_app_ver_2/screens/registration/select_categories_screen.dart';
// import 'package:help_abode_worker_app_ver_2/screens/registration/selfie_capture_screen_new.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../corporate/add_team_members.dart';
// import '../corporate/corporate_address.dart';
// import '../corporate/corporate_category_selection_expandable.dart';
// import '../corporate/corporate_documents.dart';
// import '../corporate/corporate_review_details_tracker.dart';
// import '../corporate/corporation_details_screen.dart';
// import '../corporate/individual_team/dashboard_individual_team_member.dart';
// import '../corporate/individual_team/set_passwort_invited_member_screen.dart';
// import '../misc/constants.dart';
// import '../widgets_reuse/custom_snackbar_message.dart';
// import 'package:http/http.dart' as http;
//
// class SignInSignUpHelpers {
//   static AnimationController? localAnimationController;
//   static File? frontImage;
//   static File? backImage;
//
//   static navigationAfterLogin(
//       BuildContext context, String status, String? empType) {
//     print('User navigationAfterLogin... status: $status, empType: $empType');
//
//     void navigateTo(Widget screen) => Navigator.push(
//         context, MaterialPageRoute(builder: (context) => screen));
//
//     switch (status) {
//       case "Verified":
//         showCustomSnackBar(context, 'Sign In Successful', buttonClr,
//             snackBarNeutralTextStyle, localAnimationController);
//
//         debugPrint('empType $empType');
//
//         if (empType == UserHelpers.empTypeUnderProvider) {
//           navigateTo(DashboardIndividualTeamMember());
//         } else if (empType == UserHelpers.empTypeCorporate) {
//           navigateTo(DashboardScreen());
//         } else {
//           context.pushNamed('dashboard');
//         }
//         break;
//
//       case "Service Selection Required":
//         context.pushNamed(SelectServicesScreen.routeName);
//         break;
//
//       case "PhotoId Required":
//         context.pushNamed('select_photo_id');
//         break;
//
//       case "Selfie Required":
//         navigateTo(SelfieCaptureScreen());
//         break;
//
//       case "Processing":
//         showCustomSnackBar(context, 'Registration Processing', buttonClr,
//             snackBarNeutralTextStyle, localAnimationController);
//         context.pushNamed('profile_pending');
//         break;
//
//       case "Rejected":
//         showCustomSnackBar(context, 'Registration Rejected', buttonClr,
//             snackBarNeutralTextStyle, localAnimationController);
//         break;
//
//       case "SSN Required":
//         context.pushNamed('ssn', pathParameters: {
//           'workerTextId': '${userBox.get('textId')}',
//           'workerStatus': '${userBox.get('status')}',
//         });
//         break;
//
//       case "Mailing Address Required":
//         empType == UserHelpers.empTypeCorporate
//             ? navigateTo(CorporateMailingAddress())
//             : context.pushNamed('mail', pathParameters: {
//                 'workerTextId': '${userBox.get('textId')}',
//                 'workerStatus': '${userBox.get('status')}',
//               });
//         break;
//
//       case "Pending Invitation":
//         navigateTo(SetPasswortInvitedMemberScreen());
//         break;
//
//       case "Documents Submitted":
//         debugPrint(
//             'DashboardHelpers.userModel!.workerDesignationTextId ${DashboardHelpers.userModel!.workerDesignationTextId}');
//         if (empType == UserHelpers.empTypeCorporateMember &&
//             DashboardHelpers.userModel!.workerDesignationTextId != "") {
//           context.pushNamed('profile_pending');
//           // Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewTeamMembersSubmittedDocuments()));
//           // navigateTo(ReviewTeamMembersSubmittedDocuments(empStatus: UserHelpers.empTypeUnderProvider,));
//         } else {
//           context.pushNamed('profile_pending');
//         }
//
//         break;
//
//       case "Pending Affiliation":
//       case "Pending Details":
//       case "Corporate Details":
//         navigateTo(CorporationDetaiils());
//         break;
//
//       case "Team Configuration":
//         navigateTo(AddTeamAndTeamMembers());
//         break;
//
//       case "Upload Documents":
//         navigateTo(CorporateDocuments());
//         break;
//
//       case "Category Selection":
//         navigateTo(CorporateServiceSelectionExpandable());
//         break;
//
//       case "Review Data":
//         navigateTo(CorporateReviewDetailsTracker());
//         break;
//
//       default:
//         showCustomSnackBar(context, 'Something Wrong', buttonClr,
//             snackBarNeutralTextStyle, localAnimationController);
//         break;
//     }
//   }
//
//   static navigationAfterSignUp(BuildContext context, String status) {
//     switch (status) {
//       case "PhotoId Required":
//         context.pushNamed('select_photo_id');
//         break;
//
//       case "Mailing Address Required":
//         context.pushNamed(
//           'mail',
//           pathParameters: {
//             'workerTextId': '${userBox.get('textId')}',
//             'workerStatus': '${userBox.get('status')}',
//           },
//         );
//         break;
//
//       //corporate
//       case "Pending Affiliation":
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => CorporationDetaiils()));
//         break;
//
//       case "Corporate Details":
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => CorporationDetaiils()));
//
//         break;
//
//       //new version
//
//       case "Selfie Required":
//         context.pushNamed('selfie_capture');
//         break;
//
//       default:
//         showCustomSnackBar(
//           context,
//           'Something Wrong',
//           buttonClr,
//           snackBarNeutralTextStyle,
//           localAnimationController,
//         );
//         break;
//     }
//   }
//
//   static Future postSelfie2(File selfieImage) async {
//     //print('postStartWork');
//     // var streamBeforeImage = ByteStream(beforeImage!.openRead());
//     //
//     // streamBeforeImage.cast();
//
//     // var streamAfterImage = ByteStream(afterImage!.openRead());
//     // streamAfterImage.cast();
//     print('#####____ POST START WORK ____#####');
//
//     print(token);
//
//     var header = {
//       "Authorization": "Bearer ${token}",
//     };
//
//     print(header);
//
//     var request =
//         MultipartRequest('POST', Uri.parse('${urlBase}api/WorkerSelfieUpdate'));
//
//     request.fields['workerTextId'] = '${userBox.get('textId')}';
//     request.fields['workerStatus'] = '${userBox.get('status')}';
//
//     request.headers.addAll(header);
//
//     request.files
//         .add(await MultipartFile.fromPath('selfieData', selfieImage.path));
//
//     // request.files.add(await MultipartFile.fromPath('photoIdData3', widget.backImage!.path));
//     // request.fields['photoIdData3'] = '';
//
//     print('Hello Wor 1');
//     // request.files
//     //     .add(await MultipartFile.fromPath('afterImage', afterImage!.path));
//
//     print('Hello World 2');
//
//     var response = await request.send();
//
//     print('Hello World 3');
//
//     // print(response.stream.toString());
//
//     print(response.statusCode);
//
//     if (response.statusCode == 200) {
//       response.stream.transform(utf8.decoder).listen((value) async {
//         print(value);
//         print(value.runtimeType);
//         print(jsonDecode(value)['worker_status']['status']);
//         await userBox.put(
//             'status', '${jsonDecode(value)['worker_status']['status']}');
//       });
//       print(response);
//       print('image uploaded');
//     } else {
//       print('failed');
//     }
//   }
//
//   static void setFrontImage(File? image) {
//     frontImage = image;
//     print('saved');
//   }
//
//   static void setBackImage(File? image) {
//     backImage = image;
//   }
//
//   static void clearImage() {
//     frontImage = null;
//     backImage = null;
//   }
//
//   static String formatDate(DateTime dateTime) {
//     // Format the DateTime object as a string
//     return DateFormat('dd-MMMM-yyyy').format(dateTime);
//   }
//
//   static Future<void> convertUrlImageToFile(
//       String imageUrl, String fileName) async {
//     final filename = '${DateTime.now().toString()}.jpg';
//
//     // Download and save the image
//
//     if (fileName == 'front') {
//       frontImage = await downloadImage(imageUrl, filename);
//     } else {
//       backImage = await downloadImage(imageUrl, filename);
//     }
//   }
//
//   static Future<File> downloadImage(String url, String filename) async {
//     // Fetch the image from the network
//     final response = await http.get(Uri.parse(url));
//
//     // Get the directory to save the image
//     final directory = await getApplicationDocumentsDirectory();
//
//     // Create a file in the directory
//     final file = File('${directory.path}/$filename');
//
//     // Write the image data to the file
//     return file.writeAsBytes(response.bodyBytes);
//   }
//
//   Future<void> saveString(String key, String value) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     debugPrint('RATING SAVE ${key} and ${value}');
//     await prefs.setString(key, value).then((e) {});
//   }
//
//   Future<String?> getString(String key) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key);
//   }
//
//   Future<void> saveJson(String key, Map<String, dynamic> value) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, jsonEncode(value));
//   }
//
//   Future<Map<String, dynamic>?> getJson(String key) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString(key);
//     if (jsonString != null) {
//       return jsonDecode(jsonString);
//     }
//     return null;
//   }
//
//   Future<void> remove(String key) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//   }
// }
//
// class CurrentDevice {
//   static late BuildContext context;
//
//   static setContext(BuildContext ctx) {
//     context = ctx;
//   }
//
//   static bool isAndroid() => kIsWeb == true
//       ? false
//       : ((Platform.isAndroid || MediaQuery.of(context).size.width <= 500)
//           ? true
//           : false);
// }
