
import 'package:blurry/data/repository/api_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../core/utils/export.dart';


class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String title;

  const PaymentWebViewScreen({
    Key? key,
    required this.paymentUrl,
    this.title = "Payment",
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final InAppWebViewController webViewController;
  bool _isLoading = false;
  bool isComeFinalScreen = false;
  String paymentStatus = "";
  Future getStatus(String orderid) async {
    setState(() {
      _isLoading = true;
    });
   await ApiRepository().getOrderStatus(orderid).then((value) {
      print("api response is $value");
      setState(() {
        paymentStatus = value["data"]["status"];
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      setState(() {
        _isLoading = false;
      });
    },);
  }

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
            // User manually pressed back → treat as cancel
            Get.back(result: false);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Center(child: Image.asset(back_ic, height: 24)),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
            initialSettings: InAppWebViewSettings(
                isInspectable: true,
                disableVerticalScroll: false,
                disableHorizontalScroll: false,
                verticalScrollBarEnabled: true,
                horizontalScrollBarEnabled: true,
                supportZoom: false,
                // Disable iOS bounce that conflicts with pull-to-refresh / native scroll

                // Android equivalent
                overScrollMode: OverScrollMode.NEVER,
                useOnLoadResource: true,

            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) async {
              if(url.toString().contains("payment-result?order_id=")){
                String orderId = url.toString().split("order_id=").last;
               await getStatus(orderId);
                setState(() => isComeFinalScreen = true);
              }

            },
            onLoadStop: (controller, url) {
              // setState(() => _isLoading = false);
              print("Loaded: $url");
            },
          ),
          if(isComeFinalScreen)
            Positioned(child: InkWell(
              onTap: (){
                print(paymentStatus);
                print( paymentStatus.toString().toLowerCase().trim() == "paid"||
                    paymentStatus.toString().toLowerCase().trim() == "success"||
                    paymentStatus.toString().toLowerCase().trim() == "complete");
                Get.back(result:
                paymentStatus.toString().toLowerCase().trim() == "paid"||
                paymentStatus.toString().toLowerCase().trim() == "success"||
                paymentStatus.toString().toLowerCase().trim() == "complete"?
                true:false);
              },
              child: Container(
                height: Get.height,
                width: Get.width,
                color: Colors.transparent,

              ),
            )),
          // Simple loading overlay
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}