// import 'dart:async';
// import 'package:in_app_purchase/in_app_purchase.dart';
//
// class IapService {
//
//   final InAppPurchase _iap = InAppPurchase.instance;
//
//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//
//   List<ProductDetails> products = [];
//
//   Future<void> init(Set<String> productIds) async {
//
//     final available = await _iap.isAvailable();
//     if (!available) return;
//
//     final response = await _iap.queryProductDetails(productIds);
//
//     products = response.productDetails;
//
//     _subscription = _iap.purchaseStream.listen(_listenPurchase);
//   }
//
//   void _listenPurchase(List<PurchaseDetails> purchases) {
//
//     for (var purchase in purchases) {
//
//       if (purchase.status == PurchaseStatus.purchased) {
//
//         verifyPurchase(purchase);
//
//       }
//
//       if (purchase.pendingCompletePurchase) {
//         _iap.completePurchase(purchase);
//       }
//     }
//   }
//
//   void buy(ProductDetails product) {
//
//     final purchaseParam = PurchaseParam(productDetails: product);
//
//     _iap.buyNonConsumable(purchaseParam: purchaseParam);
//   }
//
//   Future<void> restore() async {
//     await _iap.restorePurchases();
//   }
//
//   void verifyPurchase(PurchaseDetails purchase) {
//
//     final receipt = purchase.verificationData.serverVerificationData;
//
//     // send to backend
//     print("Receipt: $receipt");
//
//   }
// }