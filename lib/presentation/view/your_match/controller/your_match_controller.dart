// UPDATED YOUR MATCH CONTROLLER - with API integration & pagination
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/view/your_match/model/my_matches_list_model.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/services/match_list_socket.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/utils/export.dart';
import '../../../../core/utils/string.dart';
import '../../plan/model/plan_model.dart';

class YourMatchController extends GetxController {
  final ApiRepository repository;
  final MatchListSocket socketService;
  YourMatchController({required this.repository,required this.socketService});

  // <CHANGE> API data state variables
  final RxList<MatchData> matchesList = <MatchData>[].obs;


  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;

  final RxInt currentPage = 1.obs;
  final RxInt pageLimit = 20.obs;

  final ScrollController scrollController = ScrollController();



  @override
  void onInit() {
    super.onInit();
    getMyActivePlanApi();
    getMyMatchesListApi(isRefresh: true);
    _setupScrollListener();
    // socketService.initializeSocket();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    if (socketService.socket == null) {
      print("⚠️ Socket is null in YourMatchController");
      return;
    }

    // Remove existing listeners to avoid duplicates
    // socketService.socket?.off('match_request_received');
    // socketService.socket?.off('match_request_accepted');

    socketService.socket?.on('match_request_received', (data) {
      print("New match_request_received receive data is $data");
      try {
        MatchData newData = MatchData.fromJson(data["data"]["match"]);
        matchesList.insert(0, newData);
        matchesList.refresh();
      } catch (e) {
        print("Error parsing match_request_received data: $e");
      }
    });

    socketService.socket?.on('match_request_accepted', (data) {
      print("New match_request_accepted data is $data");
      try {
        if(data["data"]["match"]["requestee"]["_id"].toString() != "${GetStorage().read(userDataKey)["_id"].toString()}" ){
          print("New match_request_accepted data is $data");
          final updatedMatch = MatchData.fromJson(data["data"]["match"]);
          final index = matchesList.indexWhere(
                (element) => element.matchId.toString() == data["data"]["match"]["matchId"].toString(),
          );
          if (index != -1) {
            matchesList[index] = updatedMatch;
          } else {
            matchesList.insert(0, updatedMatch);

          }
          matchesList.refresh();
        }
      } catch (e) {
        print("Error parsing match_request_accepted data: $e");
      }
    });
  }

  // <CHANGE> Setup scroll listener for pagination
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        if (hasMoreData.value && !isLoadingMore.value) {
          loadMoreMatches();
        }
      }
    });
  }

  // <CHANGE> Get matches list from API with pagination
  Future<void> getMyMatchesListApi({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage.value = 1;
        matchesList.clear();

      } else {
        isLoadingMore.value = true;
      }

      final response = await repository.getMyMatchesList(
        page: currentPage.value,
        limit: pageLimit.value,
        lId: '', // empty string as per API requirement
      );

      if (response.data != null && response.data!.matches != null) {
        final newMatches = response.data!.matches!;

        // Separate matches by status
        matchesList.addAll(newMatches.where((element) => element.status.toString() != AccessRequestStatus.denied.value && element.status.toString() != AccessRequestStatus.expired.value,));
        // matchesList.addAll(newMatches);

        // Check if more data available
        if (response.data!.pagination != null) {
          final hasMore = response.data!.pagination!.hasMore;
          hasMoreData.value = hasMore;
        }

        if (newMatches.length < pageLimit.value) {
          hasMoreData.value = false;
        }

        currentPage.value++;
      } else {
        hasMoreData.value = false;
      }
    } catch (e, s) {
      print("[v0] Error fetching matches: $e");
      print("[v0] Stack: $s");

    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // <CHANGE> Load more matches for pagination
  void loadMoreMatches() {
    if (hasMoreData.value && !isLoadingMore.value) {
      getMyMatchesListApi(isRefresh: false);
    }
  }

  // <CHANGE> Accept or ignore match action
  Rx<bool> isLoadingUpdate = false.obs;
  Rx<String> loadType = "".obs;
  Rx<int?> loadingIndex = Rx<int?>(null);
  Future<void> respondToMatch(String matchId, String status,int index) async {
    try {
      isLoadingUpdate.value = true;
      loadingIndex.value = index;
      loadType.value = status;
      // action: "accept" or "ignore"

      final response = await repository.updateMatchRequest(matchId, status);
      if (response['status'] == 'success') {
        if(status == AccessRequestStatus.denied.value){
          matchesList.removeAt(index);
        }else{
          var updateMatchData = response["data"]["match"];
          matchesList[index]= matchesList[index].copyWith(message:updateMatchData["message"],isMatched: updateMatchData["isMatched"],matchedAt:updateMatchData["matchedAt"],status: updateMatchData["status"]  );

        }
      } else {
      showErrorMessageDialog(response["message"].toString());
      }
    } catch (e) {

    }finally{
      isLoadingUpdate.value = false;
      loadingIndex.value = null;
      loadType.value = "";
    }
  }

  Rx<PricingPlan> selectedPlan = PricingPlan(id: "").obs;
  RxBool isLoadMyPlan = false.obs;
  Future<void> getMyActivePlanApi() async {
    isLoadMyPlan.value = true;
    try {
      final value = await repository.getMyActivePlan();
      if (value["data"]["plan"].toString() != "null") {
        selectedPlan.value = PricingPlan.fromJson(value["data"]["plan"]);
      } else {
        selectedPlan.value = PricingPlan(id: "");
      }
    } catch (e, s) {
      print("[v] Error fetching plan: $e");
      print("[v0] Stack: $s");
    } finally {
      isLoadMyPlan.value = false;
    }
  }

  @override
  void onClose() {
    // socketService.socket?.off('match_request_received');
    // socketService.socket?.off('match_request_accepted');
    scrollController.dispose();
    super.onClose();
  }
}