
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';

import '../../../../core/utils/export.dart';
import '../controllers/chat_controller.dart';

class ReportUserDialog extends StatefulWidget {
  final String userName;

  const ReportUserDialog({
    super.key,
    required this.userName,

  });


  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {

  final TextEditingController _otherReasonController = TextEditingController();



  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
   final controller  = Get.find<ChatController>();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppThemeNotifier.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        ()=> SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Info Icon
               Image.asset("assets/icons/alert_ic.png",height: 36,),
                SizedBox(height: 10),

                // Title
                Text(
                  'Report ${widget.userName}',
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),

                // Description
                Text(
                  'We care about your safety. Can you tell us why you\'re reporting this user?',
                  style: TextStyles.labelSmall.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14),

                // Report Reasons
                Column(
                  children: controller.reportReasonList.map((reason) {
                    return Obx(
                      ()=> Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {

                              controller.selectedReason.value = reason;
                                 setState(() {

                                 });
                          },
                          child: Row(
                            children: [
                              // Radio Button
                              Container(
                                width: 20,
                                height: 20,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(


                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: controller.selectedReason.value.value == reason.value
                                        ? AppThemeNotifier.primarySet1
                                        : AppThemeNotifier.textDisabled.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                  // color: _selectedReason == reason
                                  //     ? AppThemeNotifier.primarySet1
                                  //     : Colors.transparent,
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 6.5,
                                    backgroundColor: controller.selectedReason.value.value == reason.value? AppThemeNotifier.primarySet1:AppThemeNotifier.background,
                                  )
                                  ,
                                ),

                              ),
                              SizedBox(width: 12),

                              // Reason Text
                              Expanded(
                                child: Text(
                                  reason.label.toString(),
                                  style: TextStyles.labelSmall.copyWith(
                                    color: AppThemeNotifier.textPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Text Field for "Other" reason
                if (controller.selectedReason.value.label == 'Other')
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: TextField(
                      controller: _otherReasonController,
                      style: TextStyles.labelSmall.copyWith(
                        color: AppThemeNotifier.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Please explain...',
                        hintStyle: TextStyles.labelSmall.copyWith(
                          color: AppThemeNotifier.textDisabled,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppThemeNotifier.border,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppThemeNotifier.border,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppThemeNotifier.primarySet2,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Divider
                Divider(
                  color: AppThemeNotifier.border,
                  height: 1,
                  thickness: 1,
                ),
                SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyles.titleMedium.copyWith(
                            color: Color(0xFF2194FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1,
                      height: 24,
                      color: AppThemeNotifier.border,
                    ),

                    // Submit Button
                    Expanded(
                      child: Obx(
                        ()=> GestureDetector(
                          onTap: () async {
                            if (controller.selectedReason.value.label == "") {
                              showWarningMessage(
                                'Please select a reason',
                              );
                              return;
                            }

                            // Handle report submission
                            String reportReason = controller.selectedReason.value.value!;
                            // if (controller.selectedReason.value.value == 'other' && _otherReasonController.text.isNotEmpty) {
                            //   reportReason = _otherReasonController.text;
                            // }

                            print('Report submitted: $reportReason for ${widget.userName}');
                          await   controller.reportUser(reportReason,
                              controller.selectedReason.value.value  == 'other'?_otherReasonController.text.toString():"$reportReason"
                              );
                            Navigator.pop(context);
                          },
                          child: Text(
                           controller.isLoadReport.value ?
                               "Loading...": 'Submit Report',
                            style: TextStyles.titleMedium.copyWith(
                              color: Color(0xFF2194FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
