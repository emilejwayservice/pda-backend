import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/domain/entities/client.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/add_command/add_command_bloc.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/add_command/components/recap/recap.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/enums/app_status.dart';
import '../../../../core/utils/show_toast.dart';
import '../../components/error_widget.dart';
import '../../components/form_field.dart';
import '../../components/loading_widget.dart';
import '../../components/not_found_widget.dart';
import '../../components/offline_widget.dart';
import 'components/product_item.dart';

class AddCommandScreen extends StatefulWidget {
  AddCommandScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<AddCommandBloc>(
      create: (context) => AddCommandBloc(),
      child: AddCommandScreen(),
    );
  }

  @override
  State<AddCommandScreen> createState() => _AddCommandScreenState();
}

class _AddCommandScreenState extends State<AddCommandScreen> {
  late TextEditingController dateCommandController;
  late TextEditingController dateLivraisonController;
  late TextEditingController rechercheController;

  @override
  void initState() {
    super.initState();
    dateCommandController = TextEditingController();
    dateLivraisonController = TextEditingController();
    rechercheController = TextEditingController();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "Nouveau Command",
      ),
      body: Column(
        children: [
          BlocListener<AddCommandBloc, AddCommandState>(
            listener: listener,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<AddCommandBloc, AddCommandState>(
              builder: (context, state) {
                if (state.fetchClientsStatus == AppStatus.loading) {
                  return const Center(child: LoadingWidget());
                } else if (state.fetchClientsStatus == AppStatus.error) {
                  if (state.isOffline ?? false) {
                    return Center(
                      child: OfflineWidget(
                        action: AppStrings.tryAgain,
                        msg: AppStrings.checkConnectivity,
                        actionCLick: fetchData,
                      ),
                    );
                  } else {
                    return Center(
                      child: MyErrorWidget(
                        action: AppStrings.tryAgain,
                        error: "Error",
                        actionCLick: fetchData,
                      ),
                    );
                  }
                } else if (state.fetchClientsStatus == AppStatus.success) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MyFormField(
                          hint: "Entrer la date de command",
                          label: "Date commade",
                          borderColor: Colors.black,
                          labelColor: Colors.black,
                          activeBorderColor: Colors.black,
                          hintColor: Colors.grey,
                          controller: dateCommandController
                            ..text = state.dateCommand?.formattedDateFr ?? "",
                          readOnly: true,
                          onTap: selectDateCommand,
                          onSuffixClick: selectDateCommand,
                          suffix: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        MyFormField(
                          hint: "Entrer la date prévue de livraison",
                          label: "Date livraison",
                          borderColor: Colors.black,
                          labelColor: Colors.black,
                          activeBorderColor: Colors.black,
                          hintColor: Colors.grey,
                          controller: dateLivraisonController
                            ..text =
                                state.dateLivraisonPrevu?.formattedDateFr ?? "",
                          readOnly: true,
                          onTap: selectDateLivraison,
                          onSuffixClick: selectDateLivraison,
                          suffix: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton(
                            hint: Text(
                              "Entrez le client",
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                            menuMaxHeight: 400,
                            underline: null,
                            isExpanded: true,
                            value: state.selectedClient,
                            items: List<DropdownMenuItem<ClientEntity>>.from(
                              state.clients!.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "${e.nom}",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: onChanged,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Produits",
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: onAllProductsClick,
                                              icon: const Icon(
                                                Icons.list_alt_outlined,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: onScannerClick,
                                              icon: const Icon(
                                                Icons.qr_code,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: onCartClick,
                                              icon: Badge(
                                                label: Text(
                                                    "${state.nbSelectedProds}"),
                                                child: Icon(
                                                  Icons.shopping_cart_rounded,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 170,
                                          height: 35,
                                          child: MyFormField(
                                            label: "",
                                            hint: "Recherche",
                                            borderColor: Colors.black,
                                            activeBorderColor: Colors.black,
                                            hintColor: Colors.grey,
                                            onChange: onRecherche,
                                            controller: rechercheController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Expanded(child: _getProducts(state)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProducts(AddCommandState state) {
    if (state.fetchProductsStatus == AppStatus.success) {
      if (state.displayedProducts?.isNotEmpty ?? false) {
        return ListView.builder(
          itemCount: state.displayedProducts!.length,
          itemBuilder: (context, index) => ProductItem(
            onSelectProduct: onSelectProduit,
            product: state.displayedProducts!.elementAt(index),
          ),
        );
      }
    } else if (state.fetchProductsStatus == AppStatus.error) {
      if (state.isOffline ?? false) {
        return Center(
          child: OfflineWidget(
            action: AppStrings.tryAgain,
            msg: AppStrings.checkConnectivity,
            actionCLick: fetchData,
          ),
        );
      } else {
        return Center(
          child: MyErrorWidget(
            action: AppStrings.tryAgain,
            error: "Error",
            actionCLick: fetchData,
          ),
        );
      }
    } else if (state.fetchProductsStatus == AppStatus.loading) {
      return const Center(child: LoadingWidget());
    }
    return NotFoundWidget();
  }

  void fetchData() {
    BlocProvider.of<AddCommandBloc>(context).add(FetchData());
  }

  void onChanged(ClientEntity? value) {
    if (value == null) return;
    BlocProvider.of<AddCommandBloc>(context).add(SelectClient(value));
  }

  void selectDateCommand() async {
    DateTime? dateCommand = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: -10)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (dateCommand != null) {
      BlocProvider.of<AddCommandBloc>(context)
          .add(SelectDateCommand(dateCommand));
    }
  }

  void selectDateLivraison() async {
    DateTime? dateLivraison = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: -10)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (dateLivraison != null) {
      BlocProvider.of<AddCommandBloc>(context)
          .add(SelectDateLivraison(dateLivraison));
    }
  }

  void onRecherche(String query) {
    BlocProvider.of<AddCommandBloc>(context).add(Recherche(query, true));
  }

  void listener(BuildContext context, AddCommandState state) {
    if (state.cartStatus == AppStatus.error) {
      showToast(
        "Entrer la quantité",
        context,
        type: ToastificationType.info,
        description: "Vous devez entrer la quantité des produits sélectionnés",
      );
    } else if (state.cartStatus == AppStatus.success) {
      AddCommandBloc bloc = BlocProvider.of<AddCommandBloc>(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecapScreen.page(bloc),
        ),
      );
    }
  }

  void onSelectProduit(ProductEntity p) {
    BlocProvider.of<AddCommandBloc>(context).add(SelectProduit());
  }

  void onAllProductsClick() {
    rechercheController.clear();
    BlocProvider.of<AddCommandBloc>(context).add(SelectAllProducts());
  }

  void onScannerClick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BarcodeScannerPage(),
      ),
    );
    if (result != null && result is String && result.isNotEmpty) {
      BlocProvider.of<AddCommandBloc>(context).add(Recherche(result, false));
    }
  }

  void onCartClick() {
    BlocProvider.of<AddCommandBloc>(context).add(CheckCartStatus());
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  bool hasScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (hasScanned) return;
          final barcode = capture.barcodes.firstOrNull;
          if (barcode?.rawValue != null) {
            hasScanned = true;
            Navigator.pop(context, barcode!.rawValue);
          }
        },
      ),
    );
  }
}
