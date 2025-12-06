import 'dart:ui';

import '../../core/utils/export.dart';

BoxDecoration boxDecorationContainer ({Color?borderColor,double ?borderRadius,Color? bgColor,Color?shadowColor}){
  return BoxDecoration(
    color: bgColor??AppThemeNotifier.background,
    borderRadius: BorderRadius.circular(borderRadius??10),
    // border: Border.all(
    //   color:borderColor?? AppThemeNotifier.shadow.withOpacity(0.6),
    //   width: 0.8,
    // ),
    boxShadow: [
      BoxShadow(
        color:shadowColor?? AppThemeNotifier.shadow.withOpacity(0.1),
        blurRadius: 2,
        offset: const Offset(0, 0),
      ),
    ],
  );
}

BoxDecoration gradientDarkBox (){
  return BoxDecoration(

    borderRadius: BorderRadius.circular(50),
    gradient: LinearGradient(colors: [
      Color(0x80111B2C),
      Color(0x4D111B2C),
      Color(0x33111B2C),
    ],
    begin: AlignmentGeometry.topCenter,
      end: AlignmentGeometry.bottomCenter
    ),

  );
}

