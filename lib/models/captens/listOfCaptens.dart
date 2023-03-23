import 'package:table/models/Account_models.dart';

class ListCptens {
  ListCptens({
    required this.message,
    required this.count,
    required this.totalPages,
    required this.currentPage,
    required this.captains,
  });

  String message;
  int count;
  int totalPages;
  int currentPage;
  List<AccountModels> captains;

  factory ListCptens.fromJson(Map<String, dynamic> json) {
    List<AccountModels> captainsList = [];
    List<dynamic> captainsJson = json['captains'];
    captainsJson.forEach((captainJson) {
      Map<String, dynamic> cap10AcJson = captainJson['cap10Ac'];
      AccountModels captain = AccountModels(
          sId: captainJson['_id'],
          username: cap10AcJson['username'],
          name: cap10AcJson['name'],
          password: null,
          image: cap10AcJson['image'],
          position: captainJson['position']);
      captainsList.add(captain);
    });

    return ListCptens(
      message: json["message"],
      count: json["count"],
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
      captains: captainsList,
    );
  }
}
