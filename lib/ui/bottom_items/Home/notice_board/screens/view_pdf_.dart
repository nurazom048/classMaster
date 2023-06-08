// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:table/core/component/loaders.dart';

import '../../../../../widgets/heder/heder_title.dart';

class ViewPDf extends StatefulWidget {
  final String pdfLink;

  const ViewPDf({Key? key, required this.pdfLink}) : super(key: key);

  @override
  _ViewPDfState createState() => _ViewPDfState();
}

class _ViewPDfState extends State<ViewPDf> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  Future<String?> urlChecker(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return null;
      } else {
        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            appBar(context),
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: FutureBuilder<String?>(
                future: urlChecker(widget.pdfLink),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loaders.center();
                  } else if (snapshot.hasData) {
                    return Center(
                      child: Text(
                        'Something went wrong: ${snapshot.data.toString()}',
                      ),
                    );
                  } else {
                    return SfPdfViewer.network(
                      widget.pdfLink,
                      key: UniqueKey(),
                      controller: _pdfViewerController,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return HeaderTitle(
      "View PDF",
      context,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      widget: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_pdfViewerController.pageNumber > 1) {
                _pdfViewerController.previousPage();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () {
              if (_pdfViewerController.pageNumber <
                  _pdfViewerController.pageCount) {
                _pdfViewerController.nextPage();
              }
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
