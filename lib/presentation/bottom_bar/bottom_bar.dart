import 'dart:io';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/view/home/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/services/match_list_socket.dart';
import '../../core/services/socket_service.dart';
import '../../core/utils/export.dart';
import '../../data/api/api_client.dart';
import '../../data/repository/api_repository.dart';
import '../view/home/home_controller.dart';
import '../view/plan/controller/invite_controller.dart';
import '../view/plan/controller/switch_plan_bottom_bar_controller.dart';
import '../view/plan/view/bottom_bar_plan_switch_screen.dart';
import '../view/profile/controller/profile_controller.dart';
import '../view/profile/profile_page.dart';
import '../view/your_match/controller/your_match_controller.dart';
import '../view/your_match/your_match_screen.dart';
import 'curved_navigation_bar_custom.dart';

class BottomNavBar extends StatefulWidget {
  final int? initialIndex;

  const BottomNavBar({super.key,  this.initialIndex});
   @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    // TODO: implement initState
    if(mounted){
      _page = widget.initialIndex??0;
    }
    super.initState();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => MatchListSocket());

    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.put(MatchListSocket(), permanent: true);
    // Get.put(YourMatchController(repository: Get.find(),socketService: Get.find()), permanent: true);
    // Get.put(PlanSwitchScreenController(repository: Get.find()), permanent: true);
    Get.put(InviteController(), permanent: true);
    Get.put(ProfileController(repository: Get.find()), permanent: true);





    bool isPlanDisabled = Platform.isIOS && GetStorage().read(isPlanEnable) == false;

    final List<String> labels = isPlanDisabled
        ? const ['Home', 'Match', 'Profile']
        : const ['Home', 'Match', 'Credit', 'Profile'];

    final List<Widget> items = <Widget>[
      Image.asset("assets/bottom_tab/home_unselected.png", height: 24),
      Image.asset("assets/bottom_tab/match_unselected.png", height: 24),
      if (!isPlanDisabled)
        Image.asset("assets/bottom_tab/credit_unselected.png", height: 24),
      Image.asset("assets/bottom_tab/profile_unselected.png", height: 24),
    ];

    final List<Widget> itemsSelected = <Widget>[
      Image.asset("assets/bottom_tab/home_selected.png", height: 45),
      Image.asset("assets/bottom_tab/match_selected.png", height: 45),
      if (!isPlanDisabled)
        Image.asset("assets/bottom_tab/credit_selected.png", height: 45),
      Image.asset("assets/bottom_tab/profile_selected.png", height: 45),
    ];

    return Scaffold(
        bottomNavigationBar: CurvedNavigationBarCustom(
          key: _bottomNavigationKey,
          index: _page,
          items: items,
          itemsSelected: itemsSelected,
          labels: labels,
          color: AppThemeNotifier.background,
          buttonBackgroundColor: AppThemeNotifier.background,
          backgroundColor: AppThemeNotifier.background,
          animationCurve: Curves.easeInOut,
          height: 75,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _buildBody(isPlanDisabled));
  }

  Widget _buildBody(bool isPlanDisabled) {
    if (isPlanDisabled) {
      return _page == 0
          ? HomeScreen(onTapSetting: () {
              setState(() {
                _page = 2; // Index of Profile when Credit is hidden
              });
            })
          : _page == 1
              ? YourMatchScreen()
              : _page == 2
                  ? (GetStorage().read(isGuest) ?? false
                      ? GuestProfileScreen()
                      : ProfileScreen())
                  : _errorPage();
    } else {
      return _page == 0
          ? HomeScreen(onTapSetting: () {
              setState(() {
                _page = 3; // Index of Profile when Credit is visible
              });
            })
          : _page == 1
              ? YourMatchScreen()
              : _page == 2
                  ? PlanSwitchScreen()
                  : _page == 3
                      ? (GetStorage().read(isGuest) ?? false
                          ? GuestProfileScreen()
                          : ProfileScreen())
                      : _errorPage();
    }
  }

  Widget _errorPage() {
    return Container(
      color: AppThemeNotifier.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_page.toString(), style: TextStyle(fontSize: 160)),
            ElevatedButton(
              child: Text('Go To Page of index 1'),
              onPressed: () {
                final CurvedNavigationBarState? navBarState =
                    _bottomNavigationKey.currentState;
                navBarState?.setPage(1);
              },
            )
          ],
        ),
      ),
    );
  }
}