// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarCustom extends StatefulWidget {
  final Function(String)? onChanged;

  const SearchBarCustom({super.key, required this.onChanged});

  @override
  _SearchBarCustomState createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  final TextEditingController _textEditingController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          Expanded(
            child: TextField(
              onChanged: widget.onChanged,
              autocorrect: true,
              controller: _textEditingController,
              style: const TextStyle(fontSize: 16),
              cursorColor: CupertinoColors.activeBlue,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(CupertinoIcons.search, size: 18.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _textEditingController.clear();
                      widget.onChanged?.call('');
                    });
                  },
                  icon: const Icon(Icons.close, size: 18.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: CupertinoColors.inactiveGray,
                    width: 0.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
