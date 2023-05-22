import 'package:flutter/material.dart';
import 'package:travel/models/category_model.dart';

List categoryData = [
  CategoryModel(
    name: 'Hotels',
    routeName: 'search',
    icon: Icons.apartment_outlined,
  ),
  CategoryModel(
    name: 'Cars',
    routeName: 'search',
    icon: Icons.local_taxi_outlined,
  ),
  CategoryModel(
    name: 'Packages',
    routeName: 'package',
    icon: Icons.redeem_outlined,
  ),
  CategoryModel(
    name: 'Duty Free',
    routeName: 'duty',
    icon: Icons.shopping_bag_outlined,
  ),
  CategoryModel(
    name: 'Restaurant',
    routeName: 'restaurant',
    icon: Icons.restaurant_outlined,
  ),
];
