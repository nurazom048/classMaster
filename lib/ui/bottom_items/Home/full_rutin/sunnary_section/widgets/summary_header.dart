import 'package:flutter/material.dart';

import '../../../../../../widgets/heder/hederTitle.dart';
import '../../widgets/rutin_box/rutin_card_row.dart';

class SummaryHeader extends StatelessWidget {
  const SummaryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(flex: 1),
            HeaderTitle("Routine", context),
            const Spacer(flex: 10),
            const RutineCardInfoRow(
              taill: TitleAndSubtile(
                crossAxisAlignment: CrossAxisAlignment.end,
                title: "!04",
                subtitle: " 13/A",
                textScaleFactor: 2.2,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}
