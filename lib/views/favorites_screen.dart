import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/widgets/app_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return;
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(spacing: 14, children: [MyAppBar()]),
      ),
    );
  }
}
