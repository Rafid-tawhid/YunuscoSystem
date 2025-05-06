// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yunusco_group/providers/product_provider.dart';
//
// import '../../../utils/colors.dart';
//
// class ProductScreenHeader extends StatefulWidget {
//   const ProductScreenHeader({super.key});
//
//   @override
//   State<ProductScreenHeader> createState() => _ProductScreenHeaderState();
// }
//
// class _ProductScreenHeaderState extends State<ProductScreenHeader> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: myColors.primaryColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       child: Consumer<ProductProvider>(
//         builder: (context, provider, _) => Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Hero(
//               tag: 'app_logo',
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   borderRadius: BorderRadius.circular(50),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.asset(
//                       'assets/images/logo1-min.png',
//                       width: 60,
//                       height: 60,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               provider.isSelectCat ? 'Categories' : 'Buyers',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 showMenu(
//                   context: context,
//                   position: RelativeRect.fromLTRB(
//                     // Position the menu below the button
//                     MediaQuery.of(context).size.width - 160, // Right offset
//                     80.0, // Top offset (adjust based on your app bar height)
//                     MediaQuery.of(context).size.width, // Left offset
//                     0, // Bottom offset
//                   ),
//                   items: [
//                     PopupMenuItem(
//                       value: 1,
//                       child: Row(
//                         children: [
//                           Icon(Icons.check, color: provider.isSelectCat ? Colors.green : Colors.transparent),
//                           SizedBox(width: 8),
//                           Text('Categories'),
//                         ],
//                       ),
//                     ),
//                     PopupMenuItem(
//                       value: 2,
//                       child: Row(
//                         children: [
//                           Icon(Icons.check, color: !provider.isSelectCat ? Colors.green : Colors.transparent),
//                           SizedBox(width: 8),
//                           Text('Buyers'),
//                         ],
//                       ),
//                     ),
//                   ],
//                   elevation: 8.0,
//                 ).then((value) {
//                   if (value != null) {
//                     // Handle menu item selection
//
//                     debugPrint('This is value ren $value');
//                     switch (value) {
//                       case 1:
//                         provider.setSelector(true);
//                         break;
//                       case 2:
//                         provider.setSelector(false);
//                         break;
//                     }
//                   }
//                 });
//               },
//               icon: Icon(Icons.menu, color: Colors.white),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
