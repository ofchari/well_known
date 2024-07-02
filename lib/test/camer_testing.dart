import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
// Ensure this file correctly defines Mytext widget.

class CamTests extends StatefulWidget {
  const CamTests({super.key});

  @override
  _CamTestsState createState() => _CamTestsState();
}

class _CamTestsState extends State<CamTests> {
  File? _image;
  late String camimagePath;
  late String camimagename;
  late File camimagefile;

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>?> uploadImageToFileManager(
      File imageFile,
      String fileName,
      ) async {
    const apiUrl = 'https://wellknownssyndicate.regenterp.com/api/method/upload_file';

    try {
      const credentials = 'c5a479b60dd48ad:d8413be73e709b6'; // Well_known
      final headers = {
        'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      };

      final ioClient = IOClient(HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true));

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll(headers);

      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();

      request.files.add(http.MultipartFile(
        'file',
        imageStream,
        imageLength,
        filename: '$fileName.png',
      ));

      final now = DateTime.now(); // Get current date and time
      final messageData = {
        "message": {
          "name": fileName, // Use the desired file name here
          "owner": "Administrator",
          "creation": now.toIso8601String(),
          "modified": now.toIso8601String(),
          // "modified_by": "Administrator",
          // "docstatus": 0,
          "idx": 0,
          "file_name": '$fileName.png',
          // "is_private": 0,
          // "is_home_folder": 0,
          // "is_attachments_folder": 0,
          "file_size": imageLength,
          "file_url": "/files/$fileName.png", // Use the correct file URL path
          // "folder": "Home", // Use the desired folder name
          // "is_folder": 0,
          // "content_hash": "", // You may need to calculate the content hash
          // "uploaded_to_dropbox": 0,
          // "uploaded_to_google_drive": 0,
          "doctype": "File"
        }
      };

      request.fields['data'] = json.encode(messageData);

      final response = await ioClient.send(request);

      if (response.statusCode == 200) {
        final responseBody = json.decode(await response.stream.bytesToString());
        return responseBody;
      } else {
        print(response.statusCode);
        print(await response.stream.bytesToString());
        return null;
      }
    } catch (error) {
      print('Image Upload Error: $error');
      return null;
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        camimagePath = pickedFile.path;
        camimagefile = File(camimagePath);
        camimagename = path.basenameWithoutExtension(camimagePath);
      });
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(now); // Format the date
      final formattedTime = DateFormat('HH:mm:ss').format(now); // Format the time
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Purchase Inward",style: GoogleFonts.outfit(textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black)),)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(pickedFile.path)), // Display the captured image
                const SizedBox(height: 20),
                Center(child: Text("Date: $formattedDate\nTime: $formattedTime",style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.blue)),)),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      uploadImageToFileManager(camimagefile, camimagename);
    }
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
              onPressed: () async {
                await captureImage();
              },
              child: const Text('Capture Image'),
            ),
          ),
        ],
      ),
    );
  }
}
