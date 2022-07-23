import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullPdfPage extends StatefulWidget {
  final String url;
  final String filename;

  const FullPdfPage({Key? key, required this.url, required this.filename}) : super(key: key);

  @override
  State<FullPdfPage> createState() => _FullPdfPageState();
}

class _FullPdfPageState extends State<FullPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // decoration: BoxDecoration(
          //
          //   image: DecorationImage(
          //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
          //     fit: BoxFit.cover,
          //   ),
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("##330417"),
                HexColor("#000000"),
              ],
            ),
          ),
        ),

        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              "Pdf",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PR',
                  fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  onPressed: (){
                    downloadFile();
                    // _download();
                  },
                  icon: Icon(Icons.download,color: Colors.white,),
                ),
              )
            ],
          ),
          body: Container(
              child: SfPdfViewer.network(
                  widget.url)),
        ),
      ],
    );
  }
  Future<String> downloadFile() async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = widget.url;

    try {
      // myUrl = url+'/'+fileName;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        final tempDir = await getTemporaryDirectory();

        filePath = '${tempDir.path}/${widget.filename}';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      }
      else {
        filePath = 'Error code: '+response.statusCode.toString();
      }
    }
    catch(ex){
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
