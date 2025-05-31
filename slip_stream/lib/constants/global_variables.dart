import 'package:flutter/material.dart';

String uri = 'http://<yourip>:3000';

class GlobalVariables {
  // COLORS - Formula 1 inspired (black, red, white, silver)
  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xFFEF0107), // F1 Red
      Color(0xFF000000), // Black
    ],
    stops: [0.0, 1.0],
  );

  static const secondaryColor = Color(0xFFB3B3B3); // Silver / Grey
  static const backgroundColor = Colors.black;
  static const Color greyBackgroundCOlor = Color(0xFF1C1C1C);
  static var selectedNavBarColor = Color(0xFFEF0107); // F1 Red
  static const unselectedNavBarColor = Colors.white70;

  // STATIC IMAGES - Replace URLs with your own hosted F1 assets or local assets
  static const List<String> carouselImages = [
    'https://upload.wikimedia.org/wikipedia/en/thumb/9/93/Formula_One_Logo.svg/1200px-Formula_One_Logo.svg.png',
    'https://www.formula1.com/content/dam/fom-website/manual/Misc/2023_F1_Cars_Montage_desktop_1920x1080.jpg.transform/9col/image.jpg',
    'https://cdn-2.motorsport.com/images/amp/4a7ekvK2/s6/f1-2023-season-review-graphic.jpg',
    'https://cdn.motor1.com/images/mgl/Y6x0b/s3/f1-2024-car-concepts.jpg',
    'https://media.formula1.com/image/upload/f_auto,q_auto,w_1920,h_1080,c_fill,g_auto/v1/formula1/2024-season-logo',
  ];

  static const List<Map<String, String>> categoryImages = [
    {'title': 'Teams', 'image': 'assets/images/teams.jpeg'},
    {'title': 'Drivers', 'image': 'assets/images/drivers.jpeg'},
    {'title': 'Circuits', 'image': 'assets/images/circuits.jpeg'},
    {'title': 'Race Highlights', 'image': 'assets/images/race_highlights.jpeg'},
    {'title': 'Championship', 'image': 'assets/images/championship.jpeg'},
  ];
}
