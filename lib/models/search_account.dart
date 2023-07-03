// igimport 'package:table/ui/bottom_items/Account/models/account_models.dart';

import '../ui/bottom_items/Collection Fetures/models/account_models.dart';

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
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalCount'] = totalCount;
    return data;
  }

  AccountsResponse copyWith({
    List<AccountModels>? accounts,
    int? currentPage,
    int? totalPages,
    int? totalCount,
  }) {
    return AccountsResponse(
      accounts: accounts ?? this.accounts,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
