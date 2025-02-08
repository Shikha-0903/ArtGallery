import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sycs_proj_shikha/artdetail.dart';
import 'package:sycs_proj_shikha/model.dart';
import 'package:sycs_proj_shikha/bottomNav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Artwork> _artworks = [];
  late TextEditingController _searchController;
  bool _isLoading = false;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchArtworkData(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a search query')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.artsy.net/api/search?q=$query'),
        headers: {
          'X-XAPP-Token': dotenv.env['ARTSY_API_TOKEN']!, // Replace with your actual Artsy API token
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('_embedded')) {
          final List<dynamic> results = data['_embedded']['results'];
          setState(() {
            _artworks = results.map((json) => Artwork.fromMap(json)).toList();
            _isLoading = false;
          });

          // Check if there are more pages of results
          if (data['_links'] != null && data['_links']['next'] != null) {
            // Extract the URL for the next page
            String nextPageUrl = data['_links']['next']['href'];
            // Fetch additional pages of results
            await _fetchAdditionalArtworkData(nextPageUrl);
          }
        } else {
          throw Exception('Invalid API response');
        }
      } else {
        throw Exception('Failed to fetch artwork data: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch artwork data: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAdditionalArtworkData(String nextPageUrl) async {
    try {
      final response = await http.get(
        Uri.parse(nextPageUrl),
        headers: {
          'X-XAPP-Token': 'eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IiIsInN1YmplY3RfYXBwbGljYXRpb24iOiIwZmNjZjA5ZS1jMDVlLTQwNWYtOGIyMC01OWMxOTdiYzA2OTEiLCJleHAiOjE3MTMzMzY2NDAsImlhdCI6MTcxMjczMTg0MCwiYXVkIjoiMGZjY2YwOWUtYzA1ZS00MDVmLThiMjAtNTljMTk3YmMwNjkxIiwiaXNzIjoiR3Jhdml0eSIsImp0aSI6IjY2MTYzNmMwOTUyZWM2MDAwZGZhMzA3NiJ9.XmWc2zDOGGnHiErHe34oaW-QEKWKa14uoRYKBikC-gs', // Replace with your actual Artsy API token
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('_embedded')) {
          final List<dynamic> results = data['_embedded']['results'];
          setState(() {
            _artworks.addAll(results
                .where((item) => item['type'] == 'artwork')
                .map((json) => Artwork.fromMap(json))
                .toList());
          });

          // Check if there are more pages of results
          if (data['_links'] != null && data['_links']['next'] != null) {
            // Extract the URL for the next page
            String nextPageHref = data['_links']['next']['href'];

            // Fetch additional pages of results
            await _fetchAdditionalArtworkData(nextPageHref);
          }
        } else {
          throw Exception('Invalid API response');
        }
      } else {
        throw Exception('Failed to fetch additional artwork data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching additional artwork data: $e');
     /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch additional artwork data: $e')),
      );*/
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Art Search'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'search for art,artist or artwork',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String searchQuery = _searchController.text;
                  await _fetchArtworkData(searchQuery);
                },
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : _artworks.isEmpty
                ? Center(
              child: Text('No artwork found'),
            )
                : ListView.builder(
              itemCount: _artworks.length,
              itemBuilder: (context, index) {
                final artwork = _artworks[index];
                return ListTile(
                  title: Text(artwork.title ?? 'Untitled'),
                  subtitle: Text(" "),
                  leading: artwork.thumbnail != null ? Image.network(artwork.thumbnail!) : Placeholder(), // Display a placeholder if thumbnail URL is null
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowArt(artwork: _artworks[index])));
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(context,index);
        },
      ),
    );
  }
  void _onItemTapped(BuildContext context,int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'home');
        break;
      case 1:
        Navigator.pushNamed(context, 'search');
        break;
      case 2:
        Navigator.pushNamed(context, 'user');
        break;
      default:
        break;
    }
  }
}
