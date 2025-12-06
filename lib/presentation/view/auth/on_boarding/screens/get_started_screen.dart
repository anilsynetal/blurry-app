import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/export.dart';
import '../../../../../core/utils/images.dart';
import '../../../../../core/utils/string.dart';
import '../../../../widgets/common_button.dart';
import '../models/onboarding_page.dart';
import '../controllers/get_started_controller.dart';
import '../widgets/page_indicator.dart';

class GetStartedScreen extends StatefulWidget {
  String? message;
   GetStartedScreen({Key? key, this.message}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  // but this screen now drives UI with CarouselController.
  final PageController _pageController = PageController();
  final CarouselController _carouselController = CarouselController();
  final GetStartedOnBoardController controller = Get.put(GetStartedOnBoardController());

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingContent.pages;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: OnboardingContent.pages.length,
          itemBuilder: (context, index, realIndex) {
            return AnimatedBannerImage(
              imageUrl: pages[index].imageAsset,
              index: index,
            );
          },
          options: CarouselOptions(
            height: Get.height * 0.4, // Adjust based on your design
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 550),
            autoPlayCurve: Curves.easeOut,
            scrollDirection: Axis.horizontal,
            padEnds: true,
            onPageChanged: (index, reason) {
              controller.setCurrentPage(index);
            },
          ),
        ),
        // Dot Indicator
        Positioned(
            top: 0,
            child: Column(children: [
              60.height,
              GradientText(
                appName,
                gradient:  LinearGradient(
                  colors: <Color>[
                    AppThemeNotifier.primarySet1,
                    AppThemeNotifier.primarySet2,
                    AppThemeNotifier.primarySet3,
                  ], // Top to bottom gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                style:  TextStyle(
                  fontSize: 26.0,
                  fontFamily: GoogleFonts.schibstedGrotesk().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Image.asset(
              //   app_name,
              //   height: 26,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  widget.message ?? pages[controller.currentPage].title,
                  textAlign: TextAlign.center,
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppThemeNotifier.onPrimary,
                    fontSize: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  pages[controller.currentPage].subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleSmall.copyWith(
                    color: AppThemeNotifier.onPrimary,
                    fontSize: 17,
                  ),
                ),
              ),
            ],)),
        Positioned(
          bottom: 16,
          child: Obx(
                () => PageIndicator(
              current: controller.currentPage,
              count: controller.totalPages,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for animated banner image
class AnimatedBannerImage extends StatefulWidget {
  final String imageUrl;
  final int index;

  const AnimatedBannerImage({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  @override
  _AnimatedBannerImageState createState() => _AnimatedBannerImageState();
}

class _AnimatedBannerImageState extends State<AnimatedBannerImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 10 / 200),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SizedBox.expand(
          child: Image.asset(
            widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
