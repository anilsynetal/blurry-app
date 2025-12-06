import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/export.dart' hide Notification;
import '../../../../data/repository/api_repository.dart';
import 'notification_list_model.dart' show NotificationDetails;


class NotificationController extends GetxController {
  final ApiRepository _repo = Get.find<ApiRepository>();

  // UI state
  final RxList<NotificationDetails> items = <NotificationDetails>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;

  // Scroll controller for manual load-more
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(refresh: true);
    _setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------
  //  Scroll listener – load next page when near bottom
  // ---------------------------------------------------------
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && _hasMore) {
          fetchNotifications(refresh: false);
        }
      }
    });
  }

  // ---------------------------------------------------------
  //  Public API
  // ---------------------------------------------------------
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      items.clear();
    }

    if (!_hasMore || isLoading.value || isLoadingMore.value) return;

    refresh ? isLoading.value = true : isLoadingMore.value = true;
    errorMessage.value = '';

    final result = await _repo.getNotifications(
      page: _currentPage,
      limit: _limit,
      unreadOnly: false,
    );

    isLoading.value = false;
    isLoadingMore.value = false;

    if (result.status == "error") {
      errorMessage.value = result.message ?? "Unknown error";
      return;
    }

    final newItems = result.data?.notifications ?? [];
    if (refresh) {
      items.assignAll(newItems);
    } else {
      items.addAll(newItems);
    }

    unreadCount.value = result.data?.unreadCount ?? 0;
    _repo.markAsRead();
    _hasMore = ((result.data?.pagination!.totalRecords??0) > items.length ?? false);
    _currentPage++;
  }

  // ---------------------------------------------------------
  //  Pull-to-refresh (called from UI button)
  // ---------------------------------------------------------
  void onRefresh() => fetchNotifications(refresh: true);

  // ---------------------------------------------------------
  //  Date helpers
  // ---------------------------------------------------------
  String relativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Map<String, List<NotificationDetails>> get groupedNotifications {
    final map = <String, List<NotificationDetails>>{};
    for (final n in items) {
      final label = relativeDateLabel(n.createdAt!);
      map.putIfAbsent(label, () => []).add(n);
    }
    return map;
  }
}