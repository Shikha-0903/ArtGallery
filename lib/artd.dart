import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // For accessing the clipboard
import 'package:share_plus/share_plus.dart'; // For sharing content
import 'package:url_launcher/url_launcher.dart';
///with saved data i  firebase
class ArtworkDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final String description;
  final String money;
  final String artworkId;
  final String size;
  final String medium;
  final String frame;

  const ArtworkDetailsPage({
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.description,
    required this.money,
    required this.artworkId,
    required this.size,
    required this.medium,
    required this.frame,
  });

  @override
  _ArtworkDetailsPageState createState() => _ArtworkDetailsPageState();
}

class _ArtworkDetailsPageState extends State<ArtworkDetailsPage> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    // Initialize isLiked based on the current user's liked state for this artwork
    isLiked = Provider.of<FavoriteState>(context, listen: false)
        .isArtworkLiked(widget.artworkId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.imageUrl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    // Toggle the liked state of the artwork
                    Provider.of<FavoriteState>(context, listen: false).toggleArtworkLikedState(widget.artworkId);
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      // Download functionality for web
                      try {
                        // Create an anchor element
                        var response =
                        await http.get(Uri.parse(widget.imageUrl));

                        // Create a blob containing the downloaded data
                        final blob = html.Blob([response.bodyBytes]);
                        final url =
                        html.Url.createObjectUrlFromBlob(blob);

                        // Create an anchor element to trigger the download
                        final anchor =
                        html.AnchorElement(href: url);
                        anchor.download = '${widget.title}.jpg';
                        anchor.click();

                        // Revoke the blob url to release memory
                        html.Url.revokeObjectUrl(url);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text('Download complete'),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text(
                              'Error downloading file. Please try again later.'),
                        ));
                        print('Error downloading file: $e');
                      }
                    } else {
                      // Download functionality for Android
                      try {
                        final taskId =
                        await FlutterDownloader.enqueue(
                          url: widget.imageUrl,
                          savedDir: '/sdcard/Download',
                          fileName: '${widget.title}.jpg',
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                        print('Download task id: $taskId');
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          content: Text(
                              'Error downloading file. Please try again later.'),
                        ));
                        print('Error downloading file: $e');
                      }
                    }
                  },
                  icon: Icon(Icons.download),
                ),
                SizedBox(width: 20,),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.link),
                              title: Text('Copy Link'),
                              onTap: () {
                                Navigator.pop(context);
                                Clipboard.setData(ClipboardData(text: widget.imageUrl));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Link copied to clipboard')),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text('Share on outlook'),
                              onTap: () {
                                Share.share(
                                  widget.imageUrl,
                                );
                                // Share on Instagram code here
                              },
                            ),
                            /*ListTile(
                              leading: Icon(Icons.share),
                              title: Text('Share on Facebook'),
                              onTap: () {
                                Navigator.pop(context);
                                // Share on Facebook code here
                              },
                            ),*/
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text('Share via Gmail'),
                              onTap: () async {
                                Navigator.pop(context);
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: '', // Add recipient's email address here
                                  queryParameters: {
                                    'subject': 'Check out this artwork!',
                                    'body': 'Hey, I thought you might like this artwork: ${widget.title}. Check it out here: ${widget.imageUrl}',
                                  },
                                );
                                final String url = 'mailto:?subject=${Uri.encodeQueryComponent('Check out this artwork!')}&body=${Uri.encodeQueryComponent('Hey, I thought you might like this artwork: ${widget.title}. Check it out here: ${widget.imageUrl}')}';
                                final String gmailUrl = 'googlegmail://send?body=$url';
                                final String fallbackUrl = emailUri.toString();

                                if (await canLaunch(gmailUrl)) {
                                  await launch(gmailUrl);
                                } else {
                                  if (await canLaunch(fallbackUrl)) {
                                    await launch(fallbackUrl);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch Gmail')),
                                    );
                                  }
                                }
                              },

                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.share),
                ),

              ],
            ),

            SizedBox(height: 20),
            _keyValuePairWidget("title", widget.title),
            _keyValuePairWidget("artist", widget.artist),
            _keyValuePairWidget("Medium", widget.medium),
            _keyValuePairWidget("size", widget.size),
            _keyValuePairWidget("frame", widget.frame)
          ],
        ),
      ),
    );
  }

  Widget _keyValuePairWidget(String key, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(1), // Adjust the width of the first column
          1: FlexColumnWidth(2), // Adjust the width of the second column
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

class FavoriteState extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _currentUserUid;
  List<String> _likedArtworks = [];

  FavoriteState(this._currentUserUid) {
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

  bool isArtworkLiked(String artworkId) {
    return _likedArtworks.contains(artworkId);
  }

  void toggleArtworkLikedState(String artworkId) {
    final isCurrentlyLiked = isArtworkLiked(artworkId);
    if (isCurrentlyLiked) {
      _likedArtworks.remove(artworkId);
    } else {
      _likedArtworks.add(artworkId);
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
