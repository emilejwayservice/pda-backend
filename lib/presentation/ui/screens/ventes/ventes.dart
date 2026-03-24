import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/constants/products_images.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/ventes_direct/ventes_direct_bloc.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:pda/presentation/ui/screens/ventes/components/product_item_img.dart';
import 'package:pda/presentation/ui/screens/ventes/components/recap/recap.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../domain/entities/client.dart';
import '../../components/error_widget.dart';
import '../../components/form_field.dart';
import '../../components/not_found_widget.dart';
import '../../components/offline_widget.dart';

class VentesScreen extends StatefulWidget {
  VentesScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<VentesDirectBloc>(
      create: (context) => VentesDirectBloc(),
      child: VentesScreen(),
    );
  }

  @override
  State<VentesScreen> createState() => _VentesScreenState();
}

class _VentesScreenState extends State<VentesScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: MyAppBar(title: "Vente Direct"),
      body: Column(
        children: [
          BlocListener<VentesDirectBloc, VentesDirectState>(
            listener: listener,
            child: const SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<VentesDirectBloc, VentesDirectState>(
              builder: (context, state) {
                if (state.fetchDataStatus == AppStatus.loading) {
                  return const Center(child: LoadingWidget());
                } else if (state.fetchDataStatus == AppStatus.error) {
                  return OfflineErrodWidget(
                    isOffline: state.isOffline ?? false,
                    action: fetchData,
                    error: state.error ?? "Error",
                  );
                } else if (state.fetchDataStatus == AppStatus.success) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        MyFormField(
                          hint: "Entrer la date de livraison",
                          label: "Date livraison",
                          suffix: const Icon(Icons.date_range,
                              color: AppColors.primaryColor),
                          hintColor: Colors.grey,
                          onTap: selectDate,
                          onSuffixClick: selectDate,
                          borderColor: Colors.black,
                          activeBorderColor: Colors.black,
                          labelColor: Colors.black,
                          readOnly: true,
                          controller: TextEditingController()
                            ..text = state.dateLivraison!.formattedDateFr,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<int>(
                            hint: Text(
                              "Entrez le client",
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                            menuMaxHeight: 400,
                            underline: const SizedBox(),
                            isExpanded: true,
                            value: state.selectedClient?.id,
                            items: state.clients!
                                .map(
                                  (e) => DropdownMenuItem<int>(
                                    value: e.id,
                                    child: Text(
                                      "${e.nom}",
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (int? id) {
                              if (id == null) return;
                              ClientEntity client =
                                  state.clients!.firstWhere((c) => c.id == id);
                              onChanged(client);
                            },
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
                                    IconButton(
                                      onPressed: onCartClick,
                                      icon: Badge(
                                        label: Text("${state.nbSelectedProds}"),
                                        child: const Icon(
                                          Icons.shopping_cart_rounded,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
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
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProducts(VentesDirectState state) {
    if (state.fetchProductsStatus == AppStatus.success) {
      if (state.displayedProducts?.isNotEmpty ?? false) {
        return GridView.builder(
          itemCount: state.displayedProducts?.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          itemBuilder: (context, index) {
            ProductEntity product = state.displayedProducts!.elementAt(index);
            product.image_path = product_images.elementAt(index);
            return MyGridTile(
              product: product,
              onSelectProduct: () {
                setState(() {});
              },
            );
          },
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
    BlocProvider.of<VentesDirectBloc>(context).add(FetchData());
  }

  void selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 356)),
    );
    if (date != null) {
      BlocProvider.of<VentesDirectBloc>(context).add(SelectDate(date));
    }
  }

  void onChanged(ClientEntity client) {
    BlocProvider.of<VentesDirectBloc>(context).add(SelectClient(client));
  }

  void onCartClick() {
    BlocProvider.of<VentesDirectBloc>(context).add(CheckCartStatus());
  }

  void listener(BuildContext context, VentesDirectState state) {
    if (state.cartStatus == AppStatus.error) {
      showToast(
        "Entrer la quantité",
        context,
        type: ToastificationType.info,
        description: "Vous devez entrer la quantité des produits sélectionnés",
      );
    } else if (state.cartStatus == AppStatus.success) {
      VentesDirectBloc bloc = BlocProvider.of<VentesDirectBloc>(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecapScreen.page(bloc)),
      );
    }
  }
}
