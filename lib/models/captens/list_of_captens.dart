// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';

import '../../ui/bottom_items/Collection Fetures/models/account_models.dart';

ListCptens listCptensFromJson(String str) =>
    ListCptens.fromJson(json.decode(str));

class ListCptens {
  String message;
  int count;
  List<AccountModels> captains;

  ListCptens({
    required this.message,
    required this.count,
    required this.captains,
  });

  factory ListCptens.fromJson(Map<String, dynamic> json) => ListCptens(
        message: json["message"],
        count: json["count"],
        captains: List<AccountModels>.from(
            json["captains"].map((x) => AccountModels.fromJson(x))),
      );
}
