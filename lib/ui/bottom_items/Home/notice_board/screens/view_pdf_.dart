import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/widgets/error/error.widget.dart';
import '../../../../../widgets/heder/appbar_custom.dart';
import '../../utils/utils.dart';

class ViewPDf extends StatefulWidget {
  final String pdfLink;

  const ViewPDf({Key? key, required this.pdfLink}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPDfState createState() => _ViewPDfState();
}

class _ViewPDfState extends State<ViewPDf> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  File? _tempFile;
  bool? isOnline;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeFile();
    });
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> initializeFile() async {
    final Directory tempPath = await getApplicationDocumentsDirectory();
    final String fileName =
        widget.pdfLink.substring(widget.pdfLink.lastIndexOf('/') + 1);
    final File tempFile = File('${tempPath.path}/$fileName');
    final bool checkFileExist = await tempFile.exists();
    isOnline = await Utils.isOnlineMethod();
    if (checkFileExist) {
      setState(() {
        _tempFile = tempFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarCustom(
          ' view pdf',
          actions: [
            IconButton(
              onPressed: () {
                if (_pdfViewerController.pageNumber != 1) {
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
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: FutureBuilder<bool>(
                future: Utils.isOnlineMethod(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasError) {
                      return ErrorScreen(error: snapshot.error.toString());
                    }
                    if (isOnline == null ||
                        isOnline == false && _tempFile == null) {
                      return const ErrorScreen(
                          error: 'You  are in offline mood');
                    } else if (_tempFile != null) {
                      return SfPdfViewer.file(
                        controller: _pdfViewerController,
                        _tempFile!,
                        key: _pdfViewerKey,
                        onDocumentLoadFailed: (details) {
                          ErrorScreen(error: details.toString());
                        },
                      );
                    } else if (snapshot.data != null && _tempFile == null) {
                      return getBody();
                    } else {
                      return Loaders.center();
                    }
                  } catch (e) {
                    return ErrorScreen(error: '$e');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    try {
      return SfPdfViewer.network(
        widget.pdfLink,
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        controller: _pdfViewerController,
        onDocumentLoadFailed: (details) {
          ErrorScreen(error: details.toString());
        },
        onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
          final Directory tempPath = await getApplicationDocumentsDirectory();
          final String fileName =
              widget.pdfLink.substring(widget.pdfLink.lastIndexOf('/') + 1);
          _tempFile = await File('${tempPath.path}/$fileName')
              .writeAsBytes(List.from(await details.document.save()));
        },
      );
    } catch (e) {
      return ErrorScreen(error: e.toString());
    }
  }
}
