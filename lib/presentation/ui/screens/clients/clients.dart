import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_images.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/services/encryption_service.dart';
import 'package:pda/core/utils/show_dialogue_infos.dart';
import 'package:pda/core/utils/show_progress_dialogue.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/presentation/blocs/clients/clients_bloc.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/clients/components/clients_body.dart';
import 'package:pda/presentation/ui/screens/clients/components/create_client_dialog.dart';
import 'package:pda/routes.dart';
import 'package:toastification/toastification.dart';

import '../../components/tab_item.dart';

class ClientsScreen extends StatefulWidget {
  ClientsScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<ClientsBloc>(
      create: (context) => ClientsBloc(),
      child: ClientsScreen(),
    );
  }

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 500),
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            "Clients",
            style: GoogleFonts.aBeeZee(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: onQrCodeClick,
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ))
          ],
          bottom: TabBar(
            dividerColor: AppColors.secondaryColor.withOpacity(0.4),
            indicator: const BoxDecoration(
                color: Colors.transparent,
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 2))),
            tabs: [
              Tab(
                child: TabItem(
                    name: "Clients",
                    color: Colors.white,
                    icon: AppImages.ic_clients),
              ),
              Tab(
                child: TabItem(
                    name: "Prospect",
                    color: Colors.white,
                    icon: AppImages.ic_timer),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            BlocListener<ClientsBloc, ClientsState>(
              listener: listener,
              child: SizedBox(),
            ),
            Expanded(child: BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                if (state.fetchDataStatus == AppStatus.loading) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                } else if (state.fetchDataStatus == AppStatus.error) {
                  if (state.isOffline ?? false) {
                    return OfflineWidget(
                        action: AppStrings.tryAgain,
                        actionCLick: fetchData,
                        msg: AppStrings.checkConnectivity);
                  } else {
                    return MyErrorWidget(
                        error: "Error",
                        actionCLick: fetchData,
                        action: AppStrings.tryAgain);
                  }
                } else if (state.fetchDataStatus == AppStatus.success) {
                  return TabBarView(children: [
                    ClientsBody(
                      clients: state.getTrueClients(),
                      onClick: onClientClick,
                    ),
                    ClientsBody(
                      clients: state.getProspectClients(),
                      onClick: onClientClick,
                    ),
                  ]);
                }
                return SizedBox();
              },
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddClientClick,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void listener(BuildContext context, ClientsState state) {
    if (state.fetchDataTypesStatus == AppStatus.loading) {
      showProgressBar(context);
    } else if (state.fetchDataTypesStatus == AppStatus.error) {
      hideDialogue(context);
      if (state.isOffline ?? false) {
        showToast("Error", context,
            description: AppStrings.checkConnectivity,
            type: ToastificationType.error);
      } else {
        showToast("Error", context,
            description: AppStrings.tryAgain, type: ToastificationType.error);
      }
    } else if (state.fetchDataTypesStatus == AppStatus.success) {
      hideDialogue(context);
      showAddClientDialog();
    }
  }

  void fetchData() {
    BlocProvider.of<ClientsBloc>(context).add(FetchData());
  }

  void showAddClientDialog() async {
    ClientsBloc bloc = BlocProvider.of<ClientsBloc>(context);
    if (bloc.state.types?.isNotEmpty ?? false) {
      var result = await showDialog(
          context: context, builder: (context) => ClientDialog.page(bloc));
      if (result != null && result) {
        showToast("Succès", context);
      }
    } else {
      BlocProvider.of<ClientsBloc>(context).add(FetchTypes());
    }
  }

  void onQrCodeClick() async {
    var result = await GoRouter.of(context).push(Routes.scanner);
    if (result != null) {
      print("=============result=================${result}");
      try {
        EncryptionService encryptionService = EncryptionService();
        String decode = encryptionService.decrypt(result as String);
        print("=============id client=================${decode}");
        if (RegExp(r"^\d+$").hasMatch(decode)) {
          print("======================navigate");
          GoRouter.of(context)
              .push(Routes.clientDetails.replaceFirst(":id", decode));
        }
      } catch (ex) {
        print("============ error decrypting ===============${ex.toString()}");
      }
    }
  }

  void onClientClick(ClientEntity client) {
    GoRouter.of(context)
        .push(Routes.clientDetails.replaceFirst(":id", client.id.toString()));
  }

  void onAddClientClick() {
    GoRouter.of(context).push(Routes.addClient);
  }
}
