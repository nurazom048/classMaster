import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/export_core.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../utils/pdf_utils.dart';

class ViewPDf extends StatefulWidget {
  final String pdfLink;

  const ViewPDf({super.key, required this.pdfLink});

  @override
  _ViewPDfState createState() => _ViewPDfState();
}

class _ViewPDfState extends State<ViewPDf> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final String pdfBaseUrl = "${Const.BASE_URl}/storage/storageforclassmaster/";

  bool? isOnline;
  String? errorMessage;
  bool isLoading = true;

  File? cachedPdfFile;
  Uint8List? webPdfBytes;

  @override
  void initState() {
    super.initState();
    initializePdf();
    PdfUtils.initializeCacheClearTimer();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  // 🔔 কাস্টম টোস্ট/স্ন্যাকবার মেথড
  void _showToast(String message, {bool isError = false}) {
    if (!mounted) return; // অ্যাপ অন্য স্ক্রিনে চলে গেলে যেন ক্র্যাশ না করে
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // আগের মেসেজ ক্লিয়ার করবে
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating, // সুন্দর ভাসমান লুকের জন্য
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> initializePdf() async {
    isOnline = await Utils.isOnlineMethod();

    final String fullUrl =
        widget.pdfLink.startsWith('http')
            ? widget.pdfLink
            : "$pdfBaseUrl${widget.pdfLink}";

    if (!kIsWeb) {
      bool hasCache = await checkLocalCache(fullUrl);
      if (hasCache) {
        _showToast("📂 Loading from offline cache..."); // cache থেকে লোড হলে
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (isOnline == true) {
      await downloadAndCachePdf(fullUrl);
    } else {
      errorMessage = 'Offline: No internet and no cached file available.';
      _showToast(errorMessage!, isError: true);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkLocalCache(String fullUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = fullUrl.split('/').last.split('?').first;
      final file = File('${directory.path}/$fileName');

      if (await file.exists()) {
        cachedPdfFile = file;
        return true;
      }
    } catch (e) {
      print('Error checking cache: $e');
    }
    return false;
  }

  Future<void> downloadAndCachePdf(String fullUrl) async {
    try {
      _showToast("⏳ Downloading PDF from server..."); // ডাউনলোড শুরু
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        if (kIsWeb) {
          webPdfBytes = response.bodyBytes;
          _showToast("✅ PDF loaded successfully!"); // ওয়েবে লোড সাকসেস
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final fileName = originalFileName(fullUrl);
          final file = File('${directory.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes);
          cachedPdfFile = file;
          _showToast(
            "✅ PDF downloaded and cached successfully!",
          ); // মোবাইলে সেভ সাকসেস
        }
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
        _showToast(errorMessage!, isError: true);
      }
    } catch (e) {
      errorMessage = 'Failed to load PDF: $e';
      _showToast(errorMessage!, isError: true);
    }
  }

  String originalFileName(String url) {
    return url.split('/').last.split('?').first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarCustom(
          'View PDF',
          actions: [
            IconButton(
              onPressed: () => _pdfViewerController.previousPage(),
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () => _pdfViewerController.nextPage(),
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ErrorScreen(error: errorMessage!);
    }

    if (!kIsWeb && cachedPdfFile != null) {
      return SfPdfViewer.file(
        cachedPdfFile!,
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        onDocumentLoadFailed: (details) {
          setState(() {
            errorMessage = details.description;
          });
        },
      );
    }

    if (kIsWeb && webPdfBytes != null) {
      return SfPdfViewer.memory(
        webPdfBytes!,
        key: _pdfViewerKey,
        canShowPaginationDialog: true,
        controller: _pdfViewerController,
        onDocumentLoadFailed: (details) {
          setState(() {
            errorMessage = "Error: ${details.description}";
          });
        },
      );
    }

    return const ErrorScreen(error: 'Unknown error occurred or file missing.');
  }
}
