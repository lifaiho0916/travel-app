import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map sessionUser = {};
  bool isLogin = false;
  bool isLoaded = false;
  List hotelDataList = [];
  List carDataList = [];
  List packagesDataList = [];
  List dutyDataList = [];
  List restaurantDataList = [];

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? isLogin
            ? SizedBox(
                height: Get.height,
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        labelColor: RGB.dark,
                        tabs: [
                          Tab(
                            text: 'Hotels',
                            icon: Icon(Icons.apartment_outlined),
                          ),
                          Tab(
                            text: 'Cars',
                            icon: Icon(Icons.local_taxi_outlined),
                          ),
                          Tab(
                            text: 'Packages',
                            icon: Icon(Icons.redeem_outlined),
                          ),
                          Tab(
                            text: 'Duty',
                            icon: Icon(Icons.shopping_bag_outlined),
                          ),
                          Tab(
                            text: 'Restaurant',
                            icon: Icon(Icons.restaurant_outlined),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            hotelDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: hotelDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          hotelDataList[index]['name'],
                                          hotelDataList[index]['end_date'],
                                          hotelDataList[index]['price'] + 'RM',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no hotels order!'),
                                  ),
                            carDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: carDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          carDataList[index]['name'],
                                          carDataList[index]['end_date'],
                                          carDataList[index]['price'] + 'RM',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no cars order!'),
                                  ),
                            packagesDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: packagesDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          packagesDataList[index]['name'],
                                          packagesDataList[index]['end_date'],
                                          packagesDataList[index]['price'] +
                                              'RM',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no packages order!'),
                                  ),
                            dutyDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dutyDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          dutyDataList[index]['name'],
                                          dutyDataList[index]['end_date'],
                                          dutyDataList[index]['price'] + 'RM',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text('There is no duty order!'),
                                  ),
                            restaurantDataList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.defaultSize,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: restaurantDataList.length,
                                      itemBuilder: (context, index) {
                                        return dataView(
                                          restaurantDataList[index]['name'],
                                          restaurantDataList[index]['end_date'],
                                          restaurantDataList[index]['price'] +
                                              'RM',
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child:
                                        Text('There is no restaurant order!'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text('Please, login first!'),
              )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  // functional task
  void initApp() async {
    sessionUser = await Session().user();
    isLogin = await Session().isLogin();
    if (isLogin) {
      // call api part
      try {
        Response response = await Dio().post(
          URL.orderURL,
          data: FormData.fromMap({
            'staff_id': sessionUser['id'],
          }),
        );
        Map data = jsonDecode(response.data);
        if (data['error']) {
          SnackBarUtils.show(title: data['message'], isError: true);
        } else {
          hotelDataList = data['hotels'];
          carDataList = data['cars'];
          packagesDataList = data['packages'];
          dutyDataList = data['duty'];
          restaurantDataList = data['restaurant'];
        }
      } catch (e) {
        SnackBarUtils.show(title: e.toString(), isError: true);
      }
    }
    isLoaded = true;
    if (mounted) {
      setState(() {});
    }
  }

  Widget dataView(name, endDate, price) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.smSize,
        horizontal: Dimensions.defaultSize,
      ),
      margin: const EdgeInsets.only(
        bottom: Dimensions.smSize,
      ),
      decoration: BoxDecoration(
        color: RGB.lightDarker.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          Dimensions.radiusSize,
        ),
      ),
      child: ListTile(
        onTap: () {},
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(
            Dimensions.smSize / 2,
          ),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: RGB.muted,
            borderRadius: BorderRadius.circular(
              Dimensions.circleSize,
            ),
          ),
          child: const Icon(UniconsLine.bag),
        ),
        title: Text(name),
        subtitle: Text(
          endDate,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Text(
          price,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
