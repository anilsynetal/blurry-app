import 'dart:developer';

import 'package:blurry/core/services/binding.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/view/lounge/lounge_selection_screen.dart';
import 'package:blurry/presentation/view/your_match/controller/your_match_controller.dart';
import 'package:blurry/presentation/widgets/credit_widget.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/message_dialog.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart' show showErrorMessageDialog, showMessageDialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../bottom_bar/bottom_bar.dart';
import '../model/plan_model.dart';
import '../view/mollie_payment_web_view.dart';

class PricingController extends GetxController {
  final ApiRepository repository;

  PricingController({required this.repository});

  Rx<String> selectedPlan = "".obs;
  RxString publishableKey = "".obs;
  RxList<PricingPlan> plans = <PricingPlan>[].obs;
  RxBool isLoading = true.obs;

  RxBool isLoadingMore = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getPaymentMode();
    fetchPlans();
    await getStripSetting();
    await Stripe.instance.applySettings().catchError((e) {});
  }

  Rx<String> currentPayment = "".obs;

  getPaymentMode() {
    repository.getAvailableGateway().then((value) {
      final data = value["data"];
      data.forEach((key, val) {
        if (val == true) {
          currentPayment.value = key;
        }
      });
      print("Selected Payment Mode: ${currentPayment.value}");
    });
  }

  getStripSetting() async {
    await repository.getStripSetting().then((value) {
      publishableKey.value = value["data"]["publishableKey"].toString();
      Stripe.publishableKey = publishableKey.value;
      Stripe.merchantIdentifier = "IN";
    });

  }

  Future<void> fetchPlans({bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return;

    if (!loadMore) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await repository.getPlanList(
        page: loadMore ? currentPage.value + 1 : 1,
        limit: 10,
      );

      if (response.data != null) {
        if (!loadMore) {
          plans.clear();
        }

        plans.addAll(response.data!);
        currentPage.value = response.pagination!.currentPage ?? 1;
        totalPages.value = response.pagination!.totalPages ?? 1;
        await repository.getMyActivePlan().then((value) {
          if (value["data"] != null) {
            selectedPlan.value = value["data"]["plan"]["_id"].toString();
            activePlanId.value = value["data"]["plan"]["_id"].toString();
          } else {
            if (plans.isNotEmpty && selectedPlan.value.isEmpty) {
              selectedPlan.value = plans.first.id.toString();
            }
          }
        });
      } else {
        showErrorMessageDialog(response.message ?? 'Failed to load plans');
      }
    } catch (e, s) {
      print("Error is $e");
      print("Error is $s");
      showErrorMessageDialog(e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void selectPlan(String planId) {
    selectedPlan.value = planId;
    print("New Selected Plan is ${selectedPlan.value}");
  }

  Rx<bool> securePaymentLoading = false.obs;
  Future<void> continueToPlan() async {
    if (selectedPlan.value.isEmpty) {
      showWarningMessage('Please select a plan');
      return;
    }

    final selected = plans.firstWhere((plan) => plan.id.toString() == selectedPlan.value.toString());
    print("selected plan amt ${selected.price}");

    if (selected.price.toString() == "0") {
      planSubscribeZero(selected.id.toString(), "null", currentPayment.value);
    } else {
      try {
        securePaymentLoading.value = true;

        final paymentIntent = await planSubscribe(selected.id.toString(), "null", currentPayment.value);

        if (currentPayment.value == "stripe") {
          stripePaymentGateway(paymentIntent);
        } else if (currentPayment.value == "mollie") {
          molliePaymentGateway(paymentIntent);
        }
      } catch (e) {
        securePaymentLoading.value = false;
      }
    }
  }

  stripePaymentGateway(var paymentIntent) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent["data"]['clientSecret'],
          merchantDisplayName: appName,
          allowsDelayedPaymentMethods: false,
          setupIntentClientSecret: paymentIntent["data"]['clientSecret'],
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await repository.confirmPayment(paymentIntent["data"]["paymentIntentId"]);

      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().fetchWalletCredit();
      }

      if (Get.isRegistered<YourMatchController>()) {
        Get.find<YourMatchController>().getMyActivePlanApi();
      }

      securePaymentLoading.value = false;

      await showCupertinoDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) {
          return CupertinoMessageCustomDialog(
            topImage: Image.asset(ic_success, height: 40),
            heading: 'Success',
            title: 'Payment completed successfully!',
            leftButtonText: 'Ok',
            onLeftButtonTap: () {
              Navigator.pop(context);
            },
            rightButtonText: '',
            onRightButtonTap: () {
              Get.back();
            },
          );
        },
      );
     await Get.to(() => LoungeSelectionScreen(), binding: LoungeBinding());
      Get.offAll(()=>BottomNavBar());
    } catch (e, s) {
      if (e is StripeException) {
        final msg = e.error.localizedMessage ?? "Payment failed. Please try again.";
        await showCupertinoDialog(
          context: Get.overlayContext!,
          builder: (BuildContext context) {
            return CupertinoMessageCustomDialog(
              heading: 'Cancelled',
              title: msg,
              leftButtonText: 'Ok',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButtonText: '',
              onRightButtonTap: () {
                Get.back();
              },
            );
          },
        );
      } else {
        await showCupertinoDialog(
          context: Get.overlayContext!,
          builder: (BuildContext context) {
            return CupertinoMessageCustomDialog(
              heading: 'Cancelled',
              title: "Payment failed $e",
              leftButtonText: 'Ok',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButtonText: '',
              onRightButtonTap: () {
                Get.back();
              },
            );
          },
        );
      }
      securePaymentLoading.value = false;
    }
  }

  molliePaymentGateway(var paymentIntent) async {
    try {
      print("clientSecret for mollie  ${paymentIntent["data"]['checkoutUrl']}");
      bool isSuccess = await _openPaymentWebView(paymentIntent["data"]['checkoutUrl']);
       print("final status is $isSuccess");
      if (isSuccess) {

        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().fetchWalletCredit();
        }

        if (Get.isRegistered<YourMatchController>()) {
          Get.find<YourMatchController>().getMyActivePlanApi();
        }

        await Get.to(() => LoungeSelectionScreen(), binding: LoungeBinding());
        Get.offAll(()=>BottomNavBar());
        securePaymentLoading.value = false;

      } else {
        securePaymentLoading.value = false;
      }
    } catch (e, s) {
      print("error is $e");
      print("error is $s");
      securePaymentLoading.value = false;
    }
  }

  RxBool isLoadingPayment = false.obs;
  Future<Map<String, dynamic>> planSubscribe(String planID, String methodID, String activePayment) async {
    isLoadingPayment.value = true;

    try {
      final response = await repository.createPaymentIntent(planID, activePayment);
      return response;
    } finally {
      isLoadingPayment.value = false;
    }
  }

  planSubscribeZero(String planID,String methodID,String activePayment) async{
    isLoadingPayment.value =true;
    try{
      await repository.createPaymentIntent(planID,activePayment).then((value) async {
        print("createPaymentIntent response is $value" );
        showMessageDialog(value["message"], "Success");
       await Get.to(() => LoungeSelectionScreen(), binding: LoungeBinding());
        Get.offAll(()=>BottomNavBar());
      },);


    }finally{
      isLoadingPayment.value =false;
    }

  }

  RxString activePlanId = "".obs;

  Future<bool> _openPaymentWebView(String paymentUrl) async {
    final result = await Get.to(() => PaymentWebViewScreen(paymentUrl: paymentUrl, title: "Payment",),);
   print("return status is $result");
    return bool.parse("${result??false}");
  }

  void inviteFriends() {
    showWarningMessage('Share your referral code');
  }
}