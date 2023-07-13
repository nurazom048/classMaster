// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import '../../constant/app_color.dart';
import '../../ui/bottom_items/Home/Full_routine/widgets/routine_box/routine_box_by_ID.dart';

final initialDayProvider = StateProvider<DateTime>((ref) {
  return initialDateTimeMakerBaseOnSunday();
});

class SelectDayRow extends ConsumerWidget {
  final void Function(int) selectedDay;
  final String routineId;

  SelectDayRow({
    super.key,
    required this.selectedDay,
    required this.routineId,
  });

  final List dayNAme = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(initialWeekdayProvider(routineId));
    // sleeted day
    final selectedDays = ref.read(initialWeekdayProvider(routineId));
    final selectedDaysNotifier =
        ref.read(initialWeekdayProvider(routineId).notifier);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      //  color: Colors.red,
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) => SelectDayChip(
          index: index,
          isSelected: index == selectedDays,
          text: dayNAme[index],
          onTap: () {
            selectedDaysNotifier.update((state) => index);

            selectedDay.call(index);
          },
        ),
        separatorBuilder: (context, index) {
          return const SizedBox(width: 0);
        },
      ),
    );
  }
}

class SelectDayChip extends ConsumerWidget {
  final String text;
  final bool isSelected;
  final dynamic onTap;
  final int index;
  const SelectDayChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('rebuild');
    final initialDay = ref.read(initialDayProvider);
    final int day = initialDay.add(Duration(days: index)).day;
    final Color? color = isSelected ? const Color(0xFFF2F2F2) : null;
    return InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 35,
            width: 55,

            //  color: Colors.amber,
            color: color,
            // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                    textScaleFactor: 1,
                    style: TS.opensensBlue(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: isSelected ? AppColor.nokiaBlue : Colors.black,
                    )),
                const SizedBox(height: 2),
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      isSelected ? AppColor.nokiaBlue : AppColor.background,
                  child: Text(
                    '${day < 10 ? '0' : ''}$day',
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

//
DateTime initialDateTimeMakerBaseOnSunday() {
  DateTime now = DateTime.now();

  // Subtract days based on weekday
  if (now.weekday == DateTime.monday) {
    return now.subtract(const Duration(days: 1));
  }
  if (now.weekday == DateTime.tuesday) {
    return now.subtract(const Duration(days: 2));
  }
  if (now.weekday == DateTime.wednesday) {
    now.subtract(const Duration(days: 3));
  }
  if (now.weekday == DateTime.thursday) {
    return now.subtract(const Duration(days: 4));
  }
  if (now.weekday == DateTime.friday) {
    return now.subtract(const Duration(days: 5));
  }
  if (now.weekday == DateTime.saturday) {
    return now.subtract(const Duration(days: 6));
  } else {
    return now;
  }
}
