// import 'package:flutter/material.dart';
// import '/core/utils/export.dart';
//
// class CommonTextField extends StatelessWidget {
//   final String title;
//   final String? hintText;
//   final TextEditingController controller;
//   final String? Function(String?) ? validator;
//   final int maxLength;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final int maxLines;
//   final Color? fillColor;
//   final bool isSmaller;
//   final double verticalPadding;
//   ValueChanged<String>? onChanged;
//   final bool readOnly ;
//   final Widget ? suffixIcon;
//    CommonTextField({
//     super.key,
//     required this.hintText,
//     required this.title,
//     required this.controller,
//      this.validator ,
//     this.maxLength = 50,
//     this.maxLines = 1,
//     this.isSmaller = false,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.fillColor ,
//     this.verticalPadding = 12.0,
//     this.onChanged,
//      this.readOnly = false,
//      this.suffixIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//        title.toString() == ""?SizedBox():  Text(
//           title,
//           style:
//           isSmaller? TextStyles.bodyMedium.copyWith(
//             color: AppThemeNotifier.textPrimary,
//           ):
//           TextStyles.titleMedium.copyWith(
//             color: AppThemeNotifier.textPrimary,
//           ),
//         ),
//         title.toString() == ""?SizedBox(): const SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           maxLines: maxLines,
//           maxLength: maxLength,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           validator: validator,
//           onChanged: onChanged,
//           textCapitalization: TextCapitalization.sentences,
//           decoration: InputDecoration(
//             counterText: '',
//             filled: true,
//             suffixIcon: suffixIcon,
//             suffixIconConstraints: BoxConstraints(
//               maxWidth: 40,
//               maxHeight: 30
//             ),
//             isDense: isSmaller ?true:false,
//             contentPadding: EdgeInsets.symmetric(vertical:isSmaller?(verticalPadding??12): 8,horizontal: 12),
//             hintText: hintText??"Enter $title",
//             hintStyle: TextStyles.bodyMedium.copyWith(
//               color: AppThemeNotifier.textDisabled,
//             ),
//             fillColor: fillColor ??AppThemeNotifier.background,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.border,width: 1),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.border,width: 1),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: AppThemeNotifier.primary, width: 1),
//             ),
//           ),
//           readOnly: readOnly,
//           style: TextStyles.bodyMedium.copyWith(
//             color: AppThemeNotifier.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
//
