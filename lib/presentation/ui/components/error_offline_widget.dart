import 'package:flutter/material.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';




class OfflineErrodWidget extends StatelessWidget {
  bool isOffline;
  void Function()? action;
  String? error;
  OfflineErrodWidget({this.error,this.action,required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return Center(child: content(),) ;
  }
  Widget content()=>isOffline
      ?OfflineWidget(action: AppStrings.tryAgain, msg:AppStrings.checkConnectivity,actionCLick: action, )
      :MyErrorWidget(error: error??"Error", action: AppStrings.tryAgain,actionCLick: action,);
}


