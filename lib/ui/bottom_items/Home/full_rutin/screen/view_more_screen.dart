// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/ui/bottom_items/Add/screens/addClassScreen.dart';
import 'package:table/ui/bottom_items/Add/screens/addPriode.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/see_all_req_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../../models/ClsassDetailsModel.dart';
import '../../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../../widgets/appWidget/appText.dart';
import '../../../../../widgets/hedding_row.dart';
import '../../../../../widgets/heder/hederTitle.dart';
import '../../../../auth_Section/utils/Login_validation.dart';
import '../../../../server/rutinReq.dart';
import '../sunnary/summat_screens/summary_screen.dart';
import '../widgets/account_card_widgets.dart';
import '../widgets/class_row.dart';
import '../widgets/priode_widget.dart';
import '../widgets/seeAllCaotensList.dart';

class ViewMore extends StatefulWidget {
  final String rutinId;
  const ViewMore({Key? key, required this.rutinId}) : super(key: key);

  @override
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
                  const AppText("CSE BATCH 23").title(),
                  const AppText("khulna polytechnic institute").heding(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                        controller: controller,
                        labelColor: AppColor.nokiaBlue,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(child: Text("Class List")),
                          Tab(child: Text("Members")),
                          Tab(child: Text("Captens")),
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

class ClassListPage extends ConsumerWidget {
  final String rutinId;
  final String rutinName;
  const ClassListPage(
      {super.key, required this.rutinId, required this.rutinName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(rutinId);
    final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          HeddingRow(
            hedding: "Priode List",
            second_Hedding: "23 members",
            margin: EdgeInsets.zero,
            buttonText: "Add Priode",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AppPriodePage(rutinId: rutinId, rutinName: rutinName),
                ),
              );
            },
          ),
          Row(
            children: List.generate(2, (index) => const PriodeWidget()),
          ),
          HeddingRow(
            hedding: "Class List",
            second_Hedding: "23 members",
            margin: EdgeInsets.zero,
            buttonText: "Add Class",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddClassSceen(rutinId: rutinId)),
              );
            },
          ),
          SizedBox(
              height: 300,
              child: rutinDetals.when(
                data: (data) {
                  if (data == null || data.classes == null)
                    return const Text("Null");
                  return ListView.builder(
                    itemCount: data.classes.allClass.length,
                    itemBuilder: (context, index) {
                      Day classes = data.classes.allClass[index];
                      return ClassRow(
                        id: classes.id,
                        className: classes.name,
                        ontap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SummaryScreen(
                                classId: classes.classId,
                                day: classes,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Text("Loding"),
              )),
        ],
      ),
    );
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

          Container(
            height: 200,
            child: Column(
              children: [
                Container(
                    height: 200,
                    child: allRequest.when(
                        data: (data) {
                          if (data == null) return const Text(" data null");
                          if (data.listAccounts.isEmpty)
                            return const Text("No new request ");
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
                        loading: () => const Text("data"))),
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
                return const Text("null");
              return SizedBox(
                height: 140,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.Members!.length,
                    itemBuilder: (context, index) =>
                        AccountCardRow(accountData: data.Members![index])),
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
