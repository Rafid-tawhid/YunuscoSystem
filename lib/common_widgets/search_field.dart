// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
//
// class LocationSearchField extends StatelessWidget {
//   final String apiKey;
//   final ValueChanged<Map<String, dynamic>> onSuggestionSelected;
//   final String? initialValue;
//
//   const LocationSearchField({
//     Key? key,
//     required this.apiKey,
//     required this.onSuggestionSelected,
//     this.initialValue,
//   }) : super(key: key);
//
//   Future<List<Map<String, dynamic>>> _getSuggestions(String query) async {
//     if (query.isEmpty) return [];
//
//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&types=geocode&language=en',
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
//   @override
//   Widget build(BuildContext context) {
//     return TypeAheadField<Map<String, dynamic>>(
//       textFieldConfiguration: TextFieldConfiguration(
//         controller: initialValue != null
//             ? TextEditingController(text: initialValue)
//             : null,
//         decoration: InputDecoration(
//           labelText: 'Search location',
//           hintText: 'Enter an address',
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//       suggestionsCallback: _getSuggestions,
//       itemBuilder: (context, suggestion) {
//         return ListTile(
//           leading: const Icon(Icons.location_on),
//           title: Text(suggestion['description']),
//         );
//       },
//       onSuggestionSelected: onSuggestionSelected,
//       noItemsFoundBuilder: (context) => const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Text('No locations found'),
//       ),
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