import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/logout.dart';
import 'package:pda/presentation/blocs/initialiser/initialiser_cubit.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/auth/components/logo.dart';





class InitialiserScreen extends StatefulWidget {
  InitialiserScreen({Key? key}) : super(key: key);


  static Widget page(){
    return BlocProvider<InitialiserCubit>(
        create: (context)=>InitialiserCubit(),
        child: InitialiserScreen(),
    );
  }


  @override
  State<InitialiserScreen> createState() => _InitialiserScreenState();
}

class _InitialiserScreenState extends State<InitialiserScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }



  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            BlocListener<InitialiserCubit,InitialiserState>(
                listener: listener,
                child:SizedBox()
            ),
            const LogoWidget(),
            Expanded(
              child: Center(
                child: BlocBuilder<InitialiserCubit,InitialiserState>(
                  builder: (context,state){
                    if(state.fetchData==AppStatus.loading){
                      return LoadingWidget();
                    }else if(state.fetchData==AppStatus.error){
                      if(state.isOffline??false){
                        return OfflineWidget(
                          msg: AppStrings.checkConnectivity,
                          action: AppStrings.tryAgain,
                          actionCLick: fetchData,
                        );
                      }else{
                        return MyErrorWidget(
                          error: "Error",
                          action: AppStrings.tryAgain,
                          actionCLick: fetchData,
                        );
                      }
                    }
                    return SizedBox();
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  void fetchData() {
    BlocProvider.of<InitialiserCubit>(context).fetchData();
  }

  void listener(BuildContext context, InitialiserState state) {
    if(state.fetchData==AppStatus.success){
      while(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      GoRouter.of(context).replace(state.destination!);
    }
  }
}
