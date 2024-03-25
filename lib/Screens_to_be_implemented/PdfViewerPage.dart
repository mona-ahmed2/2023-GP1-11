import 'dart:typed_data';

import 'package:flutter/material.dart'; 
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wjjhni/model/CoursePlan.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewerPage extends StatefulWidget {
  final CoursePlan crsPln ;

  const PdfViewerPage({super.key, required this.crsPln});
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
          
  bool isLoading = false; 
  late File Pfile;
  Future<void> loadNetwork(String url) async {
    setState(() {
      isLoading = true;
    }); 

    print (url);
    //url = 'https://drive.google.com/file/d/1WYVgBlpavkd3OPtINn4BYbjJZ3ViA_pG/view?usp=drive_link';
    final response = await http.get(Uri.parse(url));   
    final directory = await getDownloadsDirectory();
    final filePath = "${directory!.path}/output.pdf";
    final file = File(filePath);
    final downloadTask =   await file.writeAsBytes(response.bodyBytes); 
                                        
 
    setState(() {
      Pfile = file;
    });

    print(file);
    setState(() {
      isLoading = false;
    });
  } 
  @override
  void initState() {
    
    loadNetwork(widget.crsPln.url);

    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View PDF: "+widget.crsPln.course_name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child:
                  SfPdfViewer.file(  Pfile,
                  //widget.crsPln.url,
                ),
                /*
                  SfPdfViewer.network(  "https://faculty.ksu.edu.sa/sites/default/files/ObjectOrientedProgramminginC4thEdition.pdf",
                  //widget.crsPln.url,
                ),
                */
              ),
            ),
    );
  }
}