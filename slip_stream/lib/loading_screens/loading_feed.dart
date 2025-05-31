import 'package:flutter/material.dart';

class FeedLoadingWidget extends StatelessWidget {
  const FeedLoadingWidget({super.key});

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + username row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 10, color: Colors.grey.shade300),
                  const SizedBox(height: 6),
                  Container(width: 60, height: 8, color: Colors.grey.shade300),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Shared text
          Container(width: double.infinity, height: 12, color: Colors.grey.shade300),

          const SizedBox(height: 12),

          /// Article box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: double.infinity, height: 12, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 10, color: Colors.grey.shade300),
                const SizedBox(height: 6),
                Container(width: 80, height: 10, color: Colors.grey.shade300),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Action buttons (just icons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (_) {
              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5, // Show 5 skeletons
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }
}
