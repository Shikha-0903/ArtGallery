import 'package:flutter/material.dart';
import 'package:sycs_proj_shikha/model.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class ShowArt extends StatefulWidget {
  final Artwork artwork;
  const ShowArt({required this.artwork, Key? key}) : super(key: key);

  @override
  State<ShowArt> createState() => _ShowArtState();
}

class _ShowArtState extends State<ShowArt> {
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    // Initialize isLiked based on the current user's liked state for this artwork
    isLiked = Provider.of<Favorite_State>(context, listen: false).isArtworkLiked(widget.artwork.title!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artwork.title ?? "Untitled"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.artwork.thumbnail != null
                  ? Container(
                child: Image.network(widget.artwork.thumbnail!),
              )
                  : Placeholder(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      // Toggle the liked state of the artwork
                      Provider.of<Favorite_State>(context, listen: false).toggleArtworkLikedState(widget.artwork.title!);
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (kIsWeb) {
                        // Download functionality for web
                        if (widget.artwork.thumbnail != null) {
                          try {
                            // Download image
                            var response =
                            await http.get(Uri.parse(widget.artwork.thumbnail!));

                            // Create a blob containing the downloaded data
                            final blob = html.Blob([response.bodyBytes]);
                            final url = html.Url.createObjectUrlFromBlob(blob);

                            // Create an anchor element to trigger the download
                            final anchor = html.AnchorElement(href: url);
                            anchor.download = '${widget.artwork.title}.jpg';
                            anchor.click();

                            // Revoke the blob url to release memory
                            html.Url.revokeObjectUrl(url);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Download complete'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Error downloading file. Please try again later.'),
                              ),
                            );
                            print('Error downloading file: $e');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No image to download'),
                            ),
                          );
                        }
                      } else {
                        // Download functionality for Android
                        try {
                          if (widget.artwork.thumbnail != null) {
                            final taskId = await FlutterDownloader.enqueue(
                              url: widget.artwork.thumbnail!,
                              savedDir: '/sdcard/Download',
                              fileName: '${widget.artwork.title}.jpg',
                              showNotification: true,
                              openFileFromNotification: true,
                            );
                            print('Download task id: $taskId');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No image to download'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error downloading file. Please try again later.'),
                            ),
                          );
                          print('Error downloading file: $e');
                        }
                      }
                    },
                    icon: Icon(Icons.download),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _keyValuePairWidget("title", widget.artwork.title ?? 'Untitled'),
              _keyValuePairWidget("type", widget.artwork.type ?? "Unknown"),
              _keyValuePairWidget(
                  "description", widget.artwork.description ?? "No Description"),
              _keyValuePairWidget(
                  "og type", widget.artwork.og_type ?? "Not Known"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keyValuePairWidget(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class Favorite_State extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _currentUserUid;
  List<String> _likedArtworks = [];

  Favorite_State(this._currentUserUid) {
    _init();
  }
  void resetCurrentUserUid(String uid) {
    _currentUserUid = uid;
    _init();
  }
  void _init() async {
    try {
      final documentSnapshot =
      await _firestore.collection('users').doc(_currentUserUid).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        _likedArtworks = List<String>.from(data['likedArtworks'] ?? []);
        notifyListeners();
      } else {
        await _firestore.collection('users').doc(_currentUserUid).set({
          'likedArtworks': [],
        });
        // Initialize _likedArtworks as an empty list
        _likedArtworks = [];
      }
    } catch (e) {
      print('Error initializing liked artworks: $e');
    }
  }

  List<String> get likedArtworks => _likedArtworks;

  bool isArtworkLiked(String id) {
    return _likedArtworks.contains(id);
  }

  void toggleArtworkLikedState(String id) {
    final isCurrentlyLiked = isArtworkLiked(id);
    if (isCurrentlyLiked) {
      _likedArtworks.remove(id);
    } else {
      _likedArtworks.add(id);
    }
    notifyListeners();
    updateLikedArtworksInFirestore();
  }

  Future<void> updateLikedArtworksInFirestore() async {
    try {
      await _firestore.collection('users').doc(_currentUserUid).update({
        'likedArtworks': _likedArtworks,
      });
    } catch (e) {
      print('Error updating liked artworks in Firestore: $e');
    }
  }
}


