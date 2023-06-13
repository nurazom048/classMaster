import 'package:flutter/material.dart';

import '../../../../../../widgets/appWidget/dottted_divider.dart';
import '../../../utils/utils.dart';
import '../models/all_summary_models.dart';
import '../summat_screens/summary_screen.dart';

class ChatsDribles extends StatelessWidget {
  final Summary summary;

  const ChatsDribles({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.blueAccent,
      constraints: const BoxConstraints(
        minHeight: 350,
        minWidth: double.infinity,
        maxHeight: 400,
      ),
      child: Container(
        width: 310,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30)
            .copyWith(bottom: 70),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F0FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner's information
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...[
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              summary.owner?.image ?? DEMO_PROFILE_IMAGE,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                summary.owner?.name ?? '',
                                textScaleFactor: 1.4,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                Utils.formatDate(summary.createdAt),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFF0168FF),
                                ),
                              ),
                            ],
                          ),
                        ],
                        // More VArt
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      height: 8,
                      width: 150,
                      child: DotedDivider(),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        summary.text ?? '',
                        textScaleFactor: 1.3,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.43,
                          color: Colors.black,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // const Spacer(),
              ],
            ),

            const Spacer(),

            // Image gallery
            Container(
              constraints: const BoxConstraints(
                minHeight: 0,
                maxHeight: 100,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: summary.imageLinks.length,
                itemBuilder: (context, index) => Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.rectangle,
                  ),
                  child: Image(
                    image: NetworkImage(summary.imageUrls[index]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
