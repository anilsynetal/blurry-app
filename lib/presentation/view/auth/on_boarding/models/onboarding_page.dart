import '../../../../../core/utils/images.dart';

class OnboardingPage {
  final String title;
  final String subtitle;
  final String imageAsset;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });
}

class OnboardingContent {
  static  List<OnboardingPage> pages = [
    OnboardingPage(
      title: "Welcome Back!",
      subtitle: "“Find a soul, not a face”",
      imageAsset: "assets/icons/get_started_slider1.png",
    ),
    OnboardingPage(
      title: "Welcome Back!",
      subtitle: "“Find a soul, not a face”",
      imageAsset: "assets/icons/get_started_slider2.png",
    ),
    OnboardingPage(
      title: "Welcome Back!",
      subtitle: "“Find a soul, not a face”",
      imageAsset: "assets/icons/get_started_slider1.png",
    ),
  ];
}
