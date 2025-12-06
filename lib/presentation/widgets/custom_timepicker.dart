// import '/core/utils/export.dart';
// import 'package:intl/intl.dart';
//
// class CommonTimePickerTextField extends StatelessWidget {
//   final String title;
//   final String? hintText;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;
//
//   const CommonTimePickerTextField({
//     super.key,
//     required this.title,
//     this.hintText,
//     required this.controller,
//     this.validator,
//   });
//
//   Future<void> _selectTime(BuildContext context) async {
//     TimeOfDay initialTime;
//
//     if (controller.text.isNotEmpty) {
//       try {
//         final parsed = DateFormat('HH:mm').parse(controller.text);
//         initialTime = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
//       } catch (_) {
//         initialTime = TimeOfDay.now();
//       }
//     } else {
//       initialTime = TimeOfDay.now();
//     }
//
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//     );
//
//     if (pickedTime != null) {
//       final now = DateTime.now();
//       final formattedTime = DateFormat('HH:mm').format(
//         DateTime(
//           now.year,
//           now.month,
//           now.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         ),
//       );
//       controller.text = formattedTime;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyles.titleMedium.copyWith(
//             color: AppThemeNotifier.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           validator: validator,
//           onTap: () => _selectTime(context),
//           decoration: InputDecoration(
//             counterText: '',
//             filled: true,
//             contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//             hintText: hintText ?? "Enter $title",
//             hintStyle: TextStyles.bodyMedium.copyWith(
//               color: AppThemeNotifier.textTertiary,
//             ),
//             fillColor: AppThemeNotifier.background,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.border, width: 1),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.primary, width: 1),
//             ),
//             suffixIcon: Padding(
//               padding: const EdgeInsets.only(right: 10.0),
//               child: InkWell(
//                 onTap: () => _selectTime(context),
//                 child: Image.asset(
//                   ic_clock, // Make sure you have this clock icon asset
//                   color: AppThemeNotifier.textPrimary,
//                   height: 18,
//                 ),
//               ),
//             ),
//             suffixIconConstraints: const BoxConstraints(
//               minWidth: 18,
//               minHeight: 18,
//             ),
//           ),
//           style: TextStyles.bodyMedium.copyWith(
//             color: AppThemeNotifier.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
// }
