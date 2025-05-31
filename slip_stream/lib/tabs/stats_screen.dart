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
    return GridView.builder(
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
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              // TODO: Navigate to details later
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped: ${item['title']}')),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'], size: 48, color: Colors.deepPurple),
                const SizedBox(height: 12),
                Text(
                  item['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
