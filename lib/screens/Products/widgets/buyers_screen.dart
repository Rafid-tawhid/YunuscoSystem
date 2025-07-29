import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/widgets/product_screen_header.dart';
import 'package:yunusco_group/screens/Products/widgets/shimmer_image.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:flutter/services.dart';

import '../buyer_wise_material_list.dart';


class BuyersScreen extends StatefulWidget {
  @override
  _BuyersScreenState createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  @override
  void initState() {
    super.initState();
    getAllCategoryAndBuyerInfo();
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Consumer<ProductProvider>(
          builder: (context, provider, _) => Text(
            provider.isSelectCat ? 'Categories' : 'Buyers',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              var provider=context.read<ProductProvider>();
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  // Position the menu below the button
                  MediaQuery.of(context).size.width - 160, // Right offset
                  80.0, // Top offset (adjust based on your app bar height)
                  MediaQuery.of(context).size.width, // Left offset
                  0, // Bottom offset
                ),
                items: [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.check, color: provider.isSelectCat ? Colors.green : Colors.transparent),
                        SizedBox(width: 8),
                        Text('Categories'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.check, color: !provider.isSelectCat ? Colors.green : Colors.transparent),
                        SizedBox(width: 8),
                        Text('Buyers'),
                      ],
                    ),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value != null) {
                  // Handle menu item selection

                  debugPrint('This is value ren $value');
                  switch (value) {
                    case 1:
                      provider.setSelector(true);
                      break;
                    case 2:
                      provider.setSelector(false);
                      break;
                  }
                }
              });
            },
            icon: Icon(Icons.menu, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            // ProductScreenHeader(),
            // Category List
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  if (provider.allBuyerList.isEmpty) {
                    return _buildLoadingShimmer();
                  }
                  return _buildBuyerGrid(provider);
                  return provider.isSelectCat? _buildCategoryGrid(provider):_buildBuyerGrid(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRandomImageUrl() {
    // List of image URLs
    final List<String> imageUrls = [
      'https://cdn.pixabay.com/photo/2016/12/06/09/30/blank-1886001_640.png',
      'https://i.pinimg.com/564x/c1/1d/16/c11d164de692594acf53c9a855093139.jpg',
      'https://t3.ftcdn.net/jpg/00/61/87/62/360_F_61876261_FUoySFWEGESVVmMuqJidqri9r5hA0ln5.jpg',
      'https://assets.ajio.com/medias/sys_master/root/20230909/Ye7Z/64fb749cafa4cf41f5d49c15/-473Wx593H-466550113-red-MODEL.jpg',
    ];

    // Create a random number generator
    final random = Random();

    // Get a random index between 0 and the number of URLs minus 1
    final randomIndex = random.nextInt(imageUrls.length);

    // Return the randomly selected URL
    return imageUrls[randomIndex];
  }

  Widget _buildCategoryGrid(ProductProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: provider.allCategoryList.length,
        itemBuilder: (context, index) {
          final item = provider.allCategoryList[index];
          return _buildCategoryItem(
            title: item["itemCode"]!,
            subtitle: item["catagoryName"]!,
            //image: item["catagoryImg"]!,
            image: getRandomImageUrl(),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle category tap
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    ImageWithShimmer(
                      imageUrl: image,
                      defaultImage: "assets/images/default_img.png",
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBuyerGrid(ProductProvider provider) {
    // Define a list of colors for the name backgrounds
    final List<Color> nameColors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
      Colors.red.shade100,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2, // Slightly taller than wide
        ),
        itemCount: provider.allBuyerList.length,
        itemBuilder: (context, index) {
          final item = provider.allBuyerList[index];
          final colorIndex = index % nameColors.length;
          final color = nameColors[colorIndex];

          return _buildBuyerItem(
            name: item["Name"] ?? "Unknown Buyer",
            code: item["Code"].toString(),
            color: color,
          );
        },
      ),
    );
  }

  Widget _buildBuyerItem({
    required String name,
    required String code,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          var pp=context.read<ProductProvider>();
          if(await pp.getBuyerWiseMaterialList(code)){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>BuyerWiseMaterialList(buyerName: name)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colorful name container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Code with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void getAllCategoryAndBuyerInfo() async {
    var pp = context.read<ProductProvider>();
   // pp.getAllCategoryList();
    pp.getAllBuyerInfo();
  }
}

