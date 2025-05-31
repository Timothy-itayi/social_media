import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:slip_stream/loading_screens/loading_feed.dart'; // Import the new loading widget

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
  final random = Random();

  // Demo users with avatar paths inside assets folder
  final List<Map<String, String>> demoUsers = [
    {'username': 'gridmaster', 'avatar': 'assets/profile00.jpg'},
    {'username': 'f1fan2025', 'avatar': 'assets/profile01.jpg'},
    {'username': 'paddockqueen', 'avatar': 'assets/profile02.jpg'},
    {'username': 'raceguru', 'avatar': 'assets/profile03.jpg'},
    {'username': 'verstappenvibes', 'avatar': 'assets/profile04.jpg'},
  ];

  // Placeholder articles for fallback
  final List<Map<String, String>> placeholderArticles = [
    {
      'title': 'Hamilton secures thrilling victory at Monaco Grand Prix',
      'description':
          'Lewis Hamilton clinched a spectacular win in a nail-biting Monaco GP that had fans on the edge of their seats. The race featured multiple overtakes and strategic pit stops...',
      'link': 'https://example.com/hamilton-monaco-win',
    },
    {
      'title': 'Ferrari unveils new car design for the upcoming season',
      'description':
          'Ferrari has revealed their latest Formula 1 car design, promising better aerodynamics and improved powertrain efficiency. The team hopes to challenge Red Bull and Mercedes this year...',
      'link': 'https://example.com/ferrari-new-car-2025',
    },
    {
      'title': 'Verstappen dominates the Spanish GP with record-breaking pace',
      'description':
          'Max Verstappen delivered a masterclass performance at the Spanish Grand Prix, setting fastest laps and leading from start to finish...',
      'link': 'https://example.com/verstappen-spanish-gp',
    },
    {
      'title': 'McLaren’s young driver impresses in qualifying session',
      'description':
          'McLaren’s rookie driver surprised many by qualifying in the top 5, showcasing incredible speed and composure under pressure...',
      'link': 'https://example.com/mclaren-rookie-qualifying',
    },
    {
      'title': 'Safety car incident shakes up the Italian GP race order',
      'description':
          'A late safety car deployment caused chaos at the Italian GP, mixing up the race order and allowing unexpected drivers to fight for podium positions...',
      'link': 'https://example.com/italian-gp-safety-car',
    },
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
      // Fallback: use placeholder articles
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
    if (isLoading) {
      return const FeedLoadingWidget(); // Refactored loading widget
    }

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
              /// Header row
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

              /// Shared message
              Text(
                '@${user['username']} shared "$title"',
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 12),

              /// Article preview box
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

              /// Actions
              const SizedBox(height: 12),
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
