import 'package:flutter/material.dart';

class CategoryItem {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final Color color;
  final String imageUrl;
  final List<String> subcategories;

  CategoryItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.color,
    required this.imageUrl,
    this.subcategories = const [],
  });
}
