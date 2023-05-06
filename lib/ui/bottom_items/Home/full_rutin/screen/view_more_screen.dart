// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/helper/constant/app_color.dart';
import 'package:table/ui/bottom_items/Add/screens/add_class_screen.dart';
import 'package:table/ui/bottom_items/Add/screens/add_priode.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/see_all_req_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/priode_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/logngPress.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../../models/class_details_model.dart';
import '../../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../../widgets/appWidget/appText.dart';
import '../../../../../widgets/hedding_row.dart';
import '../../../../../widgets/heder/heder_title.dart';
import '../../../../auth_Section/utils/login_validation.dart';
import '../../../../server/rutinReq.dart';
import '../sunnary_section/summat_screens/summary_screen.dart';
import '../widgets/account_card_widgets.dart';
import '../widgets/class_row.dart';
import '../widgets/priode_widget.dart';
import '../widgets/seeAllCaotensList.dart';
import 'package:flutter/material.dart' as ma;

class ViewMore extends StatefulWidget {
  final String rutinId;
  final String rutineName;
  final String? owenerName;
  const ViewMore(
      {Key? key,
      required this.rutinId,
      required this.rutineName,
      this.owenerName})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewMoreState createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 270,
              width: 300,
              child: Column(
                children: [
                  HeaderTitle("Rutine", context),
                  const SizedBox(height: 40),
                  AppText(widget.rutineName.toUpperCase()).title(),
                  AppText(widget.owenerName ?? "khulna polytechnic institute")
                      .heding(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                        controller: controller,
                        labelColor: AppColor.nokiaBlue,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(child: ma.Text("Class List")),
                          Tab(child: ma.Text("Members")),
                          Tab(child: ma.Text("Captens")),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
        body: TabBarView(controller: controller, children: [
          ClassListPage(rutinId: widget.rutinId, rutinName: widget.rutinId),
          MemberList(rutinId: widget.rutinId),
          seeAllcaptensList(
              onUsername: (onUsername, o) {}, rutinId: widget.rutinId)
        ]),
      ),

      //
    );
  }
}

final totlPriodeCountProvider = StateProvider<int>((ref) => 0);

class ClassListPage extends StatefulWidget {
  final String rutinId;
  final String rutinName;
  const ClassListPage(
      {super.key, required this.rutinId, required this.rutinName});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

int? totalMemberCount;
int? totalPriodeCount;

class _ClassListPageState extends State<ClassListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      print(widget.rutinId);
      final rutinDetals = ref.watch(rutins_detalis_provider(widget.rutinId));
      final allPriode = ref.watch(allPriodeProvider(widget.rutinId));

      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            HeddingRow(
              hedding: "Priode List",
              second_Hedding: "$totalPriodeCount  priode",
              margin: EdgeInsets.zero,
              buttonText: "Add Priode",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppPriodePage(
                      rutinId: widget.rutinId,
                      rutinName: widget.rutinName,
                      totalPriode: totalPriodeCount ?? 0,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 140,
              child: allPriode.when(
                  data: (data) {
                    return data.fold(
                        (l) => Alart.handleError(context, l.message), (r) {
                      print(r);

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: r.priodes.length,
                        itemBuilder: (context, index) {
                          String priodeId = r.priodes[index].id;

                          int length = r.priodes.length;

                          if (totalPriodeCount == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              // Add Your Code here.
                              setState(() {
                                totalPriodeCount = length;
                              });
                            });
                          }

                          return PriodeWidget(
                            priodeNumber: r.priodes[index].priodeNumber,
                            startTime: r.priodes[index].startTime,
                            endTime: r.priodes[index].endTime,
                            //
                            onLongpress: () {
                              PriodeAlart.logPressOnPriode(context, priodeId,
                                  widget.rutinId, r.priodes[index]);
                            },
                          );
                        },
                      );
                    });
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const ma.Text("loding")),
            ),
            HeddingRow(
              hedding: "Class List",
              second_Hedding: "$totalMemberCount  classes",
              margin: EdgeInsets.zero,
              buttonText: "Add Class",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddClassScreen(routineId: widget.rutinId)),
                );
              },
            ),
            SizedBox(
                height: 300,
                child: rutinDetals.when(
                  data: (data) {
                    if (data == null || data.classes == null)
                      return const ma.Text("Null");

                    return ListView.builder(
                      itemCount: data.classes.allClass.length,
                      itemBuilder: (context, index) {
                        Day day = data.classes.allClass[index];
                        int length = data.classes.allClass.length;
                        //
                        // Future.delayed(Duration(seconds: 1), () {
                        //   setState(() {
                        //     totalMemberCount = length;
                        //   });
                        // });
                        if (totalMemberCount == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Add Your Code here.
                            setState(() {
                              totalMemberCount = length;
                            });
                          });
                        }

                        return ClassRow(
                          id: day.id,
                          className: day.classId.name,

                          //
                          onLongPress: () {
                            PriodeAlart.logPressClass(context,
                                classId:
                                    data.classes.allClass[index].classId.id,
                                rutinId: widget.rutinId);
                          },

                          ontap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SummaryScreen(
                                  classId: day.classId.id,
                                  day: day,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const ma.Text("Loding"),
                )),
          ],
        ),
      );
    });
  }
}

class MemberList extends StatelessWidget {
  final String rutinId;
  MemberList({super.key, required this.rutinId});
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider
      final allMembers = ref.watch(all_members_provider(rutinId));
      final allRequest = ref.watch(seeAllRequestControllerProvider(rutinId));
      final seeAllJonReq =
          ref.read(seeAllRequestControllerProvider(rutinId).notifier);
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        children: [
          AppTextFromField(
            margin: EdgeInsets.zero,
            controller: _emailController,
            hint: "Invite Student",
            labelText: "Enter email address",
            validator: (value) => LoginValidation.validateEmail(value),
          ),
          const SizedBox(height: 20),
          const DashBorderButton(),
          const SizedBox(height: 30),

          //... Members...//
          HeddingRow(
            hedding: "Join Requests",
            second_Hedding: "see more",
            buttonText: "Accept All",
            onTap: () {},
          ),

          SizedBox(
            height: 200,
            child: Column(
              children: [
                SizedBox(
                    height: 200,
                    child: allRequest.when(
                        data: (data) {
                          if (data == null) return const ma.Text(" data null");
                          if (data.listAccounts.isEmpty)
                            return const ma.Text("No new request ");
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.listAccounts.length,
                            itemBuilder: (context, index) {
                              return AccountCard(
                                accountData: data.listAccounts[index],

                                // acsept or reject members
                                acceptUsername: () {
                                  print(data.listAccounts[index].username);
                                  seeAllJonReq.acceptMember(
                                      ref,
                                      data.listAccounts[index].username,
                                      context);
                                },
                                onRejectUsername: () {
                                  print(data.listAccounts[index].username);
                                  seeAllJonReq.rejectMembers(
                                      ref,
                                      data.listAccounts[index].username,
                                      context);
                                },
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => const ma.Text("data"))),
              ],
            ),
          ),

          ///
          ///

          const HeddingRow(
            hedding: "All Members",
            second_Hedding: "23 members",
          ),
          //

          allMembers.when(
            data: (data) {
              if (data == null || data.message == null)
                return const ma.Text("null");
              return SizedBox(
                height: 140,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.members!.length,
                    itemBuilder: (context, index) =>
                        AccountCardRow(accountData: data.members![index])),
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Progressindicator(),
          ),
        ],
      );
    });
  }
}
