import '/core/utils/export.dart';
import 'package:intl/intl.dart';

class CommonDatePickerTextField extends StatelessWidget {
  final String title;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final DateTime? startDate;
  final DateTime? endDate;

  const CommonDatePickerTextField({
    super.key,
    required this.title,
    this.hintText,
    required this.controller,
    this.validator,
    this.startDate,
    this.endDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    // Fallback dates if not provided
    final DateTime minDate = startDate ?? DateTime(1900);
    final DateTime maxDate = endDate ?? DateTime(2100);

    // Determine the initial date
    DateTime initialDate;
    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(controller.text);
      } catch (_) {
        // If parsing fails, default to minDate
        initialDate = minDate;
      }
    } else {
      initialDate = DateTime.now();
    }

    // Ensure initialDate is within allowed range
    if (initialDate.isBefore(minDate)) {
      initialDate = minDate;
    }
    if (initialDate.isAfter(maxDate)) {
      initialDate = maxDate;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (pickedDate != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextFormField(
          controller: controller,
          readOnly: true,
          validator: validator,
          onTap: () => _selectDate(context),
          style:  TextStyles.bodyMedium.copyWith(color: AppThemeNotifier.textPrimary),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            hintText: hintText ?? "Enter $title",
            hintStyle: TextStyles.bodySmall.copyWith(color: AppThemeNotifier.textDisabled,fontSize: 13),
            fillColor: AppThemeNotifier.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color:Color(0xFF969AA4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color:Color(0xFF969AA4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppThemeNotifier.primary, width: 1),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Image.asset(
                  ic_calender,

                  height: 18,
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 22,
              minHeight: 22,
            ),
          ),

        ),
      ],
    );
  }
}
