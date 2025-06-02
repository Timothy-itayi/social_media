import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final String? imageAsset;  // new optional image parameter

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    this.imageAsset,  // optional
  });

  void _launchURL(BuildContext context) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch article link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        backgroundColor: Colors.red.shade900,
      ),
      body: SingleChildScrollView( // Wrap for scrollability if content is long
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),

            // Display image if available
            if (imageAsset != null && imageAsset!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageAsset!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
            ],

            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 2.5,
                letterSpacing: 1.4,
              ),
            ),

            // You can add your link launch button here if you want
            // For example:
            // TextButton(
            //   onPressed: () => _launchURL(context),
            //   child: const Text('Read full article'),
            // ),
          ],
        ),
      ),
    );
  }
}
