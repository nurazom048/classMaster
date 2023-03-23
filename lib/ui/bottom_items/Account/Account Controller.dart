import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/widgets/Alart.dart';

final AccountControllerProvider = Provider<AccountController>((ref) {
  return AccountController(ref.watch(AccountReqProvider));
});
//

//
class AccountController {
  AccountReq reqAccount;
  AccountController(this.reqAccount);

  //

  Future<AccountModels?> account(context, username) async {
    var res = await reqAccount.accountData(username);

    res.catchError((e) => Alart.handleError(context, e));
    res.catchError((e) {
      return AccountModels.fromJson(res);
    });
  }
}
