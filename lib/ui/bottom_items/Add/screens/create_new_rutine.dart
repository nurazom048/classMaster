import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutin_req.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/appWidget/buttons/cupertino_butttons.dart';
import 'package:table/widgets/heder/heder_title.dart';
import '../../../../constant/app_color.dart';
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
