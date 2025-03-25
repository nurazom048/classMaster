import '../../../account_fetures/data/models/account_models.dart';

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
