import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/article_detail_screen.dart';
import '../loading_screens/loading_news.dart';  // Import LoadingCard widget

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;

  // Placeholder articles used if API fails or is empty
  final List<Map<String, String>> placeholderArticles = [
    {
      'title': 'Max Verstappen Wins Monaco GP!',
      'description': 'In a stunning display of skill, Max Verstappen took victory in the Monaco Grand Prix...',
      'link': 'https://example.com/monaco-gp-win',
    },
    {
      'title': 'Ferrari Announces New 2025 Car Design',
      'description': 'Ferrari revealed the design of their new 2025 car, focusing on aerodynamics and speed...',
      'link': 'https://example.com/ferrari-2025-car',
    },
    {
      'title': 'Lewis Hamilton Hints at Possible Retirement',
      'description': 'Lewis Hamilton speaks openly about his future plans in Formula 1 after 10 seasons...',
      'link': 'https://example.com/hamilton-retirement',
    },
    {
      'title': 'New Rules Impacting 2025 Season',
      'description': 'The FIA has released new rules aiming to make the races more competitive in 2025...',
      'link': 'https://example.com/fia-new-rules',
    },
    {
      'title': 'Young Drivers to Watch in 2025',
      'description': 'A list of up-and-coming drivers who are expected to make a mark in the upcoming F1 season...',
      'link': 'https://example.com/young-drivers-2025',
    },    {
      'title': 'Max Verstappen Wins Monaco GP!',
      'description': 'In a stunning display of skill, Max Verstappen took victory in the Monaco Grand Prix...',
      'link': 'https://example.com/monaco-gp-win',
    },
    {
      'title': 'Ferrari Announces New 2025 Car Design',
      'description': 'Ferrari revealed the design of their new 2025 car, focusing on aerodynamics and speed...',
      'link': 'https://example.com/ferrari-2025-car',
    },
    {
      'title': 'Lewis Hamilton Hints at Possible Retirement',
      'description': 'Lewis Hamilton speaks openly about his future plans in Formula 1 after 10 seasons...',
      'link': 'https://example.com/hamilton-retirement',
    },
    {
      'title': 'New Rules Impacting 2025 Season',
      'description': 'The FIA has released new rules aiming to make the races more competitive in 2025...',
      'link': 'https://example.com/fia-new-rules',
    },
    {
      'title': 'Young Drivers to Watch in 2025',
      'description': 'A list of up-and-coming drivers who are expected to make a mark in the upcoming F1 season...',
      'link': 'https://example.com/young-drivers-2025',
    }
  ];

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
              articles = placeholderArticles;
            }
            isLoading = false;
          });
        } else {
          // Fallback to placeholder if unexpected data
          setState(() {
            articles = placeholderArticles;
            isLoading = false;
          });
        }
      } else {
        // Non-200 status fallback
        setState(() {
          articles = placeholderArticles;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching news: $e');
      // On error, show placeholders
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
      // Show 5 loading skeleton cards using LoadingCard widget
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

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 162, 11, 11),
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
