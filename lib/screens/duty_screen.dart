import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';

class DutyScreen extends StatefulWidget {
  const DutyScreen({super.key});

  @override
  State<DutyScreen> createState() => _DutyScreenState();
}

class _DutyScreenState extends State<DutyScreen> {
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
        title: const Text('Duty'),
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
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: Dimensions.lgSize,
                      ),
                      decoration: BoxDecoration(
                        color: RGB.white,
                        border: Border.all(
                          width: 1,
                          color: RGB.lightPrimary,
                        ),
                        borderRadius: BorderRadius.circular(
                          Dimensions.defaultSize,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: Get.width / 1.5,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                top: Dimensions.smSize,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimensions.defaultSize,
                                  ),
                                  topRight: Radius.circular(
                                    Dimensions.defaultSize,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: dataList[index]['photo'],
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: 200,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/loading.jpg',
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/loading.jpg',
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Text(
                              dataList[index]['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: Dimensions.defaultSize,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Text(
                              dataList[index]['description'],
                              style: const TextStyle(
                                fontSize: Dimensions.smSize,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.defaultSize,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dataList[index]['price'] + 'RM',
                                  style: const TextStyle(
                                    fontSize: Dimensions.lgSize * 1.25,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Map sessionUser = await Session().user();
                                    bool isLogin = await Session().isLogin();
                                    if (isLogin) {
                                      EasyLoading.show();
                                      // call api part
                                      try {
                                        Response response = await Dio().post(
                                          URL.orderAddURL,
                                          data: FormData.fromMap({
                                            'type': 'duty',
                                            'duty_id': dataList[index]['id'],
                                            'staff_id': sessionUser['id'],
                                            'price': dataList[index]['price'],
                                          }),
                                        );
                                        Map data = jsonDecode(response.data);
                                        if (data['error']) {
                                          EasyLoading.dismiss();
                                          SnackBarUtils.show(
                                              title: data['message'],
                                              isError: true);
                                        } else {
                                          EasyLoading.dismiss();
                                          SnackBarUtils.show(
                                              title: data['message'],
                                              isError: false);
                                          Get.offAllNamed('home');
                                        }
                                      } catch (e) {
                                        SnackBarUtils.show(
                                            title: e.toString(), isError: true);
                                      }
                                    } else {
                                      Get.toNamed('/signin');
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.lgSize,
                                    ),
                                    child: Text('Book Now'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.smSize,
                          ),
                        ],
                      ),
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
        URL.dutyURL,
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
