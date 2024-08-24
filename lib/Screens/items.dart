import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:share/share.dart';
// import 'package:share/share.dart';
import 'package:well_known/Services/sample.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/item_products.dart';
import 'package:http/http.dart' as http;
import 'package:well_known/utils/items_util.dart';
import '../Services/items_api.dart';
import '../Utils/items_util.dart';
import '../Utils/sample_util.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dioo;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';


class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late double height;
  late double width;
  String _searchTerm = '';
  List<Item> _items = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fetchItems();
    super.initState();
  }

  Future<void> fetchItems() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    final response = await ioClient.get(
      Uri.parse(
          'https://erp.wellknownssyndicate.com/api/resource/Item?fields=["name","item_name","item_group","part_no","brand","stock_uom","gst_hsn_code","image"]&limit_page_length=50000'),
      headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _items = data.map((item) => Item.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  String _preprocessString(String input) {
    return input.replaceAll(RegExp(r'[\s,%."]'), '').toLowerCase();
  }

  List<Item> _filterItems(String searchTerm) {
    if (searchTerm.isEmpty) {
      return _items;
    } else {
      String processedSearchTerm = _preprocessString(searchTerm);
      return _items.where((item) {
        String itemName = item.itemName ?? '';
        return _preprocessString(itemName).contains(processedSearchTerm);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(
              context,
              designSize: Size(width, height),
              minTextAdapt: true,
            );
            if (width <= 450) {
              return _smallBuildLayout();
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Headingtext(
          text: "Items",
          color: Colors.black,
          weight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: "Search Item",
                hintStyle: GoogleFonts.dmSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildItemList(),
          ),
        ],
      ),
    );
  }

  String name ='';
      Widget _buildItemList() {
    List<Item> filteredItems = _filterItems(_searchTerm);

    if (_items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (filteredItems.isEmpty) {
      return const Center(child: Text('No items found'));
    } else {
      return ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          Item item = filteredItems[index];
           name = item.itemName.toString();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  height: height / 5.h,
                  width: width / 1.w,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Mytext(
                          text: item.itemName.toString(),
                          color: const Color(0xffff035e32)),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: height / 10.h,
                            width: width / 4.2.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://erp.wellknownssyndicate.com${item.image?.toString() ?? "/files/bimage.png"}',
                                    headers: {
                                      "Authorization":
                                      "token c5a479b60dd48ad:d8413be73e709b6"
                                    },
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                item.itemGroup.toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.lightBlue.shade400)),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(10.0)),
                                    child: const Mytext(
                                        text: "Part No : ",
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(20.0)),
                                    child: Text(
                                      item.part_no.toString(),
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.lightGreen)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Mytext(
                                      text: "  HSC/SAC : ",
                                      color: Colors.black),
                                  Text(
                                    item.gst_hsn_code.toString(),
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.lightGreen)),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 60,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        // _shareContent();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  PDFDownloader(name:item.name.toString()),
                          ),
                        );
                        sharePDF();
                      },
                      child: const Center(
                          child: Icon(
                            Icons.share,
                            color: Colors.black,
                            size: 30,
                          )),
                    ))
              ],
            ),
          );
        },
      );
    }
  }

  String url =
      'https://erp.wellknownssyndicate.com/api/method/frappe.utils.print_format.download_pdf';
  String doctype = 'Item';

  String format = 'Item Template';
  String authToken = 'c5a479b60dd48ad:d8413be73e709b6';
  String localPath = '';
  bool isLoading = true;
  Future<void> downloadPDF() async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'token $authToken';

      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$name.pdf';

      // Construct the URL with query parameters
      String fullUrl = '$url?doctype=$doctype&name=$name&format=$format';

      Dioo.Response response = await dio.get(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        print(
            'Failed to download PDF: ${response.statusCode} ${response.statusMessage}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void sharePDF() {
    Share.shareFiles([localPath], text: 'Here is the PDF file: $name.pdf');
  }

  // void _shareContent() {
  //   final RenderBox? box =
  //   scaffoldKey.currentContext?.findRenderObject() as RenderBox?;
  //   Share.share(
  //     'Click and share where you want to !',
  //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  //   );
  // }
}



class PDFDownloader extends StatefulWidget {
  const PDFDownloader({super.key, required this.name});
  final String name;
  @override
  _PDFDownloaderState createState() => _PDFDownloaderState();
}

class _PDFDownloaderState extends State<PDFDownloader> {

  String url =
      'https://erp.wellknownssyndicate.com/api/method/frappe.utils.print_format.download_pdf';
  String doctype = 'Item';
  // String name = 'STICKER ROLL-MEDIUM';
  late String name;
  String format = 'Item Template';
  String authToken = 'c5a479b60dd48ad:d8413be73e709b6';
  String localPath = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'token $authToken';

      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$name.pdf';

      // Construct the URL with query parameters
      String fullUrl = '$url?doctype=$doctype&name=$name&format=$format';

      Dioo.Response response = await dio.get(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        print(
            'Failed to download PDF: ${response.statusCode} ${response.statusMessage}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void sharePDF() {
    Share.shareFiles([localPath], text: 'Here is the PDF file: $name.pdf');
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Downloader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: sharePDF,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
          ? Column(
        children: [
          Expanded(child: PDFView(filePath: localPath)),
          ElevatedButton(
            onPressed: sharePDF,
            child: const Text('Share PDF'),
          ),
        ],
      )
          : const Center(child: Text('Error loading PDF')),
    );
  }
}
