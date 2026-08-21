import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class AppQuillEditor extends StatefulWidget {
  final dynamic initialContent;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final double minHeight;

  const AppQuillEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.hintText = "Add bold, underline, lists, instructions, links, or syllabus note...",
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
    String rawStr = '';

    if (widget.initialContent != null) {
      if (widget.initialContent is String) {
        rawStr = widget.initialContent as String;
      } else if (widget.initialContent is List || widget.initialContent is Map) {
        rawStr = jsonEncode(widget.initialContent);
      } else {
        rawStr = widget.initialContent.toString();
      }
    }

    if (rawStr.trim().isNotEmpty) {
      try {
        var parsed = jsonDecode(rawStr);
        if (parsed is String && parsed.trim().isNotEmpty) {
          try {
            parsed = jsonDecode(parsed);
          } catch (_) {}
        }

        if (parsed is List) {
          doc = Document.fromJson(parsed);
        } else if (parsed is Map &&
            parsed.containsKey('ops') &&
            parsed['ops'] is List) {
          doc = Document.fromJson(parsed['ops']);
        } else {
          doc = Document()..insert(0, rawStr);
        }
      } catch (_) {
        doc = Document()..insert(0, rawStr);
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
    if (mounted) {
      setState(() {});
    }
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

  void _toggleFormat(Attribute attribute) {
    final style = _controller.getSelectionStyle();
    if (style.containsKey(attribute.key)) {
      _controller.formatSelection(Attribute.clone(attribute, null));
    } else {
      _controller.formatSelection(attribute);
    }
  }

  bool _isFormatActive(Attribute attribute) {
    return _controller.getSelectionStyle().containsKey(attribute.key);
  }

  void _clearFormatting() {
    final style = _controller.getSelectionStyle();
    for (final key in style.attributes.keys) {
      final attr = style.attributes[key];
      if (attr != null) {
        _controller.formatSelection(Attribute.clone(attr, null));
      }
    }
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
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Custom Rich Text Toolbar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFormatButton(
                    icon: Icons.format_bold_rounded,
                    tooltip: "Bold",
                    isActive: _isFormatActive(Attribute.bold),
                    onTap: () => _toggleFormat(Attribute.bold),
                  ),
                  _buildFormatButton(
                    icon: Icons.format_italic_rounded,
                    tooltip: "Italic",
                    isActive: _isFormatActive(Attribute.italic),
                    onTap: () => _toggleFormat(Attribute.italic),
                  ),
                  _buildFormatButton(
                    icon: Icons.format_underlined_rounded,
                    tooltip: "Underline",
                    isActive: _isFormatActive(Attribute.underline),
                    onTap: () => _toggleFormat(Attribute.underline),
                  ),
                  _buildFormatButton(
                    icon: Icons.strikethrough_s_rounded,
                    tooltip: "Strikethrough",
                    isActive: _isFormatActive(Attribute.strikeThrough),
                    onTap: () => _toggleFormat(Attribute.strikeThrough),
                  ),
                  _buildDivider(),
                  _buildFormatButton(
                    icon: Icons.format_list_bulleted_rounded,
                    tooltip: "Bullet List",
                    isActive: _isFormatActive(Attribute.ul),
                    onTap: () => _toggleFormat(Attribute.ul),
                  ),
                  _buildFormatButton(
                    icon: Icons.format_list_numbered_rounded,
                    tooltip: "Numbered List",
                    isActive: _isFormatActive(Attribute.ol),
                    onTap: () => _toggleFormat(Attribute.ol),
                  ),
                  _buildDivider(),
                  _buildFormatButton(
                    icon: Icons.title_rounded,
                    tooltip: "Header 1",
                    isActive: _isFormatActive(Attribute.h1),
                    onTap: () => _toggleFormat(Attribute.h1),
                  ),
                  _buildFormatButton(
                    icon: Icons.subtitles_rounded,
                    tooltip: "Header 2",
                    isActive: _isFormatActive(Attribute.h2),
                    onTap: () => _toggleFormat(Attribute.h2),
                  ),
                  _buildFormatButton(
                    icon: Icons.format_quote_rounded,
                    tooltip: "Quote",
                    isActive: _isFormatActive(Attribute.blockQuote),
                    onTap: () => _toggleFormat(Attribute.blockQuote),
                  ),
                  _buildDivider(),
                  _buildFormatButton(
                    icon: Icons.format_clear_rounded,
                    tooltip: "Clear Formatting",
                    isActive: false,
                    onTap: _clearFormatting,
                  ),
                ],
              ),
            ),
          ),

          // Quill Editor Area
          Padding(
            padding: const EdgeInsets.all(14),
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

  Widget _buildFormatButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? const Color(0xFF2563EB) : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 20,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFFE2E8F0),
    );
  }
}

class AppQuillViewer extends StatelessWidget {
  final dynamic content;
  final TextStyle? defaultStyle;

  const AppQuillViewer({
    super.key,
    this.content,
    this.defaultStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (content == null) {
      return const SizedBox.shrink();
    }

    String contentStr = '';
    if (content is String) {
      contentStr = content as String;
    } else if (content is List || content is Map) {
      contentStr = jsonEncode(content);
    } else {
      contentStr = content.toString();
    }

    if (contentStr.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    Document doc;
    try {
      var parsed = jsonDecode(contentStr);
      if (parsed is String && parsed.trim().isNotEmpty) {
        try {
          parsed = jsonDecode(parsed);
        } catch (_) {}
      }

      if (parsed is List) {
        doc = Document.fromJson(parsed);
      } else if (parsed is Map &&
          parsed.containsKey('ops') &&
          parsed['ops'] is List) {
        doc = Document.fromJson(parsed['ops']);
      } else {
        return Text(contentStr, style: defaultStyle);
      }
    } catch (_) {
      return Text(contentStr, style: defaultStyle);
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
