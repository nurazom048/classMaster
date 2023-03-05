import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Home/class/all_class-rutin.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutinReq.dart';
import 'package:table/ui/bottom_items/Home/home_screen/search_page.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

//
class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final rutinName = TextEditingController();

  String? message;

//
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRutin = ref.watch(all_rutins_provider);
    final saveRutin = ref.watch(save_rutins_provider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //... Appbar .../
              CustomTopBar(
                "All Rutins",
                acction: IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPAge())),
                    icon: const Icon(Icons.search)),
                icon: Icons.add_circle_outlined,
                ontap: () => _showDialog(context, rutinName),
              ),

              //
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //... all rutins...//
                      MyText("My All Rutin"),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        //.. Show all rutins..//
                        child: myRutin.when(
                          loading: () => const Progressindicator(),
                          data: (data) {
                            var myRutines = data;

                            return Row(
                              children: List.generate(
                                  myRutines.isEmpty ? 1 : myRutines.length,
                                  (index) => myRutines.isEmpty
                                      ? const Text(
                                          "You Dont Have any Rutin created")
                                      : InkWell(
                                          child: CustomRutinCard(
                                            rutinname: myRutines[index]["name"],
                                            profilePicture: myRutines[index]
                                                ["ownerid"]["image"],
                                            name: myRutines[index]["ownerid"]
                                                ["name"],
                                            username: myRutines[index]
                                                ["ownerid"]["username"],

                                            //
                                          ),

                                          //
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllClassScreen(
                                                        rutinName:
                                                            myRutines[index]
                                                                ["name"],
                                                        rutinId:
                                                            myRutines[index]
                                                                ["_id"],
                                                      ))),
                                        )),
                            );
                          },
                          error: (error, stackTrace) =>
                              Alart.showSnackBar(context, error.toString()),
                        ),
                      ),

                      //... hedding .../
                      MyText("Saved Rutin"),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: saveRutin.when(
                            loading: () => const Progressindicator(),
                            data: (saveRutin) {
                              return Row(
                                children: List.generate(
                                    saveRutin.isEmpty ? 1 : saveRutin.length,
                                    (index) => saveRutin.isEmpty
                                        ? const Text(
                                            "You Dont Have any Rutin created")
                                        : InkWell(
                                            child: CustomRutinCard(
                                              rutinname: saveRutin[index]
                                                  ["name"],
                                              profilePicture: saveRutin[index]
                                                  ["ownerid"]["image"],
                                              name: saveRutin[index]["ownerid"]
                                                  ["name"],
                                              username: saveRutin[index]
                                                  ["ownerid"]["username"],
                                            ),

                                            //
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllClassScreen(
                                                          rutinName:
                                                              saveRutin[index]
                                                                  ["name"],
                                                          rutinId:
                                                              saveRutin[index]
                                                                  ["_id"],
                                                        ))),
                                          )),
                              );
                            },
                            error: (error, stackTrace) =>
                                Alart.showSnackBar(context, error.toString())),
                      ),

                      //... hedding .../
                      MyText("Others Rutins"),

                      //... all rutins...//
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              3,
                              (index) =>
                                  CustomRutinCard(rutinname: "ET / 7 /1")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//.... Create Rutin
  void _showDialog(context, rutinName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" Create Rutin "),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rutinName,
                decoration: const InputDecoration(hintText: "Enter Rutin name"),
              ),
              const SizedBox(height: 17),

              //... create rutin button .../
              Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.blue,
                  child: const Text("Create"),
                  onPressed: () {
                    RutinReqest().creatRutin(rutinName: rutinName);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

///.... onlong press
onLongpress_class(context, rutinId, message) {
  //,, delete rutin
  Future<void> deleteRutin() async {
    print(rutinId);

    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    final response = await http.delete(
        Uri.parse('http://192.168.31.229:3000/class/delete/$rutinId'),
        headers: {'Authorization': 'Bearer $getToken'});

    //.. show message
    final res = json.decode(response.body);
    message = json.decode(response.body)["message"];
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message!)));
    }
    //
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Do you want to..",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black))),

          // BottomText(
          //   "Edit",
          //   onPressed: () => Navigator.push(
          //                                         context,
          //                                         MaterialPageRoute(
          //                                             builder: (context) =>
          //                                                 AllClassScreen(
          //                                                   rutinId: ""

          //                                                        ,
          // ),),),),

          //.... remove
          BottomText(
            "Remove",
            color: CupertinoColors.destructiveRed,
            onPressed: () => deleteRutin(),
          ),
          //.... Cancel
          BottomText("Cancel"),
        ],
      ),
    ),
  );
}
