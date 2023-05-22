import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:travel/widget/app_widget.dart';

class HotelViewScreen extends StatefulWidget {
  const HotelViewScreen({super.key});

  @override
  State<HotelViewScreen> createState() => _HotelViewScreenState();
}

class _HotelViewScreenState extends State<HotelViewScreen> {
  bool isLoaded = false;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        title: const Text('Hotels'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          color: RGB.grey.withOpacity(0.25),
          child: isLoaded
              ? ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return AppWidget.hotelListView(
                      id: dataList[index]['hotel_id'],
                      picture:
                          '${URL.photoURL}hotels/${dataList[index]['photo']}',
                      name: dataList[index]['name'],
                      location: dataList[index]['address'],
                      onPressed: () {
                        Get.toNamed('/hotel_details', parameters: {
                          'id': dataList[index]['id'].toString(),
                          'name': dataList[index]['name'].toString(),
                          'location': dataList[index]['address'].toString(),
                          'description':
                              dataList[index]['description'].toString(),
                          'picture':
                              '${URL.photoURL}hotels/${dataList[index]['photo']}',
                          'price': dataList[index]['price'].toString(),
                        });
                      },
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
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
    setState(() {});
  }
}
