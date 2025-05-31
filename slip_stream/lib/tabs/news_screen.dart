import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/article_detail_screen.dart';

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
      print('Raw body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final newsList = jsonResponse['F1News'];

        if (newsList is List) {
          final seenNormalizedTitles = <String>{};
          final uniqueArticles = <dynamic>[];

          String normalizeTitle(String title) {
            // Lowercase and remove all non-alphanumeric chars
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
            articles = uniqueArticles;
            isLoading = false;
          });
        } else {
          throw Exception('F1News key is not a list');
        }
      } else {
        throw Exception('Failed to load news (${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper to strip html tags and get a short snippet
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
      return const Center(child: CircularProgressIndicator());
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

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                decoration: TextDecoration.underline,
              ),
            ),
            subtitle: Text(shortDescription),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(
                    title: title,
                    description: article['description'] ?? '',
                    link: article['link'] ?? '',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
