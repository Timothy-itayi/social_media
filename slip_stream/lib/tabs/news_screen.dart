import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/article_detail_screen.dart';
import '../loading_screens/loading_news.dart';
import '../data/place_holder_articles.dart'; // Your local placeholder data

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchF1News();
  }

  Future<void> fetchF1News() async {
    final url = Uri.parse('https://f1-news1.p.rapidapi.com/f1news');
    final headers = {
      'x-rapidapi-host': dotenv.env['RAPIDAPI_HOST'] ?? '',
      'x-rapidapi-key': dotenv.env['RAPIDAPI_KEY'] ?? '',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final newsList = jsonResponse['F1News'];

        if (newsList is List) {
          final seenNormalizedTitles = <String>{};
          final uniqueArticles = <dynamic>[];

          String normalizeTitle(String title) {
            return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
          }

          for (var article in newsList) {
            final title = article['title'] ?? '';
            final normalized = normalizeTitle(title);

            if (normalized.isNotEmpty && !seenNormalizedTitles.contains(normalized)) {
              seenNormalizedTitles.add(normalized);
              uniqueArticles.add(article);
            }
          }

          setState(() {
            if (uniqueArticles.isNotEmpty) {
              articles = uniqueArticles;
            } else {
              // Use placeholder articles with image assets
              articles = placeholderArticles;
            }
            isLoading = false;
          });
        } else {
          setState(() {
            articles = placeholderArticles;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          articles = placeholderArticles;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        articles = placeholderArticles;
        isLoading = false;
      });
    }
  }

  String _cleanDescription(String rawDesc, {int maxLen = 120}) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    String cleaned = rawDesc.replaceAll(regex, '');
    if (cleaned.length > maxLen) {
      return cleaned.substring(0, maxLen).trim() + '...';
    }
    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const LoadingCard(),
      );
    }

    if (articles.isEmpty) {
      return const Center(child: Text("No news available."));
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final title = article['title'] ?? 'No title';
        final shortDescription = _cleanDescription(article['description'] ?? '');
        final imageAsset = article['imageAsset'] ?? ''; // asset path from placeholder data

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: InkWell(
            onTap: () {
             Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ArticleDetailScreen(
      title: title,
      description: article['description'] ?? '',
      link: article['link'] ?? '',
      imageAsset: imageAsset,  // pass image path here
    ),
  ),
);

            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 162, 11, 11),
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (imageAsset.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imageAsset,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (imageAsset.isNotEmpty) const SizedBox(height: 8),
                  Text(
                    shortDescription,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
