// lib/tabs/feed_screen.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  final random = Random();

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
      setState(() {
        isLoading = false;
      });
    }
  }

  // Random username for demo
  String _randomUsername() {
    final users = ['gridmaster', 'f1fan2025', 'paddockqueen', 'raceguru', 'verstappenvibes'];
    return users[random.nextInt(users.length)];
  }

  // Random timestamp within last 24 hours
  DateTime _randomTimestamp() {
    return DateTime.now().subtract(Duration(minutes: random.nextInt(1440)));
  }

  String _cleanDescription(String rawDesc, {int maxLen = 120}) {
    final regex = RegExp(r'<[^>]*>');
    final cleaned = rawDesc.replaceAll(regex, '');
    return cleaned.length > maxLen ? cleaned.substring(0, maxLen).trim() + '...' : cleaned;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articles.isEmpty) {
      return const Center(child: Text("No posts available."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final username = _randomUsername();
        final timestamp = _randomTimestamp();
        final timeAgo = timeago.format(timestamp);
        final title = article['title'] ?? 'No Title';
        final snippet = _cleanDescription(article['description'] ?? '');

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      child: Text(username[0].toUpperCase()),
                    ),
                    const SizedBox(width: 8),
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text('• $timeAgo', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),

                /// Title
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

                /// Snippet
                const SizedBox(height: 6),
                Text(snippet),

                /// Actions
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Liked: $title')));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment: $title')));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star_border),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Favorited: $title')));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
