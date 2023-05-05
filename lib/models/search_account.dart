// ignore_for_file: prefer_collection_literals

import 'package:table/ui/bottom_items/Account/models/Account_models.dart';

class AccountsResponse {
  List<AccountModels>? accounts;
  int? currentPage;
  int? totalPages;
  int? totalCount;

  AccountsResponse({
    this.accounts,
    this.currentPage,
    this.totalPages,
    this.totalCount,
  });

  AccountsResponse.fromJson(Map<String, dynamic> json) {
    if (json['accounts'] != null) {
      accounts = <AccountModels>[];
      json['accounts'].forEach((v) {
        accounts!.add(AccountModels.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalCount'] = totalCount;
    return data;
  }
}
