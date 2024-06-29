import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showDialog(context);
  }

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          await _saveImageToGallery(File(pickedFile.path));
          _showDialog(context);
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else {
      print("Storage permission not granted");
    }
  }

  Future<void> _saveImageToGallery(File image) async {
    try {
      final directory = await getExternalStorageDirectory();
      final String newPath = path.join(directory!.parent.path, 'Pictures');
      final Directory newDir = Directory(newPath);
      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
      }
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final File newImage = await image.copy('${newDir.path}/$fileName');

      // Notify the media scanner about the new file
      const MethodChannel('com.example.app/gallery_scanner')
          .invokeMethod('scanMediaFile', {'path': newImage.path});

      print('Image saved to ${newDir.path}/$fileName');
    } catch (e) {
      print("Error saving image to gallery: $e");
    }
  }

  Future<void> _showDialog(BuildContext context) async{
    return await  showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Hello"),
            content: const Text("              Image Saved Successfully"),
            actions: [
             TextButton(onPressed: (){
               Navigator.pop(context);
             }, child: const Text("Yes")
             ),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("No"))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null ? const Text('No image selected.') : Image.file(_image!),
          Center(
            child: ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Capture Image'),
            ),
          ),
        ],
      ),
    );
  }
}
