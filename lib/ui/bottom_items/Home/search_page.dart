// ignore_for_file: sized_box_for_whitespace, unused_element, unused_field

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/rutin_card.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchController;

  List<Map<String, dynamic>> rutins = [
    {
      "rutin_name": "mhs",
    },
    {
      "rutin_name": "abc",
    }
  ];

  //

//.... for search ..../
  List<Map<String, dynamic>> _show_search_rutin = [];

//
  void _filterItems(String searchQuery) async {
    //
    Future<List<Map<String, dynamic>>> searchRoutine(String query) async {
      final response = await http
          .get(Uri.parse('http://localhost:3000/rutin/search?q=$query'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        //
        List<Map<String, dynamic>> routines =
            data as List<Map<String, dynamic>>;
        return routines;
      } else {
        return [];
        //throw Exception('Failed to search routines');
      }
    }

    //... search by rutin name ...//
    if (searchQuery.isEmpty) {
      setState(() {
        _show_search_rutin = rutins;
      });
    }

    //
    var searched_rutin = rutins
        .where((item) => item["rutin_name"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    //
    setState(() {
      _show_search_rutin = searched_rutin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //.. search
            search(
              controller: _searchController,
              onChanged: (valu) => _filterItems(valu),
            ),

            // items
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: _show_search_rutin.length,
                itemBuilder: (context, index) => CustomRutinCard(
                    rutinname: _show_search_rutin[index]["rutin_name"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget search({controller, onChanged}) => CupertinoNavigationBar(
        middle: CupertinoTextField(
          onChanged: onChanged,
          controller: controller,
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
            child: Icon(CupertinoIcons.search, size: 18.0),
          ),
          suffix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.clear_all_rounded, size: 18.0),
          ),
        ),
      );
}
