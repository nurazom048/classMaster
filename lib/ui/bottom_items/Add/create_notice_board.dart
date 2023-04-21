import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helper/constant/AppColor.dart';
import '../../../widgets/appWidget/TextFromFild.dart';
import '../../../widgets/appWidget/appText.dart';
import '../../../widgets/appWidget/buttons/cupertinoButttons.dart';
import '../../../widgets/heder/hederTitle.dart';
import '../Home/notice/createNoticeController.dart';

class CreateNoticeBoard extends StatelessWidget {
  CreateNoticeBoard({super.key});
  final _nameCon = TextEditingController();
  final _aboutCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              HeaderTitle("Hone", context),
              const SizedBox(height: 53),
              const AppText("  Create A new \n  NoticeBoard").title(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //----------------------------------------------------------------//
                    AppTextFromField(
                      controller: _nameCon,
                      hint: "NoticeBoard name",
                      labelText: "Enter NoticeBoard name ",
                      validator: (value) => rutinNameValidator(value),
                    ),

                    //----------------------------------------------------------------//

                    AppTextFromField(
                      controller: _aboutCon,
                      hint: "About",
                      labelText: "about this notice Board",
                    ),
                    const SizedBox(height: 50),
                    // ----------------------------------------------------------------//
                    Consumer(builder: (context, ref, _) {
                      final createNoticeBoardNotifier =
                          ref.watch(noticeBoardCreater_provider.notifier);
                      final isCreatingNoticeBoard = ref
                          .watch(noticeBoardCreater_provider)
                          .createNoticeBoardLoader;
                      return isCreatingNoticeBoard
                          ? CircularProgressIndicator()
                          : CupertinoButtonCustom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              isLoding: isCreatingNoticeBoard,
                              textt: "Create NoticeBoard",
                              color: AppColor.nokiaBlue,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  createNoticeBoardNotifier.createNoticeBoard(
                                      _nameCon.text, _aboutCon.text, context);
                                }
                              },
                            );
                    }),

                    const SizedBox(height: 200),
                  ],
                ),

                //
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapToButton() {
    //RutinReqest().creatRutin(rutinName: _rutineNameController.text);
  }

  //
  static String? rutinNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'NoticeBoard name is required';
    }
    return null;
  }
}
