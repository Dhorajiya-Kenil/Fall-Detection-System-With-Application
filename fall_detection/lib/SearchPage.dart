import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, String>> _allMovies = [
    {'title': 'Money Heist', 'image': 'assets/images/heist.jpg'},
    {'title': 'Joker', 'image': 'assets/images/joker.jpg'},
    {'title': 'Avatar', 'image': 'assets/images/avtar.png'},
    {'title': 'Infinity War', 'image': 'assets/images/infinity.jpg'},
    {'title': 'Star Wars', 'image': 'assets/images/starwars.jpg'},
    {'title': 'Aquaman', 'image': 'assets/images/aquva.jpg'},
    {'title': 'Jawan', 'image': 'assets/images/jawan.jpeg'},
    {'title': 'Free Guy', 'image': 'assets/images/freeguy.jpg'},
    {'title': 'Master', 'image': 'assets/images/master.jpg'},
    {'title': 'Mission Impossible', 'image': 'assets/images/mi.jpg'},
    {'title': 'Pathan', 'image': 'assets/images/pathan.webp'},
    {'title': 'Kapil Sharma Show', 'image': 'assets/images/kapil.jpg'},
    {'title': 'Friends Reunion', 'image': 'assets/images/friends.jpg'},
    {'title': 'Love Actually', 'image': 'assets/images/love.jpg'},
    {'title': 'Family Movie Night', 'image': 'assets/images/family.jpg'},
    {'title': 'Koffee with Karan', 'image': 'assets/images/kaffee.jpg'},
  ];

  List<Map<String, String>> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _filteredMovies = []; // Start with no movies displayed
  }

  void _filterMovies(String query) {
    if (query.isEmpty) {
      // Show no movies when the search query is empty
      setState(() {
        _filteredMovies = [];
      });
    } else {
      final filteredMovies = _allMovies.where((movie) {
        return movie['title']!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredMovies = filteredMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterMovies,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredMovies.isEmpty
                ? Center(
              child: Text(
                'Search for movies...',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = _filteredMovies[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      movie['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    movie['title']!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
