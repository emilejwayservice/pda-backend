
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/presentation/blocs/list_chargement/list_chargement_bloc.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/chargements/components/chargement_item.dart';

import '../../../../routes.dart';






class ChargementScreen extends StatefulWidget {

  ChargementScreen({Key? key}) : super(key: key);


  static Widget page(){
    return BlocProvider<ListChargementBloc>(
        create: (context)=>ListChargementBloc(),
      child: ChargementScreen(),
    );
  }


  @override
  State<ChargementScreen> createState() => _ChargementScreenState();
}

class _ChargementScreenState extends State<ChargementScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Chargement",
      ),
      body: BlocBuilder<ListChargementBloc,ListChargementState>(
        builder: (context,state){
          if(state.fetchDataStatus==AppStatus.loading){
            return const Center(
              child: LoadingWidget(),
            );
          }else if(state.fetchDataStatus==AppStatus.error){
            if(state.isOffline??false){
              return OfflineWidget(action: AppStrings.tryAgain,actionCLick: fetchData, msg: AppStrings.checkConnectivity);
            }else{
              return MyErrorWidget(action: AppStrings.tryAgain,actionCLick: fetchData, error: "Error");
            }
          }else if(state.fetchDataStatus==AppStatus.success){
            return ListView.builder(
                itemCount: state.chargements?.length??0,
                itemBuilder: (context,index)=>ChargementItem(chargement: state.chargements!.elementAt(index))
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: addChargement,
        child: const Icon(Icons.add,size: 30,color: Colors.white,),
      ) ,
    );
  }

  void addChargement() {
      GoRouter.of(context).push(Routes.addChargement);
  }

  void fetchData() {
    BlocProvider.of<ListChargementBloc>(context).add(FetchData());
  }
}
