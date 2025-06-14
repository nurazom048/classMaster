// ignore_for_file: camel_case_types, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/features/search_fetures/presentation/widgets/static_wdgets/search_bar_custom.dart';
import '../../../../../core/component/Loaders.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';

import '../../../../../core/widgets/account_card_row.dart';
import '../../../../../features/account_fetures/data/models/account_models.dart';
import '../../../data/datasources/member_request.dart';

final searchStringProvider = StateProvider((ref) => "");

class seeAllMembers extends ConsumerWidget {
  const seeAllMembers({
    super.key,
    required this.onUsername,
    required this.rutinId,
    this.buttonText,
  });

  //
  final String rutinId;

  final String? buttonText;
  final Function(String?, String?) onUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMembers = ref.watch(allMembersProvider(rutinId));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: SearchBarCustom(
                onChanged: (v) {
                  ref.read(searchStringProvider.notifier).update((state) => v);
                },
              ),
            ),
            Expanded(
              flex: 13,
              child: allMembers.when(
                data: (data) {
                  var lenght = data.members.length;
                  return ListView.builder(
                    itemCount: lenght,
                    itemBuilder: (context, index) {
                      if (data != null && data.members.isNotEmpty) {
                        return AccountCardRow(
                          accountData: AccountModels().copyWith(
                            id: data.members[index].id,
                            image: data.members[index].image,
                            name: data.members[index].name,
                            username: data.members[index].username,
                          ),
                          onUsername:
                              (username, position) =>
                                  onUsername(username, position),
                          buttontext: buttonText,
                          color: Colors.red,
                        );
                      } else {
                        return const Center(child: Text("No Account found"));
                      }
                    },
                  );
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
