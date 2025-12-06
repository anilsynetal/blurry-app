// widgets/referral_card_widget.dart
import 'dart:io';

import 'package:blurry/core/utils/string.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/invite_controller.dart';

class ReferralCardWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const ReferralCardWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InviteController controller = Get.find();

    return Obx(() {
      // -----------------------------------------------------------------
      // 1. Full-widget loading (API call)
      // -----------------------------------------------------------------
      if (controller.isLoading.value || controller.inviteData.value == null) {
        return const ShimmerReferralCard();
      }

      final config = controller.inviteData.value!.invitationConfig;
      if (config == null || !(config.isEnabled ?? false)) {
        return const SizedBox.shrink(); // Hide if disabled
      }

      // -----------------------------------------------------------------
      // 2. Build the card with CachedNetworkImage
      // -----------------------------------------------------------------
      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: () async {
           String shareCode = controller.inviteData.value!.inviteCode.toString();


           // ANDROID package name
           String androidPackage = "com.app.blurify";

           // iOS App Store ID (replace with your real ID)
           const String iosAppId = "com.app.blurify"; // <--- your real iOS ID

           // Generate platform-specific app links
           final String appLink = Platform.isAndroid
               ? "https://play.google.com/store/apps/details?id=$androidPackage"
               : "https://apps.apple.com/app/id$iosAppId";

           // Your message
           final String message = """
🎉 Get Free Unblur Credits on $appName App!

Use my referral code **$shareCode** while signing up and both of us will receive free Unblur credits instantly.

Unlock profiles, view unblurred photos, and enjoy premium features for free!

👇 Download $appName App:
$appLink
""";


           await Share.share(
             message,
             subject: "Join $appName App & Get Free Unblur Credits!",
           );
          },
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 100,
            width: double.infinity,
            child: Stack(
              children: [
                // Background Image with Dark Overlay
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: _fullBannerUrl(config.bannerImage),
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _shimmerPlaceholder(),
                    errorWidget: (_, __, ___) => Image.asset(
                      'assets/images/invite_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Dark gradient overlay (left to right fade)
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xCC000000), // ~80% black
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.7],
                    ),
                  ),
                ),

                // Text Content (Left-Aligned, Multi-line)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 80, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        config.title ?? "Invite friends & get 3 free",
                        style: GoogleFonts.schibstedGrotesk(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        "Both you and your friend will benefit.",
                        style: GoogleFonts.schibstedGrotesk(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Invite Now Button (Exact position & style)
                Positioned(
                  right: 5,
                  bottom: 20,
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: [
                        Color(0x80111B2C),
                        Color(0x80111B2C),
                        Color(0x80111B2C),

                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerLeft,
                      )
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                        child: Text(
                          "Invite Now",
                          style: GoogleFonts.schibstedGrotesk(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )



                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // -----------------------------------------------------------------
  // Helper: build shimmer placeholder for the network image
  // -----------------------------------------------------------------
  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // Helper: compose full URL (same logic you had before)
  // -----------------------------------------------------------------
  String _fullBannerUrl(String? bannerImage) {
    if (bannerImage == null || bannerImage.isEmpty) {
      // Return a dummy URL – errorWidget will show the asset
      return '';
    }
    return '$imageBaseUrl/$bannerImage';
  }
}

// ---------------------------------------------------------------------
// Existing shimmer card (unchanged)
// ---------------------------------------------------------------------
class ShimmerReferralCard extends StatelessWidget {
  const ShimmerReferralCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}