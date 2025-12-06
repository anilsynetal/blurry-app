import '/core/utils/export.dart';

Widget commonTextField({
  required TextEditingController controller,
  String? hintText,
  String? labelText,
  String? helperText,
  bool isPassword = false,
  bool isReadOnly = false,
  bool isDense = true,
  bool isEnabled = true,
  int? maxLines = 1,
  int? minLines,
  int? maxLength,
  TextInputType keyboardType = TextInputType.text,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextInputAction textInputAction = TextInputAction.done,
  List<TextInputFormatter>? inputFormatters,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  void Function()? onTap,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  TextStyle? hintStyle,
  TextStyle? labelStyle,
  TextStyle? textStyle,
  Color? fillColor,
  bool filled = true,
  InputBorder? border,
  double?borderRadius
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    readOnly: isReadOnly,
    enabled: isEnabled,
    maxLines: maxLines,
    minLines: minLines,
    maxLength: maxLength,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onTap: onTap,


    style: textStyle ?? TextStyles.bodyMedium.copyWith(color: AppThemeNotifier.textPrimary),
    validator: validator,

    decoration: InputDecoration(
      isDense: isDense,
      contentPadding: contentPadding,
      labelText: labelText,
      labelStyle: labelStyle,
      counterText:   '',



      hintText: hintText,
      hintStyle: hintStyle ??TextStyles.bodySmall.copyWith(color: AppThemeNotifier.textDisabled,fontSize: 13),
      helperText: helperText,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints(maxWidth: 40),
      suffixIcon: suffixIcon,
      filled: filled,

      fillColor: fillColor ?? Colors.grey.shade100,
      border: border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius??10),
            borderSide: BorderSide(color:AppThemeNotifier.border,width: 1),
          ),
      enabledBorder: border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius??10),
            borderSide: BorderSide(color: AppThemeNotifier.border,width: 1),
          ),
      focusedBorder: border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius??10),
            borderSide: BorderSide(color: AppThemeNotifier.border,width: 1),
          ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius??10),
        borderSide: BorderSide(color:AppThemeNotifier.error),
      ),
    ),
  );
}
