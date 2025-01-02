import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoGallery(),
    );
  }
}

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<AssetEntity> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  // Request permission and load photos from the gallery
  Future<void> _loadPhotos() async {
    final permissionStatus = await Permission.photos.request();
    if (permissionStatus.isGranted) {
      final assets = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = await assets[0].getAssetListRange(start: 0, end: 100);
      setState(() {
        _photos = recentAlbum;
      });
    } else {
      // If permission is not granted, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access photos denied.')),
      );
    }
  }

  // Take a photo and reload the gallery
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // ignore: unused_local_variable
      final file = await photo.saveToFile();
      _loadPhotos(); // Reload photos after taking a new one
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Gallery')),
      body: Column(
        children: [
          // Button to take a photo
          ElevatedButton(
            onPressed: _takePhoto,
            child: Text('Take Photo'),
          ),
          // Button to reload photos from the gallery
          ElevatedButton(
            onPressed: _loadPhotos,
            child: Text('Reload Photos'),
          ),
          // Display gallery photos in a grid view
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Widget>(
                  future: _getImage(_photos[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data!;
                    }
                    return CircularProgressIndicator();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Convert photo to image widget
  Future<Widget> _getImage(AssetEntity asset) async {
    final file = await asset.file;
    return Image.file(file!, fit: BoxFit.cover);
  }
}

extension on XFile {
  saveToFile() {}
}
