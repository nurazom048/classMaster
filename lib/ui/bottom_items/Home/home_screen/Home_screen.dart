// ignore_for_file: unused_local_variable, non_constant_identifier_names, unused_field

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/full_rutin_view.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutinReq.dart';
import 'package:table/ui/bottom_items/Home/home_screen/search_page.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/GridView/GridViewRutin.dart';
import 'package:table/widgets/GridView/GridsaveRutin.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/hedding_row.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

final currentPageProvider = StateProvider((ref) => 1);

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final rutinName = TextEditingController();

  final uploadRutinController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          child: Consumer(builder: (context, ref, _) {
            //
            final pages = ref.watch(currentPageProvider);
            final myRutin = ref.watch(all_rutins_provider);
            final saveRutin = ref.watch(save_rutins_provider(1));
            final uploaded_rutin = ref.watch(uploaded_rutin_provider(pages));
            final joined_rutin = ref.watch(joined_rutin_provider(pages));

            //

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //... Appbar .../
                CustomTopBar("All Rutins",
                    acction: IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPAge())),
                        icon: const Icon(Icons.search)),
                    icon: Icons.add_circle_outlined,
                    ontap: () => _showDialog(context, rutinName)),

                //
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeddingRow(
                            hedding: "Uploded Rutins",
                            second_Hedding: "View all",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GridViewRutin()))),

                        //
                        SingleChildScrollView(
                            controller: uploadRutinController,
                            scrollDirection: Axis.horizontal,
                            child: uploaded_rutin.when(
                                loading: () => const Progressindicator(),
                                data: (data) {
                                  // data
                                  var UploadedRutins = data.uploaded_rutin;

                                  // int length = UploadedRutins.isEmpty
                                  //     ? 1
                                  //     : UploadedRutins.length;
                                  return SizedBox(
                                    height: 270,
                                    width: width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          data.uploaded_rutin.length * pages,
                                      itemBuilder: (context, index) {
                                        //    print("index" + index.toString());
                                        //
                                        var uploadedRutinidex =
                                            UploadedRutins[index];

                                        return UploadedRutins.isNotEmpty
                                            ? CustomRutinCard(
                                                rutinname:
                                                    uploadedRutinidex.name,
                                                profilePicture:
                                                    uploadedRutinidex
                                                        .ownerid.image,
                                                name: data.uploaded_rutin[index]
                                                    .ownerid.name,
                                                username: uploadedRutinidex
                                                    .ownerid.username,
                                                last_update: uploadedRutinidex
                                                    .lastSummary.text,

                                                //
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullRutineView(
                                                      rutinName:
                                                          uploadedRutinidex
                                                              .name,
                                                      rutinId:
                                                          uploadedRutinidex.id,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                "You Dont Have any Rutin created");
                                      },
                                      padding: const EdgeInsets.only(right: 30),
                                      physics: const BouncingScrollPhysics(),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Alart.handleError(context, error))),

                        // //... hedding .../
                        HeddingRow(
                            hedding: "Saved Rutin",
                            second_Hedding: "View all",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Grid_save_rutin()))),

                        //
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: saveRutin.when(
                                loading: () => const Progressindicator(),
                                data: (data) {
                                  // data
                                  var saveRutins = data.savedRoutines;
                                  int length = saveRutins.length;

                                  return SizedBox(
                                    height: 270,
                                    width: width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: length,
                                      itemBuilder: (context, index) {
                                        var saveRutinidex = saveRutins[index];

                                        return saveRutins.isNotEmpty
                                            ? CustomRutinCard(
                                                rutinname: saveRutinidex.name,
                                                profilePicture:
                                                    saveRutinidex.ownerid.image,
                                                name:
                                                    saveRutinidex.ownerid.name,
                                                username: saveRutinidex
                                                    .ownerid.username,
                                                last_update: saveRutinidex
                                                    .lastSummary.text,

                                                //
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullRutineView(
                                                      rutinName:
                                                          saveRutinidex.name,
                                                      rutinId: saveRutinidex.id,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                "You Dont Have any Rutin created");
                                      },
                                      padding: const EdgeInsets.only(right: 30),
                                      physics: const BouncingScrollPhysics(),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Alart.handleError(context, error))),

                        //... hedding .../

                        HeddingRow(
                            hedding: "joined Rutins",
                            second_Hedding: "View all",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GridViewRutin()))),

                        //
                        SingleChildScrollView(
                            controller: uploadRutinController,
                            scrollDirection: Axis.horizontal,
                            child: joined_rutin.when(
                                loading: () => const Progressindicator(),
                                data: (data) {
                                  var joinedRutins = data.routines;

                                  return SizedBox(
                                    height: 270,
                                    width: width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.routines.length * pages,
                                      itemBuilder: (context, index) {
                                        //
                                        var Rutinidex = joinedRutins[index];

                                        return joinedRutins.isNotEmpty
                                            ? CustomRutinCard(
                                                rutinname: Rutinidex.name,
                                                profilePicture:
                                                    Rutinidex.owner.image,
                                                name: data
                                                    .routines[index].owner.name,
                                                username:
                                                    Rutinidex.owner.username,
                                                last_update:
                                                    Rutinidex.lastSummary.text,

                                                //
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullRutineView(
                                                      rutinName: Rutinidex.name,
                                                      rutinId: Rutinidex.id,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                "You Dont Have any Rutin created");
                                      },
                                      padding: const EdgeInsets.only(right: 30),
                                      physics: const BouncingScrollPhysics(),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Alart.handleError(context, error))),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
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
