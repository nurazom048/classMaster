// import 'package:flutter/material.dart';

// class CustomTopBar extends StatelessWidget {
//   final String title;
//   final IconData? icon;
//   final double elevation;
//   final Widget? acction;
//   final dynamic ontap;

//   const CustomTopBar(
//     this.title, {
//     this.ontap,
//     this.icon,
//     this.elevation = 4.0,
//     this.acction,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       color: Colors.black12,
//       padding: const EdgeInsets.all(9.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios, size: 22),
//             onPressed: () => Navigator.pop(context),
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Row(
//             children: [
//               if (ontap != null)
//                 InkWell(
//                   child: IconButton(
//                     icon: Icon(icon ?? Icons.edit, size: 22),
//                     onPressed: ontap,
//                   ),
//                   onTap: ontap,
//                 ),
//               acction ?? const SizedBox(width: 0)
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
