// lib/tabs/stats_screen.dart
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  final List<Map<String, dynamic>> statsItems = const [
    {'title': 'Driver Standings', 'icon': Icons.person},
    {'title': 'Constructors', 'icon': Icons.precision_manufacturing},
    {'title': 'Qualifying', 'icon': Icons.timer},
    {'title': 'Practice', 'icon': Icons.fitness_center},
    {'title': 'Race', 'icon': Icons.sports_motorsports},
    {'title': 'Sprint', 'icon': Icons.flash_on},
    {'title': 'Head to Head', 'icon': Icons.compare_arrows},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Dark background for that F1 vibe
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: statsItems.length,
        itemBuilder: (context, index) {
          final item = statsItems[index];
          return Card(
            color: Colors.grey[900],
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to details later
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped: ${item['title']}'),
                    backgroundColor: Colors.redAccent.shade700,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.redAccent.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    size: 52,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.1,
                      fontFamily: 'F1Font', // Optional: add a racing-style font asset
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
