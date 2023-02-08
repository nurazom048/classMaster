import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class RutinCard extends StatelessWidget {
  String name;
  String username;
  String rutinname;
  RutinCard({
    required this.name,
    required this.rutinname,
    required this.username,
    super.key,
  });
  List days = ["Set", "Sun", "Mon", "Thu"];
  List priode = ["8:40\n9:10", "8:40\n9:10", "8:40\n9:10"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff73B8D5), Color(0xff074048)],
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: 8,
            right: 11,
            child: Row(
                children: List.generate(
              priode.length,
              (index) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  priode[index],
                  style: const TextStyle(
                    fontFamily: "Gluten",
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
              ),
            )),
          ),

          //

          Positioned(
            top: 40,
            left: 6,
            child: Column(
                children: List.generate(
              days.length,
              (index) => Text(
                days[index],
                style: const TextStyle(
                  fontFamily: "Alef",
                  fontSize: 18,
                ),
              ),
            )),
          ),
//......... Rutin Name
          Positioned(
              bottom: 75,
              right: 6,
              child: Column(
                children: [
                  rutinname.length > 10
                      ? Container(
                          height: 20,
                          width: 180,
                          child: Marquee(
                              text: rutinname,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22)),
                        )
                      : Text(rutinname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22)),
                ],
              )),

          //.... name and username
          Positioned(
              bottom: 10,
              left: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  name.length > 10
                      ? Container(
                          height: 30,
                          width: 200,
                          child: Marquee(
                              text: name,
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black)),
                        )
                      : Text(name,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),

                  //

                  username.length > 10
                      ? Container(
                          height: 27,
                          width: 190,
                          child: Marquee(
                              text: "@${username.toLowerCase()}",
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black)),
                        )
                      : Text("@${username.toLowerCase()}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                ],
              )),
        ]),
      ),
    );
  }
}
