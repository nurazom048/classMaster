import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutinReq.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';
import 'package:table/widgets/heder/hederTitle.dart';
import '../../../../widgets/appWidget/TextFromFild.dart';

class CreaeNewRutine extends StatelessWidget {
  CreaeNewRutine({super.key});
  final _rutineNameController = TextEditingController();
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
              const AppText("  Create A new \n  Routine").title(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //----------------------------------------------------------------//
                    AppTextFromField(
                      controller: _rutineNameController,
                      hint: "Rutine name",
                      labelText: "Enter class name",
                      validator: (value) => rutinNameValidator(value),
                    ),
                    const SizedBox(height: 100),

                    //----------------------------------------------------------------//

                    CupertinoButtonCustom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textt: "Create Rutine",
                      color: AppColor.nokiaBlue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _onTapToButton(context);
                        }
                      },
                    ),
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

  void _onTapToButton(context) async {
    Either<Message, Message> res =
        await RutinReqest.creatRutin(rutinName: _rutineNameController.text);

    res.fold((error) {
      Alart.errorAlartDilog(context, error.message);
    }, (data) {
      Alart.showSnackBar(context, data.message);
    });
  }

  //
  static String? rutinNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Routine name is required';
    }
    return null;
  }
}
