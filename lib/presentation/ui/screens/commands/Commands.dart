import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/extensions/extension_on_string.dart';
import 'package:pda/domain/entities/command.dart';
import 'package:pda/presentation/blocs/commands/commands_bloc.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/commands/components/command_detail.dart';
import 'package:pda/routes.dart';


class CommandScreen extends StatefulWidget {

  CommandScreen({Key? key}) : super(key: key);

  static Widget page(){
    return BlocProvider<CommandsBloc>(
      create: (context)=>CommandsBloc(),
      child: CommandScreen(),
    );
  }

  @override
  State<CommandScreen> createState() => _CommandScreenState();
}

class _CommandScreenState extends State<CommandScreen> {



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
        title: "Commandes",
      ),
      body:BlocBuilder<CommandsBloc,CommandsState>(
        builder: (context,state){
          if(state.fetchDataStatus==AppStatus.loading){
            return Center(child: LoadingWidget());
          }else if(state.fetchDataStatus==AppStatus.error){
            if(state.isOffline??false){
              return Center(child: OfflineWidget(msg: AppStrings.checkConnectivity, action: AppStrings.tryAgain,actionCLick: fetchData,));
            }else{
              return Center(child: MyErrorWidget(error: "Error", action: AppStrings.tryAgain,actionCLick: fetchData,));
            }
          }else if(state.fetchDataStatus==AppStatus.success){
            return ListView.builder(
                itemCount: state.commands?.length??0,
                itemBuilder: (context,index){
                  CommandEntity command=state.commands!.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.only(left: 18.0,right: 18.0,top: 27),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ListTile(
                          onTap: ()=>onCommandClick(command,context),
                          contentPadding: const EdgeInsets.symmetric(vertical:13 ,horizontal: 16),
                          tileColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          title: Text(command.dateCommand?.formattedDateFr??"-",
                            style: GoogleFonts.aBeeZee(color:Colors.black,fontSize:18,fontWeight:FontWeight.bold),) ,
                          trailing: Text(command.totalTTC?.toString()??"-",style: GoogleFonts.aBeeZee(color:Colors.green,fontSize:18,fontWeight:FontWeight.w700),),
                        ),
                        Positioned(
                          right: 10,
                          top: -19,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            decoration: BoxDecoration(
                                color: command.status?.color?.toColor,
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: Text(command.status?.status??"",style: GoogleFonts.aBeeZee(color:Colors.white,fontSize:15,fontWeight:FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  );
                }
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: onAddCommand,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add,color: Colors.white,),
      ) ,
    );
  }

  void onAddCommand() {
    GoRouter.of(context).push(Routes.addCommand);
  }

  void fetchData() {
    BlocProvider.of<CommandsBloc>(context).add(FetchCommands());
  }

  onCommandClick(CommandEntity command, BuildContext context) {
    GoRouter.of(context).push("/commands/${command.id}");
  }
}