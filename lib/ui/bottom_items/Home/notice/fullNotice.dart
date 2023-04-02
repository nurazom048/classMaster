import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table/helper/constant/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'package:pdf_flutter/pdf_flutter.dart';

class AllContentPage extends ConsumerWidget {
  const AllContentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 600,
            child: FutureBuilder<AllContentResponse>(
              future: fetchAllContent("6426ad75975a0623791809ec", 1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.content.length,
                    itemBuilder: (context, index) {
                      final notice = snapshot.data!.content[index];
                      return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewContentPage(content: notice))),
                          child: Text(notice.contentName));
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Future<AllContentResponse> fetchAllContent(String noticeId, int page) async {
  final response = await http
      .get(Uri.parse('${Const.BASE_URl}/notice/getContent/$noticeId'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return AllContentResponse.fromJson(jsonDecode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load all content');
  }
}

class ViewContentPage extends StatefulWidget {
  final Content content;

  const ViewContentPage({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  _ViewContentPageState createState() => _ViewContentPageState();
}

class _ViewContentPageState extends State<ViewContentPage> {
  late final PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Content'),
        actions: [
          IconButton(
            onPressed: () {
              if (_pdfViewerController.pageNumber > 1) {
                _pdfViewerController.previousPage();
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () {
              if (_pdfViewerController.pageNumber <
                  _pdfViewerController.pageCount) {
                _pdfViewerController.nextPage();
              }
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        clipBehavior: Clip.hardEdge,

        ///  physics: const BouncingScrollPhysics(),
        child: Scrollbar(
          thickness: 20,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Text(
                  widget.content.contentName,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  widget.content.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  widget.content.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  widget.content.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  widget.content.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                height: 700,
                width: MediaQuery.of(context).size.width - 10,
                child: SfPdfViewer.network(
                  widget.content.pdfUrl ?? '',
                  canShowScrollStatus: false,
                  onPageChanged: (details) {
                    print(details.newPageNumber);
                  },
                  controller: _pdfViewerController,
                  enableDocumentLinkAnnotation: false,
                  pageSpacing: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Content {
  String contentName;
  String pdf;
  String description;
  String id;
  DateTime time;
  String? pdfUrl;

  Content({
    required this.contentName,
    required this.pdf,
    required this.description,
    required this.id,
    required this.time,
    this.pdfUrl,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      contentName: json['content_name'],
      pdf: json['pdf'],
      description: json['description'],
      id: json['_id'],
      time: DateTime.parse(json['time']),
      pdfUrl: json['pdfUrl'] ?? '',
    );
  }
}

class AllContentResponse {
  String message;
  List<Content> content;

  AllContentResponse({
    required this.message,
    required this.content,
  });

  factory AllContentResponse.fromJson(Map<String, dynamic> json) {
    return AllContentResponse(
      message: json['message'],
      content:
          List<Content>.from(json['content'].map((x) => Content.fromJson(x))),
    );
  }
}
