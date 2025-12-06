
import 'package:flutter_stripe/flutter_stripe.dart';

import 'export.dart';

  const String baseUrl = "https://api.soulfirst.io/api/";
  const String imageBaseUrl = "https://api.soulfirst.io/";
  // String publishableKey = 'pk_test_51xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'; // Replace with your Stripe test publishable key

  const String appName = "SoulFirst";
  const String tokenKey = "token";
  const String isLoginKey = "isLogin";
  const String isGuest = "isGuest";
  const String signUpStage = "signUpStage";
  const String isRunningSignUp = "isRunningSignUp";
  const String userId = "userId";
  const String userNameKey = "name";
  const String emailKey = "email";
  const String userDataKey = "userData";
  const String savedImage = "savedImage";
  const String savedBio = "savedBio";
  // const String yourSaveLoungeKey = "yourSaveLounge";
  const String supportMailKey = "supportMail";
  const String timezoneKey = "timezone";
  const String blurPercentageKey = "blurPercentage";
  const String blurPercentageAfterKey = "blurPercentageAfter";


enum AccessRequestStatus {
  pending('pending'),
  approved('approved'),
  denied('denied'),
  matched('matched'),   // When both users like each other
  expired('expired');   // For expired requests
  final String value;
  const AccessRequestStatus(this.value);
}


class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        required this.gradient,
        this.style,
        super.key, // Added super.key for the constructor
      });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
