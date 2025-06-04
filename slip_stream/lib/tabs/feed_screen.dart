import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:slip_stream/loading_screens/loading_feed.dart';
import 'create_post.dart';
import '../data/place_holder_articles.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  final random = Random();

  final List<Map<String, String>> demoUsers = [
    {'username': 'gridmaster', 'avatar': 'assets/profile00.jpg'},
    {'username': 'f1fan2025', 'avatar': 'assets/profile01.jpg'},
    {'username': 'paddockqueen', 'avatar': 'assets/profile02.jpg'},
    {'username': 'raceguru', 'avatar': 'assets/profile03.jpg'},
    {'username': 'verstappenvibes', 'avatar': 'assets/profile04.jpg'},
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

        final seen = <String>{};
        final uniqueArticles = <dynamic>[];

        String normalizeTitle(String title) =>
            title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

        for (var article in newsList) {
          final title = article['title'] ?? '';
          final normalized = normalizeTitle(title);
          if (normalized.isNotEmpty && !seen.contains(normalized)) {
            seen.add(normalized);
            uniqueArticles.add(article);
          }
        }

        setState(() {
          articles = uniqueArticles;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
      // Use local placeholder articles (with imageAsset field)
      setState(() {
        articles = placeholderArticles;
        isLoading = false;
      });
    }
  }

  DateTime _randomTimestamp() {
    return DateTime.now().subtract(Duration(minutes: random.nextInt(1440)));
  }

  String _cleanDescription(String rawDesc, {int maxLen = 120}) {
    final regex = RegExp(r'<[^>]*>');
    final cleaned = rawDesc.replaceAll(regex, '');
    return cleaned.length > maxLen ? cleaned.substring(0, maxLen).trim() + '...' : cleaned;
  }

  void _interact(BuildContext context, String action, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action: $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const FeedLoadingWidget();

    if (articles.isEmpty) {
      return const Center(child: Text("No posts available."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final user = demoUsers[random.nextInt(demoUsers.length)];
        final timestamp = _randomTimestamp();
        final title = article['title'] ?? 'No Title';
        final snippet = _cleanDescription(article['description'] ?? '');
        final sourceUrl = article['link'] ?? '';
        final imageAsset = article['imageAsset'];

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
              /// Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(user['avatar']!),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('@${user['username']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(timeago.format(timestamp), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Message
              Text('@${user['username']} shared "$title"', style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 12),

              /// Article Preview Box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageAsset != null && imageAsset.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imageAsset,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(snippet, style: const TextStyle(fontSize: 13)),
                    if (sourceUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Use url_launcher to open article URL
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.link, size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text("Read more", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              /// Interaction Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    onPressed: () => _interact(context, 'Liked', title),
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () => _interact(context, 'Commented on', title),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () => _interact(context, 'Favorited', title),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
