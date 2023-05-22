import 'dart:convert';
import 'dart:math' as math;

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
import 'package:unicons/unicons.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({super.key});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      appBar: AppBar(
        leadingWidth: Dimensions.defaultSize * 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Get.parameters['name'].toString(),
            ),
            Row(
              children: [
                const Icon(
                  UniconsLine.location_point,
                  color: RGB.lightDarker,
                  size: Dimensions.defaultSize,
                ),
                Expanded(
                  child: Text(
                    Get.parameters['location'].toString(),
                    maxLines: 1,
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 240,
                        child: CachedNetworkImage(
                          imageUrl: Get.parameters['picture'].toString(),
                          width: Get.width,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/loading.jpg',
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/loading.jpg',
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: Dimensions.defaultSize,
                        right: Dimensions.defaultSize,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.smSize / 2,
                            horizontal: Dimensions.smSize,
                          ),
                          decoration: BoxDecoration(
                            color: RGB.dark.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(
                              Dimensions.circleSize,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.photo_library,
                                color: RGB.white,
                                size: Dimensions.lgSize,
                              ),
                              Text(
                                ' +11',
                                style: TextStyle(
                                  color: RGB.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      Dimensions.defaultSize,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.parameters['name'].toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: Dimensions.lgSize + 4,
                            color: RGB.dark,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.star,
                              color: RGB.darkYellow,
                              size: Dimensions.defaultSize,
                            ),
                            Icon(
                              Icons.star,
                              color: RGB.darkYellow,
                              size: Dimensions.defaultSize,
                            ),
                            Icon(
                              Icons.star,
                              color: RGB.darkYellow,
                              size: Dimensions.defaultSize,
                            ),
                            Icon(
                              Icons.star,
                              color: RGB.darkYellow,
                              size: Dimensions.defaultSize,
                            ),
                            Icon(
                              Icons.star,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize / 2,
                        ),
                        Row(
                          children: [
                            const Icon(
                              UniconsLine.location_point,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            Expanded(
                              child: Text(
                                Get.parameters['location'].toString(),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: Dimensions.smSize,
                                  color: RGB.lightDarker,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            Dimensions.smSize,
                          ),
                          decoration: BoxDecoration(
                            color: RGB.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusSize,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.exit_to_app,
                                    size: Dimensions.lgSize,
                                  ),
                                  SizedBox(
                                    width: Dimensions.smSize / 2,
                                  ),
                                  Text('Check-in: 2:00 PM'),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.rotate(
                                    angle: -math.pi,
                                    child: const Icon(
                                      Icons.exit_to_app,
                                      size: Dimensions.lgSize,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.smSize / 2,
                                  ),
                                  const Text('Check-out: 12:00 PM'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        // feature
                        Row(
                          children: const [
                            Icon(
                              Icons.group,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text('6 Guests'),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.wifi,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text('Wifi'),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.pool,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text('Pool'),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.restaurant,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text('Restaurant'),
                          ],
                        ),
                        const SizedBox(
                          height: Dimensions.smSize,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.local_bar,
                              color: RGB.lightDarker,
                              size: Dimensions.defaultSize,
                            ),
                            SizedBox(
                              width: Dimensions.smSize,
                            ),
                            Text('Bar'),
                          ],
                        ),
                        // feature
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(
                Dimensions.defaultSize,
              ),
              decoration: BoxDecoration(
                color: RGB.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    Dimensions.defaultSize,
                  ),
                  topRight: Radius.circular(
                    Dimensions.defaultSize,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Get.parameters['price']} RM',
                    style: const TextStyle(
                      fontSize: Dimensions.lgSize + 4,
                      fontWeight: FontWeight.w700,
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
                              'type': 'hotel',
                              'hotel_id': Get.parameters['id'],
                              'staff_id': sessionUser['id'],
                              'price': Get.parameters['price'],
                            }),
                          );
                          Map data = jsonDecode(response.data);
                          if (data['error']) {
                            EasyLoading.dismiss();
                            SnackBarUtils.show(
                                title: data['message'], isError: true);
                          } else {
                            EasyLoading.dismiss();
                            SnackBarUtils.show(
                                title: data['message'], isError: false);
                            if (mounted) {
                              Get.offAllNamed('home');
                            }
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
          ],
        ),
      ),
    );
  }
}
