import 'package:blurry/presentation/view/profile/notification/notification_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/export.dart';

import '../../../widgets/common_button.dart' show gradientButton;
import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
   NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Center(child: Image.asset(back_ic, height: 24)),
            )),
        centerTitle: false,
        title: Text(
          "Notification",
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
        actions: [
          Obx(() {
            final count = controller.unreadCount.value;
            return count > 0
                ? Padding(
              padding:  EdgeInsets.only(right: 16.0),
              child: gradientButton(
                onPressed: () {},
                height: 30,
                width: 65,
                child: Center(
                  child: Text(
                    '$count New',
                    style: TextStyles.labelSmall.copyWith(
                      color: AppThemeNotifier.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
                :  SizedBox.shrink();
          }),

        ],
      ),



      body: Obx(() {
        // ---------- Loading ----------
        if (controller.isLoading.value && controller.items.isEmpty) {
          return  Center(child: CircularProgressIndicator());
        }

        // ---------- Error ----------
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: TextStyles.bodyMedium
                      .copyWith(color: AppThemeNotifier.textDisabled),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.onRefresh,
                  child:  Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ---------- Empty ----------
        if (controller.items.isEmpty) {
          return Center(
            child: Text(
              'No notifications',
              style: TextStyles.bodyMedium
                  .copyWith(color: AppThemeNotifier.textDisabled),
            ),
          );
        }

        // ---------- List ----------
        return RefreshIndicator(
          onRefresh: () async{
            controller.onRefresh();
          },
          child: ListView.builder(
            controller: controller.scrollController,
            padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.groupedNotifications.keys.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom
              if (index == controller.groupedNotifications.keys.length) {
                return  Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final dateLabel =
              controller.groupedNotifications.keys.elementAt(index);
              final dayList = controller.groupedNotifications[dateLabel]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: 10),
                  Text(
                    dateLabel,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                    ),
                  ),
                   SizedBox(height: 10),
                  ...dayList.map(_buildTile).toList(),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  // -----------------------------------------------------------------
  //  Single notification tile – **exact same look**
  // -----------------------------------------------------------------
  Widget _buildTile(NotificationDetails n) {
    final bool isNew = n.isRead == false;
    // final bool isNew = false;

    return Padding(
      padding:  EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding:  EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isNew
              ? AppThemeNotifier.surfaceContainer.withOpacity(0.3)
              : null,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppThemeNotifier.border, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            CircleAvatar(
              backgroundColor: Color(0xFFF0F0F0),
              child: Center(
                child: Image.asset("assets/icons/notification_ic.png",height: 23,color: AppThemeNotifier.textPrimary,),

              ),
            ),
             SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title ?? '',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   SizedBox(height: 4),
                  Text(
                    n.message ?? '',
                    style: TextStyles.bodySmall.copyWith(
                      color: AppThemeNotifier.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  if (n.data?.matchedUserName != null) ...[
                     SizedBox(height: 4),
                    Text(
                      'From ${n.data!.matchedUserName}',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppThemeNotifier.textDisabled.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
             SizedBox(width: 8),

            // Time + read indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimeAgo(n.createdAt!),
                  style: TextStyles.labelSmall.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontSize: 11,
                  ),
                ),
                if (isNew) ...[
                   SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration:  BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}