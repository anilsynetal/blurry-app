import 'dart:ui' as ui;
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/view/home/model/lounges_response_model.dart';
import 'package:blurry/presentation/view/home/response/respond_privately_screen.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/services/binding.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/guest_user_dialog.dart';
import '../lounge/lounge_selection_screen.dart';
import '../profile/notification/notification_screen.dart';
import '../your_match/controller/your_match_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  final Callback onTapSetting;
  const HomeScreen({super.key,required this.onTapSetting});

  @override
  Widget build(BuildContext context) {
    // Initialise controller once (GetBuilder will reuse it)
    final HomeController controller = Get.put(HomeController(repository: Get.find()));

    return GetBuilder<HomeController>(
      builder: (ctrl) =>
          Scaffold(
            backgroundColor: AppThemeNotifier.surface,
            appBar: _buildAppBar(controller),
            body: SafeArea(
              child:     RefreshIndicator(
                onRefresh: () async => ctrl.loadProfiles(),
                child: Obx(
                  ()=> SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // ── No lounge selected ────────────────────────
                        if (ctrl.selectedLoungesNull.value)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Get.height * 0.3, left: 40, right: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No Lounges selected… yet 😉",
                                    style: TextStyles.bodyMedium.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Choose a Lounge and we’ll show you compatible members instantly.",
                                    style: TextStyles.bodyMedium.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  gradientButton(
                                    buttonText: "Select Lounges",
                                    height: 45,
                                    width: Get.width * 0.5,
                                    onPressed: () => Get.to(
                                          () => LoungeSelectionScreen(),
                                      binding: LoungeBinding(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        // ── Lounge selected ─────────────────────────────
                        else
                          ...[
                            _buildPunchlineSection(ctrl),
                            const SizedBox(height: 5),

                            // Loading shimmer
                            if (ctrl.isLoading.value)
                              ...List.generate(
                                  3, (_) => buildShimmerLoadingMember())
                            else if (ctrl.memberData.isEmpty)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: Get.height * 0.2),
                                  child: Column(
                                    children: [
                                      Lottie.asset("assets/json/empty_heart.json",height: 100),
                                      Text(
                                        'No members yet',
                                        style: TextStyles.bodyMedium.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Check back later or try another lounge!',
                                        style: TextStyles.bodyMedium.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            else
                              ...ctrl.memberData
                                  .asMap()
                                  .entries
                                  .map((e) => _buildProfileCard(e.value, context))
                                  .toList(),
                          ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )



    );

  }

  // ──────────────────────────────────────────────────────────────
  // AppBar (unchanged – just pass controller)
  // ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(HomeController controller) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppThemeNotifier.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => Text(
            controller.currentLounge.value,
            style: TextStyles.headlineMedium.copyWith(
              color: AppThemeNotifier.textPrimary,
            ),
          )),
          Obx(() => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.isOnline.value
                  ? const Color(0xFF0EB03F)
                  : AppThemeNotifier.textSecondary,
            ),
          )),
          const Spacer(),
          // Notification icon
          InkWell(
            onTap: () => Get.to(() => NotificationScreen(),
                binding: NotificationBinding()),
            child: GetBuilder<HomeController>(
              builder: (ctrl) => Obx(
                ()=> Stack(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(top: 3.0, right: 3),
                      child: Image.asset(
                        "assets/icons/notification_ic.png",
                        height: 34,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ctrl.unreadCountNotification.value == "0"
                          ? const SizedBox()
                          : CircleAvatar(
                        radius: 10,
                        backgroundColor: AppThemeNotifier.primary,
                        child: Center(
                          child: ctrl.isLoadNotificationCount.value
                              ?  SizedBox(
                            height: 8,
                            width: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: AppThemeNotifier.onPrimary,
                            ),
                          )
                              : Text(
                            ctrl.unreadCountNotification.value,
                            style: TextStyles.labelMedium.copyWith(
                              color: AppThemeNotifier.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          5.width,
          // Menu
          PopupMenuButton<String>(
            child: Image.asset("assets/icons/menu_ic.png", height: 22),
            onSelected: (value) {
              if (value == 'switch') {
                Get.to(() => LoungeSelectionScreen(),
                    binding: LoungeBinding());
              } else if (value == 'settings') {
                onTapSetting();
              }
            },
            color: AppThemeNotifier.background,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            offset: const Offset(-15, 15),
            elevation: 8,
            shadowColor: AppThemeNotifier.border,
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'switch',
                child: Text('Switch Lounge',
                    style: TextStyles.titleMedium.copyWith(
                        color: AppThemeNotifier.textPrimary)),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings',
                    style: TextStyles.titleMedium.copyWith(
                        color: AppThemeNotifier.textPrimary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Punchline banner
  // ──────────────────────────────────────────────────────────────
  Widget _buildPunchlineSection(HomeController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: ctrl.isLoadingBanner.value || ctrl.bannerImageLounge.value.isEmpty
          ? Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 92,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      )
          : Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                  sigmaX: 2.0, sigmaY: 2.0, tileMode: TileMode.mirror),
              child: CachedNetworkImage(
                height: 92,
                width: Get.width,
                imageUrl: ctrl.bannerImageLounge.value,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 92,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 92,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                      AssetImage('assets/images/lounge_background_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icons/stars_2.png", height: 14),
                      5.width,
                      Text(
                        "Your Punchline",
                        style: TextStyles.labelSmall.copyWith(
                            fontSize: 13,
                            color: AppThemeNotifier.onPrimary),
                      ),
                    ],
                  ),
                  4.height,
                  Text(
                    ctrl.userPunchline.value,
                    style: TextStyles.titleLarge
                        .copyWith(color: AppThemeNotifier.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Profile card
  // ──────────────────────────────────────────────────────────────
  Widget _buildProfileCard(MemberData profile, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Blurred background image
            Container(

              height: 265,
              width: Get.width,
              child: ImageFiltered(

                imageFilter: ui.ImageFilter.blur(

                    sigmaX: 9.0, sigmaY: 9.0, tileMode: TileMode.mirror),
                child: CachedNetworkImage(
                  imageUrl: "$imageBaseUrl${profile.user!.avatar}",
                  fit: BoxFit.fitWidth,
                  placeholder: (_, __) => Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/list_card_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/list_card_bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Overlay content
            Container(
              height: 265,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Name + verify
                  Row(
                    children: [
                      Text(
                        profile.user!.name ?? '',
                        style: TextStyles.titleMedium.copyWith(
                            color: AppThemeNotifier.onPrimary, fontSize: 17),
                      ),
                      8.width,
                      Image.asset("assets/icons/verify.png", height: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Vibe description
                  Text(
                    profile.vibeDescription ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppThemeNotifier.onPrimary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Age + City + Button
                  Row(
                    children: [
                      // Age badge
                      if (profile.user?.age != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppThemeNotifier.background,
                          ),
                          child: Row(
                            children: [
                              Image.asset("assets/icons/uil_18-plus.png",
                                  height: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${profile.user?.age}",
                                style: TextStyles.labelMedium.copyWith(
                                    color: AppThemeNotifier.textPrimary,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),

                      // City badge
                      if (profile.user?.cityName != null)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.35),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppThemeNotifier.background,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("assets/icons/distance.png",
                                    height: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    profile.user?.cityName ?? '',
                                    style: TextStyles.labelMedium.copyWith(
                                        color: AppThemeNotifier.textPrimary,
                                        fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const Spacer(),

                      // Action button
                      gradientButton(
                        width: 110,
                        height: 40,
                        onPressed: () {
                          final isGuestUser = GetStorage().read(isGuest) ?? false;
                          if (profile.isRequest ?? false) {
                            showSuccessMessage(
                                "You've already sent a request to this member.");
                          } else if (isGuestUser) {
                            guestUserDialog("access");
                          } else {
                            Get.to(
                                  () => RespondPrivatelyScreen(),
                              binding: RespondPrivatelyBinding(profile: profile),
                            )?.then((value) {
                              if (value == true) {
                                if (Get.isRegistered<YourMatchController>()) {
                                  Get.find<YourMatchController>().getMyMatchesListApi(isRefresh: true);
                                }

                                Get.find<HomeController>().loadProfiles();
                              }
                            });
                          }
                        },
                        buttonText:
                        (profile.isRequest ?? false) ? "Requested" : "Response",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Shimmer placeholder
// ──────────────────────────────────────────────────────────────
Widget buildShimmerLoadingMember() {
  return Column(
    children: List.generate(
      3,
          (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 265,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    ),
  );
}