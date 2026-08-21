import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class AppQuillEditor extends StatefulWidget {
  final String? initialContent;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final double minHeight;

  const AppQuillEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.hintText = "Add routine details, syllabus, or instructions...",
    this.minHeight = 150,
  });

  @override
  State<AppQuillEditor> createState() => AppQuillEditorState();
}

class AppQuillEditorState extends State<AppQuillEditor> {
  late QuillController _controller;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    Document doc;
    if (widget.initialContent != null &&
        widget.initialContent!.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(widget.initialContent!);
        if (parsed is List) {
          doc = Document.fromJson(parsed);
        } else {
          doc = Document()..insert(0, widget.initialContent!);
        }
      } catch (_) {
        doc = Document()..insert(0, widget.initialContent!);
      }
    } else {
      doc = Document();
    }

    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.addListener(_onDocChanged);
  }

  void _onDocChanged() {
    if (widget.onChanged != null) {
      final jsonStr = jsonEncode(_controller.document.toDelta().toJson());
      widget.onChanged!(jsonStr);
    }
  }

  String get jsonDeltaString {
    return jsonEncode(_controller.document.toDelta().toJson());
  }

  String get plainText {
    return _controller.document.toPlainText().trim();
  }

  @override
  void dispose() {
    _controller.removeListener(_onDocChanged);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quill Toolbar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: QuillSimpleToolbar(
                controller: _controller,
                config: const QuillSimpleToolbarConfig(
                  multiRowsDisplay: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showSmallButton: false,
                  showInlineCode: false,
                  showCodeBlock: false,
                  showAlignmentButtons: true,
                  showDirection: false,
                  showDividers: true,
                  showClearFormat: true,
                ),
              ),
            ),
          ),
          // Quill Editor
          Padding(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: widget.minHeight),
              child: QuillEditor(
                controller: _controller,
                scrollController: _scrollController,
                focusNode: _focusNode,
                config: QuillEditorConfig(
                  placeholder: widget.hintText,
                  padding: EdgeInsets.zero,
                  autoFocus: false,
                  expands: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppQuillViewer extends StatelessWidget {
  final String? content;
  final TextStyle? defaultStyle;

  const AppQuillViewer({
    super.key,
    this.content,
    this.defaultStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (content == null || content!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    Document doc;
    try {
      final parsed = jsonDecode(content!);
      if (parsed is List) {
        doc = Document.fromJson(parsed);
      } else {
        return Text(content!, style: defaultStyle);
      }
    } catch (_) {
      return Text(content!, style: defaultStyle);
    }

    final controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );

    return QuillEditor(
      controller: controller,
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      config: const QuillEditorConfig(
        padding: EdgeInsets.zero,
        autoFocus: false,
        expands: false,
      ),
    );
  }
}
