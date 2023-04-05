// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/GridView/GridViewRutin.dart';
import 'package:table/widgets/GridView/GridsaveRutin.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/hedding_row.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../widgets/GridView/Grid_join_rutin.dart';
import 'dailog/create_rutin-dialog.dart';

final currentPageProvider = StateProvider((ref) => 1);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          child: Consumer(builder: (context, ref, _) {
            //! provider
            final pages = ref.watch(currentPageProvider);
            final saveRutin = ref.watch(save_rutins_provider(1));
            final uploaded_rutin = ref.watch(uploaded_rutin_provider(pages));
            final joined_rutin = ref.watch(joined_rutin_provider(pages));

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
                    ontap: () => createRutinDialog(context)),

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
                            scrollDirection: Axis.horizontal,
                            child: uploaded_rutin.when(
                                loading: () => const Progressindicator(),
                                data: (data) {
                                  // data
                                  var UploadedRutins = data.rutins;

                                  return SizedBox(
                                    height: 270,
                                    width: width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.rutins.length * pages,
                                      itemBuilder: (context, index) {
                                        //
                                        var uploadedRutinidex =
                                            UploadedRutins[index];

                                        return UploadedRutins.isNotEmpty
                                            ? CustomRutinCard(
                                                rutinModel: data.rutins[index])
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
                                      itemBuilder: (context, i) {
                                        return saveRutins.isNotEmpty
                                            ? CustomRutinCard(
                                                rutinModel: saveRutins[i])
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
                                        const gridJoinRutins()))),

                        //
                        SingleChildScrollView(
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
                                                rutinModel:
                                                    data.routines[index])
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
}
