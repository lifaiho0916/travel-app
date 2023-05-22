import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/url.dart';
import 'package:travel/data/category_data.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

class HomeStatusScreen extends StatefulWidget {
  const HomeStatusScreen({super.key});

  @override
  State<HomeStatusScreen> createState() => _HomeStatusScreenState();
}

class _HomeStatusScreenState extends State<HomeStatusScreen> {
  bool isLoaded = false;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.defaultSize,
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryData.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        categoryData[index].routeName,
                        parameters: {
                          'name': categoryData[index].name,
                        },
                      );
                    },
                    child: Container(
                      width: 90,
                      margin: EdgeInsets.only(
                        right: index == categoryData.length - 1
                            ? Dimensions.zeroSize
                            : Dimensions.smSize / 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              Dimensions.smSize,
                            ),
                            decoration: BoxDecoration(
                              color: RGB.primary,
                              borderRadius: BorderRadius.circular(
                                Dimensions.circleSize,
                              ),
                            ),
                            child: Icon(
                              categoryData[index].icon,
                              color: RGB.white,
                              size: Dimensions.defaultSize * 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize / 4,
                          ),
                          Text(
                            categoryData[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: Dimensions.smSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const Text('Recommended For You'),
          const Text(
            'Based on your recent activity',
            style: TextStyle(
              fontSize: Dimensions.smSize,
              color: RGB.lightDarker,
            ),
          ),
          const SizedBox(
            height: Dimensions.defaultSize,
          ),
          isLoaded == true
              ? SizedBox(
                  height: 310,
                  width: Get.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/hotel_details', parameters: {
                            'id': dataList[index]['hotel_id'].toString(),
                            'name': dataList[index]['name'].toString(),
                            'location': dataList[index]['address'].toString(),
                            'description':
                                dataList[index]['description'].toString(),
                            'picture':
                                '${URL.photoURL}hotels/${dataList[index]['photo']}',
                            'price': dataList[index]['price'].toString(),
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: Dimensions.defaultSize,
                          ),
                          width: Get.width / 1.75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.defaultSize,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${URL.photoURL}hotels/${dataList[index]['photo']}',
                                  height: 230,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/loading.jpg',
                                    height: 230,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/loading.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.smSize / 2,
                              ),
                              Text(
                                dataList[index]['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: Dimensions.lgSize,
                                  color: RGB.lightDarker,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    UniconsLine.location_point,
                                    color: RGB.lightDarker,
                                    size: Dimensions.defaultSize,
                                  ),
                                  Expanded(
                                    child: Text(
                                      dataList[index]['address'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: Dimensions.smSize,
                                        color: RGB.lightDarker,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  // functional task
  void initApp() async {
    // call api part
    try {
      Response response = await Dio().get(
        URL.hotelURL,
      );
      Map data = jsonDecode(response.data);
      if (data['error']) {
        SnackBarUtils.show(title: data['message'], isError: true);
      } else {
        dataList = data['data'];
        isLoaded = true;
      }
    } catch (e) {
      SnackBarUtils.show(title: e.toString(), isError: true);
    }
    if (mounted) {
      setState(() {});
    }
  }
}
