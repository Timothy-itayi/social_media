import 'package:flutter/material.dart';
import 'package:slip_stream/tabs/feed_screen.dart';
import 'package:slip_stream/tabs/profile_screen.dart';
import 'package:slip_stream/tabs/stats_screen.dart';
import 'tabs/news_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String username;
  final String profileImageUrl;

  const MyHomePage({
    super.key,
    required this.title,
    this.username = 'Driver',
    this.profileImageUrl =
        'https://i.imgur.com/BoN9kdC.png', // Default avatar placeholder
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _pages = <Widget>[
    NewsScreen(),
    Center(child: Text('Chats Placeholder')),
    FeedScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.redAccent,
       title: Image.asset(
    'assets/slip_stream_icon.png',  //
    height: 40,         // adjust height as needed
    fit: BoxFit.contain,
  ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: widget.profileImageUrl.startsWith('http')
                  ? NetworkImage(widget.profileImageUrl)
                  : AssetImage(widget.profileImageUrl) as ImageProvider,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text('Search Posts', style: TextStyle(color: Colors.white)),
                  content: const Text('Search functionality coming soon!',
                      style: TextStyle(color: Colors.white70)),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Container(
        width: drawerWidth,
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Drawer(
          elevation: 16,
          child: Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Column(
              children: [
                Container(
                  height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: widget.profileImageUrl.startsWith('http')
                            ? NetworkImage(widget.profileImageUrl)
                            : AssetImage(widget.profileImageUrl) as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: Text(
                          widget.username,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Flexible(
                        child: Text(
                          'Motorsport fan & F1 enthusiast',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.redAccent),
                  title: const Text('Settings', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text('Logout', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Handle logout logic
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
