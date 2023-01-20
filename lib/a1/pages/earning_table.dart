// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:togetherearn/a1/utils/constants.dart';
import 'package:togetherearn/a1/utils/multilang.dart';
import 'package:togetherearn/a1/widgets/background.dart';
import 'package:togetherearn/a1/widgets/custom_app_bar.dart';
import 'package:togetherearn/a1/models/local.model.dart';
import 'package:path_provider/path_provider.dart';
import '../instagramAccounts/globals.dart';
import 'package:http/http.dart' as http;
import 'package:togetherearn/a1/localization/strings.dart';
import 'package:togetherearn/a1/localization/language_controller.dart';

class EarningTablePage extends StatefulWidget {
  @override
  _EarningTablePageState createState() => _EarningTablePageState();
}

class _EarningTablePageState extends State<EarningTablePage> {
  var fileName = "kazanc_tablosu";
  // ignore: prefer_typing_uninitialized_variables
  var path;
  List data = [];
  String local = "tr";

  @override
  void initState() {
    super.initState();
    // fetchEarningTable();
    _loadData();
    _init();
  }

  void _loadData() async {
    // Connect to the Postgres database
    var url = "$conUrl/api/serviceprices";
    var response = await http.get(Uri.parse(url));

    print(response.body);
    setState(() {
      data = jsonDecode(response.body)['results'];
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _init() async {
    path = await _localPath;
    fileName = "$path/kazanc_tablosu.pdf";
    var res = await downloadPdfIfNotExists(
        "https://togetherearndj.herokuapp.com/static/pdf/kazanc_tablosu.pdf",
        fileName);
    print(res);
  }

  // Function to download the PDF file from the server and store it locally
  Future<File> downloadPdf(String url, String fileName) async {
    var response = await http.get(Uri.parse(url));
    var file = File(fileName);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  // Function to check if the PDF file exists locally
  Future<bool> pdfExists(String fileName) async {
    var file = File(fileName);
    return file.existsSync();
  }

  // Call the download function if the PDF file does not exist
  Future downloadPdfIfNotExists(String url, String fileName) async {
    if (await pdfExists(fileName)) {
      print('PDF file already exists');
      var file = downloadPdf(url, fileName).then((file) {
        print('PDF file saved to ${file.path}');
      });
      return file;
    } else {
      var file = downloadPdf(url, fileName).then((file) {
        print('PDF file saved to ${file.path}');
      });
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 132, 16, 8),
      body: Column(
        children: <Widget>[
          const CustomAppBar(
            title: " Kazanc Tablosu ",
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var row = data[index];
                final textStyle =
                    TextStyle(color: Colors.blueGrey, fontSize: 20);
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          width: 5.0, color: Color.fromARGB(255, 54, 5, 5)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    backgroundColor: Colors.white70,
                    title: Text(
                      "${getString('withFollower')}".replaceFirst(
                          '{follower}', row['followerCount'].toString()),
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    children: [
                      ListTile(
                        title: Text(interactionStrings[local]['userToFollow'],
                            style: textStyle),
                        trailing: Text("% ${row['usersToFollow'].toString()}",
                            style: textStyle),
                      ),
                      ListTile(
                        title: Text(interactionStrings[local]['postLikes'],
                            style: textStyle),
                        trailing: Text(
                          "% ${row['postLikes'].toString()}",
                          style: textStyle,
                        ),
                      ),
                      ListTile(
                        title: Text(interactionStrings[local]['postComments'],
                            style: textStyle),
                        trailing: Text("% ${row['postComments'].toString()}",
                            style: textStyle),
                      ),
                      ListTile(
                        title: Text(interactionStrings[local]['postSaves'],
                            style: textStyle),
                        trailing: Text("% ${row['postSaves'].toString()}",
                            style: textStyle),
                      ),
                      ListTile(
                        title: Text(interactionStrings[local]['commentLikes'],
                            style: textStyle),
                        trailing: Text("% ${row['commentLikes'].toString()}",
                            style: textStyle),
                      ),
                    ],
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
/*        

  body: Background(
      child: Container(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomAppBar(
              title: "Kazanc Tablosu (PDF)",
            ),
            // add button
            // move textbutton to the center

             Expanded(
               child: Container(
                 child: TextButton( 
                  child: Text('Kazanc Tablosunu Görüntüle', style: 
                  TextStyle(color: Colors.white , fontSize: 30),),

                           ),
               ),
             ),
          ],
        ),
      ),
    ));
  }
             onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFScreen(pathPDF: fileName),
                      ),
                    );
                  }, 
class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen({Key key, String this.pathPDF}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text("Kazanc Tablosu", 
          style: TextStyle(color: Colors.white )),   
          backgroundColor: Color.fromARGB(255, 153, 13, 3), 
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }*/
