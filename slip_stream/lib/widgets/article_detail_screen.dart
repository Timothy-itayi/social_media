import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tabs/article_content_controller.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String link;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ArticleContentController(description);
    final paragraphs = controller.getParagraphs();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Nav Bar with back arrow and app name centered
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  // Back arrow button on the left
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // Spacer to push app name to center
                  Expanded(
                    child: Center(
                      child: Text(
                        'F1 News',  // Your app name here
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  // To balance the Row, add a SizedBox equal width of IconButton
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Article Title with multiple lines, bold, plenty of space
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Article Content - scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...paragraphs.map(
                      (para) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          para,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            letterSpacing: 0.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    if (link.isNotEmpty)
                      TextButton.icon(
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Read full article'),
                        onPressed: () async {
                          final uri = Uri.tryParse(link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not open link')),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
