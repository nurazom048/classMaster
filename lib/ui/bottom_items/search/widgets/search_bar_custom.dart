import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final Function(String)? onChanged;
  const SearchBarCustom({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: CupertinoTextField(
        onChanged: onChanged,
        // onSubmitted: (valu) => onChanged,
        // controller: _searchController,
        placeholder: 'Search',
        clearButtonMode: OverlayVisibilityMode.editing,
        style: const TextStyle(fontSize: 16),
        cursorColor: CupertinoColors.activeBlue,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border.all(
            color: CupertinoColors.inactiveGray,
            width: 0.5,
          ),
        ),
        prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(CupertinoIcons.search, size: 18.0)),
        suffix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.clear_all_rounded, size: 18.0)),
      ),
    );
  }
}
