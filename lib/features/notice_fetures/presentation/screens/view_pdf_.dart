// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Access to app-specific directories for caching (non-web only)
import 'package:path_provider/path_provider.dart';

// Syncfusion widget for rendering PDFs from network or files
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// App-specific utilities and constants (e.g., BASE_URL)
import '../../../../core/export_core.dart';

// Connectivity check utility (isOnlineMethod)
import '../../../home_fetures/presentation/utils/utils.dart';

// PDF utility class for cache management
import '../utils/pdf_utils.dart';
// Adjust path based on your project structure

class ViewPDf extends StatefulWidget {
  final String pdfLink; // URL of the PDF to display

  const ViewPDf({Key? key, required this.pdfLink}) : super(key: key);

  @override
  _ViewPDfState createState() => _ViewPDfState();
}

class _ViewPDfState extends State<ViewPDf> {
  // Controller for navigating PDF pages
  final PdfViewerController _pdfViewerController = PdfViewerController();

  // Key to manage the PDF viewer widget state
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  bool?
      isOnline; // Tracks network status (null = checking, true = online, false = offline)
  String? errorMessage; // Stores any error messages for display
  File? cachedPdfFile; // Local file for cached PDF (non-web only)
  String? validatedPdfUrl; // Validated proxy URL for online PDF display
  bool isLoading = true; // Indicates if initialization is in progress

  @override
  void initState() {
    super.initState();
    initializePdf(); // Kick off PDF loading and caching logic once
    PdfUtils.initializeCacheClearTimer(); // Start the cache clearing timer
  }

  @override
  void dispose() {
    _pdfViewerController.dispose(); // Clean up the PDF controller
    super.dispose();
  }

  // Initializes online/offline status and PDF setup
  Future<void> initializePdf() async {
    isOnline = await Utils.isOnlineMethod(); // Check network connectivity
    print('Online status: $isOnline');

    if (!kIsWeb) {
      await initializeCachedPdf(); // Look for cached PDF on non-web platforms
    }

    if (isOnline == true) {
      final url =
          PdfUtils.getProxiedPdfUrl(widget.pdfLink); // Get the proxy URL
      validatedPdfUrl =
          await validateAndCachePdfUrl(url); // Validate and cache if online
    }

    setState(() {
      isLoading = false; // Initialization complete, update UI
    });
  }

  // Checks for an existing cached PDF file (non-web only)
  Future<void> initializeCachedPdf() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = widget.pdfLink
          .split('/')
          .last
          .split('?')
          .first; // Extract filename from URL
      final file = File('${directory.path}/$fileName');

      if (await file.exists()) {
        cachedPdfFile = file;
        print('Cached PDF found at: ${file.path}');
      }
    } catch (e) {
      print('Error initializing cached PDF: $e');
    }
  }

  // Validates the proxy URL and caches the PDF if valid (non-web only)
  Future<String?> validateAndCachePdfUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print('Proxy response status: ${response.statusCode}');
      print('Proxy response headers: ${response.headers}');

      if (response.statusCode == 200 &&
          response.headers['content-type'] == 'application/pdf') {
        if (!kIsWeb) {
          final directory = await getApplicationDocumentsDirectory();
          final fileName = widget.pdfLink.split('/').last.split('?').first;
          final file = File('${directory.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes); // Save PDF locally
          cachedPdfFile = file;
          print('PDF cached at: ${file.path}');
        }
        return url; // Return validated URL for display
      } else {
        errorMessage =
            'Invalid PDF response from proxy: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      errorMessage = 'Failed to validate PDF URL: $e';
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building ViewPDf with pdfLink: ${widget.pdfLink}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBarCustom(
          'View PDF',
          actions: [
            // Previous page button
            IconButton(
              onPressed: () {
                if (_pdfViewerController.pageNumber != 1) {
                  _pdfViewerController.previousPage();
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            // Next page button
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height -
              100, // Adjust height for app bar
          child: _buildContent(), // Delegate content building for clarity
        ),
      ),
    );
  }

  // Determines what to display based on state
  Widget _buildContent() {
    if (isLoading) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show loading during initialization
    }

    if (isOnline == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Initial state before connectivity check
    }

    if (isOnline == false && kIsWeb) {
      return const ErrorScreen(
          error: 'You are offline (Web)'); // Web offline: no caching
    }

    if (isOnline == false && cachedPdfFile != null) {
      return getCachedBody(); // Offline with cache: show local PDF
    }

    if (isOnline == false) {
      return const ErrorScreen(
          error:
              'You are offline and no cached PDF is available'); // Offline, no cache
    }

    if (errorMessage != null) {
      return ErrorScreen(error: errorMessage!); // Display any errors
    }

    if (validatedPdfUrl != null) {
      return getBody(
          validatedPdfUrl!); // Online with valid URL: show network PDF
    }

    return const ErrorScreen(
        error: 'Failed to load PDF'); // Fallback for unexpected failure
  }

  // Displays the PDF from the network URL
  Widget getBody(String pdfUrl) {
    print('Loading PDF from network: $pdfUrl');
    try {
      return SfPdfViewer.network(
        pdfUrl,
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        controller: _pdfViewerController,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          print('PDF loaded successfully: $pdfUrl');
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          print('PDF load failed: ${details.error} - ${details.description}');
          setState(() {
            errorMessage = '${details.error}: ${details.description}';
          });
        },
      );
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        errorMessage = e.toString();
      });
      return const SizedBox(); // Empty widget on error
    }
  }

  // Displays the cached PDF from local storage (non-web only)
  Widget getCachedBody() {
    try {
      print('Loading cached PDF from: ${cachedPdfFile!.path}');
      return SfPdfViewer.file(
        cachedPdfFile!,
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        controller: _pdfViewerController,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          print('Cached PDF loaded successfully: ${cachedPdfFile!.path}');
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          print(
              'Cached PDF load failed: ${details.error} - ${details.description}');
          setState(() {
            errorMessage = '${details.error}: ${details.description}';
          });
        },
      );
    } catch (e) {
      print('Error loading cached PDF: $e');
      setState(() {
        errorMessage = e.toString();
      });
      return const SizedBox(); // Empty widget on error
    }
  }
}
