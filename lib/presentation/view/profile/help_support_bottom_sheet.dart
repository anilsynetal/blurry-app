import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/view/plan/model/plan_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';

import '../../../data/repository/api_repository.dart';
import '../../widgets/message_dialog.dart';

class HelpSupportBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppThemeNotifier.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppThemeNotifier.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Help & Support',
                    style: TextStyles.headlineMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppThemeNotifier.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppThemeNotifier.border, height: 0),
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get in Touch',
                        style: TextStyles.titleMedium.copyWith(
                          color: AppThemeNotifier.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Email Support
                      _buildContactOption(
                        icon: 'assets/icons/help_support.png',
                        title: 'Email Support',
                        subtitle: '${GetStorage().read(supportMailKey)}',
                        onTap: () async {
                          final email = GetStorage().read(supportMailKey) ?? 'support@yourapp.com';
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: email,
                            queryParameters: {
                              'subject': '$appName App Support',
                            },
                          );

                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                          } else {
                            await showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoMessageCustomDialog(

                                  heading:  'Warning',
                                  title:   'Could not open email client',
                                  leftButtonText: 'Ok',
                                  onLeftButtonTap: () {

                                    Navigator.pop(context);
                                    // TODO: Add API call to send proposal with selectedOption.value
                                  },
                                  rightButtonText: '',
                                  onRightButtonTap: () {
                                    Get.back();
                                  },
                                );
                              },
                            );
                          }
                        },

                      ),

                      SizedBox(height: 8),

                      // FAQ
                      _buildContactOption(
                        icon: 'assets/icons/setting.png',
                        title: 'FAQ',
                        subtitle: 'Common questions answered',
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(() => FAQScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContactOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemeNotifier.border, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF0F0F0),
              child: Image.asset(icon, height: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyles.labelSmall.copyWith(
                      color: AppThemeNotifier.textDisabled.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppThemeNotifier.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}


class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FaqController ctrl = Get.put(FaqController());

    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        title: Text(
          'FAQs',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios_new_rounded,
              color: AppThemeNotifier.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.faqs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.errorMsg.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ctrl.errorMsg.value),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: (){
                    ctrl.fetchFaqs();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!ctrl.isLoading.value && ctrl.faqs.isEmpty) {
          return Center(
            child: Text(
              'No FAQs found',
              style: TextStyles.bodyMedium.copyWith(
                color: AppThemeNotifier.textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async{
            ctrl.fetchFaqs();
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.faqs.length ,
            separatorBuilder: (_, __) => Divider(color: AppThemeNotifier.border),
            itemBuilder: (context, index) {


              final faq = ctrl.faqs[index];
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  faq.question,
                  style: TextStyles.titleMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                  ),
                ),

                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      faq.answer,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppThemeNotifier.textSecondary,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}



class FaqController extends GetxController {
  final ApiRepository _repo = Get.find<ApiRepository>();

  // UI state
  final RxList<FaqModel> faqs = <FaqModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMsg = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchFaqs(); // first page
  }

  Future<void> fetchFaqs() async {
    isLoading(true);
    try {
      final raw = await _repo.getFaqsList();
      final response = FaqListResponse.fromJson(raw);

      if (response.status == 'error') {
        errorMsg(response.message ?? 'Something went wrong');
        return;
      }

      faqs.assignAll(response.data);


    } catch (e) {
      errorMsg('Failed to load FAQs');
    } finally {
      isLoading(false);
    }
  }


}


class FaqModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FaqModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] ?? '',
        question = json['question'] ?? '',
        answer = json['answer'] ?? '',
        category = json['category'] ?? '',
        isActive = json['isActive'] ?? false,
        createdAt = DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt = DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now();
}

class FaqListResponse {
  final List<FaqModel> data;
  final Pagination pagination;
  final String? status;
  final String? message;

  FaqListResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List<dynamic>?)
      ?.map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
      .toList() ??
      [],
        pagination = Pagination.fromJson(json['pagination'] ?? {}),
        status = json['status']?.toString(),
        message = json['message']?.toString();
}