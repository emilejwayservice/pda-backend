import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/domain/entities/retour.dart';
import 'package:pda/presentation/blocs/retour/retour_bloc.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/retour/components/retour_item.dart';
import 'package:pda/routes.dart';

import '../../../../core/constants/app_colors.dart';


class RetourScreen extends StatefulWidget {

  static Widget page(){
    return BlocProvider<RetourBloc>(
      create:(context)=> RetourBloc(),
      child: RetourScreen(),
    );
  }

  RetourScreen({Key? key}) : super(key: key);

  @override
  State<RetourScreen> createState() => _RetourScreenState();
}

class _RetourScreenState extends State<RetourScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: onAddRetourClick,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      appBar: MyAppBar(
        title: "Retours",
      ),
      body: BlocBuilder<RetourBloc,RetourState>(
        builder: (context,state){
          if(state.fetchData==AppStatus.loading){
            return const Center(child: LoadingWidget(),);
          }else if(state.fetchData==AppStatus.error){
            return OfflineErrodWidget(isOffline: state.isOffline??false,error: state.error??"Error",action: fetchData,);
          }else if(state.fetchData==AppStatus.success){
            return ListView.builder(
                itemCount: state.retours?.length??0,
                itemBuilder: (context,index){
                  RetourEntity retour=state.retours!.elementAt(index);
                  return RetourItem(
                      retour: retour,
                    onClick: onClick,
                  );
                }
            );
          }
          return SizedBox();
        },
      )
    );
  }

  void fetchData() {
    BlocProvider.of<RetourBloc>(context).add(FetchData());
  }

  void onAddRetourClick() {
    GoRouter.of(context).push(Routes.addRetour);
  }

  void onClick(RetourEntity retour) {
    GoRouter.of(context).push("/retour-details/${retour.id}");
  }
}