class Classmodel {
  String instructorname, subjectcode, roomnum;
  double startingpriode, endingpriode;
  double? weith;
  String? mainpic, classsumary;

  Classmodel(
      {required this.instructorname,
      required this.subjectcode,
      this.mainpic,
      this.classsumary,
      required this.roomnum,
      required this.startingpriode,
      required this.endingpriode,
      this.weith});
}

class Priodemodel {
  List<Classmodel> date;

  Priodemodel({
    required this.date,
  });
}
