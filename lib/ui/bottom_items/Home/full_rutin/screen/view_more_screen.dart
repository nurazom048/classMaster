import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/component_improts.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/account_card_widgets.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/seeAllCaotensList.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../../widgets/appWidget/appText.dart';
import '../../../../../widgets/hedding_row.dart';
import '../../../../../widgets/heder/hederTitle.dart';
import '../../../../auth_Section/utils/Login_validation.dart';
import '../../../../server/rutinReq.dart';

class ViewMore extends StatefulWidget {
  final String rutinId;
  ViewMore({Key? key, required this.rutinId}) : super(key: key);

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
            child: Container(
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
          const ClassListPage(),
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
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const Text("Priode List"),
          Column(
            children: List.generate(2, (index) => const ClassRow()),
          ),
          const Text("Class List"),
          Column(
            children: List.generate(4, (index) => const ClassRow()),
          ),
        ],
      ),
    );
  }
}

class MemberList extends ConsumerWidget {
  final String rutinId;
  MemberList({super.key, required this.rutinId});
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final all_members = ref.watch(all_members_provider(rutinId));

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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const AccountCard();
                  },
                ),
              ),
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

        all_members.when(
          data: (data) {
            if (data == null || data.message == null) return const Text("null");
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
  }
}

class ClassRow extends StatelessWidget {
  const ClassRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width - 10,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText("English", color: Colors.black).heding(),
          const Icon(Icons.arrow_forward)
        ],
      ),
    );
  }
}
