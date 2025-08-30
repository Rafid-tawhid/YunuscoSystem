// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart'; // Assuming this contains your custom TypeAheadField
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class LocationSearchField extends StatelessWidget {
//   final String apiKey;
//   final ValueChanged<Map<String, dynamic>> onSuggestionSelected;
//   final String? initialValue;
//   final String? lable;
//   final TextEditingController? controller;
//
//   LocationSearchField({
//     Key? key,
//     required this.apiKey,
//     required this.onSuggestionSelected,
//     this.initialValue,
//     this.lable
//   }) : controller = TextEditingController(text: initialValue ?? ''),
//         super(key: key);
//
//   Future<List<Map<String, dynamic>>> _getSuggestions(String pattern) async {
//     if (pattern.isEmpty || pattern.length < 3) return [];
//
//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$pattern&key=$apiKey&types=geocode&language=en',
//     );
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           return List<Map<String, dynamic>>.from(data['predictions']);
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error fetching suggestions: $e');
//       return [];
//     }
//   }
//
//   Widget _itemBuilder(BuildContext context, Map<String, dynamic> suggestion) {
//     return ListTile(
//       leading: const Icon(Icons.location_on),
//       title: Text(suggestion['description']),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Use your custom TypeAheadField from the codebase
//     return TypeAheadField<Map<String, dynamic>>(
//       controller: controller,
//       builder: (context, controller, focusNode) => TextField(
//         controller: controller,
//         focusNode: focusNode,
//         decoration:  InputDecoration(
//           labelText: lable??'Search location',
//           hintText: 'Enter an address',
//           prefixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//       itemBuilder: _itemBuilder,
//       onSelected: onSuggestionSelected,
//       suggestionsCallback: _getSuggestions,
//       debounceDuration: const Duration(milliseconds: 300),
//       // Add other parameters based on your custom TypeAheadField implementation
//       decorationBuilder: (context, child) => Material(
//         type: MaterialType.card,
//         elevation: 4,
//         borderRadius: BorderRadius.circular(10),
//         child: child,
//       ),
//       // noItemsFoundBuilder: (context) => const Padding(
//       //   padding: EdgeInsets.all(16.0),
//       //   child: Text('No locations found'),
//       // ),
//       loadingBuilder: (context) => const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SizedBox(
//           height: 50,
//           child: Center(child: CircularProgressIndicator()),
//         ),
//       ),
//       errorBuilder: (context, error) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text('Error: $error'),
//       ),
//     );
//   }
// }
