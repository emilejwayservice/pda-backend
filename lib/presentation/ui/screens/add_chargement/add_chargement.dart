import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/domain/entities/entrepot.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/add_chargement/add_chargement_bloc.dart';
import 'package:pda/presentation/ui/components/error_widget.dart';
import 'package:pda/presentation/ui/components/form_field.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/components/not_found_widget.dart';
import 'package:pda/presentation/ui/components/offline_widget.dart';
import 'package:pda/presentation/ui/screens/add_chargement/components/cart_dialog.dart';
import 'package:pda/presentation/ui/screens/add_chargement/components/product_item.dart';
import 'package:toastification/toastification.dart';

class AddChargementScreen extends StatefulWidget {
  AddChargementScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<AddChargementBloc>(
      create: (context) => AddChargementBloc(),
      child: AddChargementScreen(),
    );
  }

  @override
  State<AddChargementScreen> createState() => _AddChargementScreenState();
}

class _AddChargementScreenState extends State<AddChargementScreen> {
  late TextEditingController dateController;
  late TextEditingController rechercheController;
  late GlobalKey<FormState> formState;
  MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    rechercheController = TextEditingController();
    formState = GlobalKey<FormState>();
    fetchData();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "Nouveau Chargement",
      ),
      body: Column(
        children: [
          BlocListener<AddChargementBloc, AddChargementState>(
            listener: listener,
            child: SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<AddChargementBloc, AddChargementState>(
              builder: (context, state) {
                if (state.fetchDataStatus == AppStatus.loading) {
                  return Center(child: LoadingWidget());
                } else if (state.fetchDataStatus == AppStatus.error) {
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
                } else if (state.fetchDataStatus == AppStatus.success) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MyFormField(
                          hint: "Entrer la date",
                          label: "Date",
                          borderColor: Colors.black,
                          labelColor: Colors.black,
                          activeBorderColor: Colors.black,
                          hintColor: Colors.grey,
                          controller: dateController
                            ..text = state.selectedDate.formattedDateEn,
                          readOnly: true,
                          onTap: selectDate,
                          onSuffixClick: selectDate,
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
                              "Entrez l'entrepôt",
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                            menuMaxHeight: 400,
                            underline: null,
                            isExpanded: true,
                            value: state.selectedEntrepot,
                            items: List<DropdownMenuItem<EntrepotEntity>>.from(
                              state.entrepot!.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    "${e.libelle}",
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

  Widget _getProducts(AddChargementState state) {
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

  void onCartClick() async {
    BlocProvider.of<AddChargementBloc>(context).add(CheckCartStatus());
  }

  void onScannerClick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BarcodeScannerPage(),
      ),
    );
    if (result != null && result is String && result.isNotEmpty) {
      BlocProvider.of<AddChargementBloc>(context).add(Recherche(result, false));
    }
  }

  void onRecherche(String value) {
    BlocProvider.of<AddChargementBloc>(context).add(Recherche(value, true));
  }

  void fetchData() {
    BlocProvider.of<AddChargementBloc>(context).add(FetchData());
  }

  void selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: -356)),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (date != null) {
      BlocProvider.of<AddChargementBloc>(context).add(SelectDate(date));
    }
  }

  void onChanged(value) {
    BlocProvider.of<AddChargementBloc>(context).add(SelectEntropot(value));
  }

  void onSelectProduit(ProductEntity p) {
    BlocProvider.of<AddChargementBloc>(context).add(SelectProduit());
  }

  void onAllProductsClick() {
    rechercheController.clear();
    BlocProvider.of<AddChargementBloc>(context).add(SelectAllProducts());
  }

  void listener(BuildContext context, AddChargementState state) async {
    if (state.cartStatus == AppStatus.error) {
      showToast(
        "Entrer la quantité",
        context,
        type: ToastificationType.info,
        description: "Vous devez entrer la quantité des produits sélectionnés",
      );
    } else if (state.cartStatus == AppStatus.success) {
      AddChargementBloc bloc = BlocProvider.of<AddChargementBloc>(context);
      var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CartDialog.page(bloc),
      );
      if (result != null && result) {
        rechercheController.clear();
        showToast("Succès", context);
      }
    }
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
