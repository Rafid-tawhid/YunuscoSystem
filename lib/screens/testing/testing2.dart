// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
//
//
//
// final itemsProvider = FutureProvider<List<String>>((ref) async {
//   await Future.delayed(Duration(seconds: 2)); // simulate delay
//   return ['Apple', 'Banana', 'Orange', 'Mango'];
// });
//
// class TestingScreen extends ConsumerWidget {
//   const TestingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context,WidgetRef ref) {
//     var data=ref.watch(itemsProvider);
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text('Counting'),
//       ),
//       body: data.when(
//       data:(item){
//         return data.m;
//       }, error: (Object error, StackTrace stackTrace) {
//
//       }, loading: () {
//
//       }
//
//       ),
//     );
//   }
// }
