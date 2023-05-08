import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../widgets/heder/heder_title.dart';

class ViewPDf extends StatefulWidget {
  final String pdfLink;
  const ViewPDf({Key? key, required this.pdfLink}) : super(key: key);

  @override
  State<ViewPDf> createState() => _ViewPDfState();
}

class _ViewPDfState extends State<ViewPDf> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            appBar(context),
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: SfPdfViewer.network(
                widget.pdfLink,
                key: UniqueKey(),
                controller: _pdfViewerController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  HeaderTitle appBar(BuildContext context) {
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
