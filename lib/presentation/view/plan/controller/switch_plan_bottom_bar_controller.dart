import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:blurry/presentation/view/profile/controller/profile_controller.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart' show showErrorMessageDialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../../../../core/services/binding.dart';
import '../../../../core/utils/export.dart';
import '../../../../core/utils/string.dart';
import '../../../../data/repository/api_repository.dart';
import '../../../widgets/credit_widget.dart';
import '../../../widgets/getx_message_toast.dart';
import '../../../widgets/message_dialog.dart';
import '../../../widgets/showErrorDialog.dart' show showErrorMessageDialog, showMessageDialog;
import '../../../widgets/test.dart';
import '../../your_match/controller/your_match_controller.dart';
import '../model/plan_model.dart';
import '../view/mollie_payment_web_view.dart';

class PlanSwitchScreenController extends GetxController {
  final ApiRepository repository;

  PlanSwitchScreenController({required this.repository});

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
    await Stripe.instance.applySettings().catchError((e) {

    });

  }

  Rx<String> currentPayment = "".obs;

  getPaymentMode() {
    repository.getAvailableGateway().then((value) {
      final data = value["data"]; // { "stripe": false, "mollie": true }
      // Find the first key with value == true
      data.forEach((key, val) {
        if (val == true) {
          currentPayment.value = key; // store "mollie"
        }
      });
      print("Selected Payment Mode: ${currentPayment.value}");
    });
  }


  getStripSetting() async {
    await repository.getStripSetting().then((value) {
      publishableKey.value = value["data"]["publishableKey"].toString();
      Stripe.publishableKey = publishableKey.value; // Replace with your test publishable key
      Stripe.merchantIdentifier = "IN";
    },);
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
        if(Platform.isIOS && GetStorage().read(isPlanEnable) == false){
          plans.value =  [response.data!.firstWhere((element) => element.price.toString() == "0")];
        }else{
          plans.addAll(response.data!);
        }

        currentPage.value = response.pagination!.currentPage ?? 1;
        totalPages.value = response.pagination!.totalPages ?? 1;
        await repository.getMyActivePlan().then((value) {
          if(value["data"]["plan"].toString() != "null"){
            selectedPlan.value = value["data"]["plan"]["name"].toString();
            activePlanId.value = value["data"]["plan"]["_id"].toString();
          }else{
            if (plans.isNotEmpty && selectedPlan.value.isEmpty) {
              selectedPlan.value = plans.first.name.toString();
            }
          }
        },);

      } else {
        showErrorMessageDialog(response.message ?? 'Failed to load plans');
      }
    } catch (e,s) {
      print("Eror is $e");
      print("Eror is $s");
      // showErrorMessageDialog(e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void selectPlan(String planName) {
    selectedPlan.value = planName;
    print("New Selected Plan is ${ selectedPlan.value}");
  }

  Rx<bool> securePaymentLoading = false.obs;
  Future<void> continueToPlan() async {
    if (selectedPlan.value.isEmpty) {
      showWarningMessage('Please select a plan');
      return;
    }

    // Find the selected plan
    final selected = plans.firstWhere((plan) => plan.name.toString() == selectedPlan.value.toString());
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
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().getMyActivePlanApi();
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
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().getMyActivePlanApi();
        }
        showSuccessMessage('Payment completed successfully!');
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
        showSuccessMessage(value["message"]);

        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().fetchWalletCredit();
        }

        if (Get.isRegistered<YourMatchController>()) {
          Get.find<YourMatchController>().getMyActivePlanApi();
        }

        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().getMyActivePlanApi();
        }

      },);


    }finally{
      isLoadingPayment.value =false;
    }

  }




  RxString activePlanId = "".obs;


  Future<bool> _openPaymentWebView(String paymentUrl) async {
    final result = await Get.to<bool>(
          () => PaymentWebViewScreen(
        paymentUrl: paymentUrl,
        title: "Payment",
      ),
    );

    return result ?? false;
  }





}