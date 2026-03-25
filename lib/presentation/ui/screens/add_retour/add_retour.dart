import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/core/validator/validator.dart';
import 'package:pda/domain/entities/Livraison.dart';
import 'package:pda/domain/entities/details.dart';
import 'package:pda/domain/entities/entrepot.dart';
import 'package:pda/domain/entities/product.dart';
import 'package:pda/presentation/blocs/add_retour/add_retour_bloc.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/error_offline_widget.dart';
import 'package:pda/presentation/ui/components/loading_widget.dart';
import 'package:pda/presentation/ui/components/my_app_bar.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../domain/entities/client.dart';
import '../../components/error_widget.dart';
import '../../components/form_field.dart';
import '../../components/not_found_widget.dart';
import '../../components/offline_widget.dart';
import 'components/product_item.dart';

class AddRetourScreen extends StatefulWidget {
  AddRetourScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<AddRetourBloc>(
      create: (context) => AddRetourBloc(),
      child: AddRetourScreen(),
    );
  }

  @override
  State<AddRetourScreen> createState() => _AddRetourScreenState();
}

class _AddRetourScreenState extends State<AddRetourScreen> {
  late TextEditingController dateRetourController;
  late TextEditingController causeController;
  late GlobalKey<FormState> formState;

  @override
  void initState() {
    super.initState();
    dateRetourController = TextEditingController();
    causeController = TextEditingController();
    formState = GlobalKey<FormState>();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(title: "Nouveau retour"),
      body: Column(
        children: [
          BlocListener<AddRetourBloc, AddRetourState>(
            listener: listener,
            child: const SizedBox(),
          ),
          Expanded(
            child: BlocBuilder<AddRetourBloc, AddRetourState>(
              builder: (context, state) {
                if (state.fetchDataStatus == AppStatus.loading) {
                  return const Center(child: LoadingWidget());
                } else if (state.fetchDataStatus == AppStatus.error) {
                  return OfflineErrodWidget(
                    isOffline: state.isOffline ?? false,
                    action: fetchData,
                    error: state.error,
                  );
                } else if (state.fetchDataStatus == AppStatus.success) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          MyFormField(
                            hint: "Entrer date retour",
                            label: "Date retour",
                            borderColor: Colors.black,
                            labelColor: Colors.black,
                            activeBorderColor: Colors.black,
                            hintColor: Colors.grey,
                            controller: dateRetourController
                              ..text =
                                  state.selectedDateRetour!.formattedDateFr,
                            readOnly: true,
                            onTap: selectDateRetour,
                            onSuffixClick: selectDateRetour,
                            suffix: const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          MyFormField(
                            hint: "Entrez la cause de retour",
                            label: "Cause",
                            hintColor: Colors.grey,
                            controller: causeController,
                            validator: Validator().required().make(),
                            labelColor: Colors.black,
                            borderColor: Colors.black,
                            activeBorderColor: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          entrepotSelector(state),
                          const SizedBox(height: 10),
                          clientsSelector(state),
                          const SizedBox(height: 10),
                          livraisonSelector(state),
                          const SizedBox(height: 10),
                          MyCustomButton(
                            name: "Valider",
                            color: Colors.green,
                            icon: Icons.check,
                            onClick: valider,
                            isLoading: state.validerStatus == AppStatus.loading,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(17),
                                  topLeft: Radius.circular(17),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      "Produits",
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(child: _productsBody(state)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget entrepotSelector(AddRetourState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<int>(
        hint: Text(
          "Entrez l'entrepot",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: const SizedBox(),
        isExpanded: true,
        value: state.selectedEntrepot?.id,
        items: state.entrepots!
            .map((e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(
                    "${e.libelle}",
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ))
            .toList(),
        onChanged: (int? id) {
          if (id == null) return;
          EntrepotEntity entrepot =
              state.entrepots!.firstWhere((e) => e.id == id);
          onEntrepotChanged(entrepot);
        },
      ),
    );
  }

  Widget clientsSelector(AddRetourState state) {
    final uniqueClients =
        {for (var c in state.clients!) c.id: c}.values.toList();
    final selectedId =
        uniqueClients.any((c) => c.id == state.selectedClient?.id)
            ? state.selectedClient?.id
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<int>(
        hint: Text(
          "Entrez le client",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: const SizedBox(),
        isExpanded: true,
        value: selectedId,
        items: uniqueClients
            .map((e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(
                    "${e.nom}",
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ))
            .toList(),
        onChanged: (int? id) {
          if (id == null) return;
          ClientEntity client = uniqueClients.firstWhere((c) => c.id == id);
          onClientChanged(client);
        },
      ),
    );
  }

  Widget livraisonSelector(AddRetourState state) {
    // Guard: return empty widget if livraisons is null or empty
    if (state.livraisons == null || state.livraisons!.isEmpty) {
      return const SizedBox();
    }

    final uniqueLivraisons =
        {for (var l in state.livraisons!) l.id: l}.values.toList();
    final selectedId =
        uniqueLivraisons.any((l) => l.id == state.selectedLivraison?.id)
            ? state.selectedLivraison?.id
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<int>(
        hint: Text(
          "Entrez livraison",
          style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        menuMaxHeight: 400,
        underline: const SizedBox(),
        isExpanded: true,
        value: selectedId,
        items: uniqueLivraisons
            .map((e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(
                    "${e.dateLaivraison?.formattedDateFr}",
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ))
            .toList(),
        onChanged: (int? id) {
          if (id == null) return;
          LivraisonEntity livraison =
              uniqueLivraisons.firstWhere((l) => l.id == id);
          onLivraisonChanged(livraison);
        },
      ),
    );
  }

  Widget _productsBody(AddRetourState state) {
    if (state.fetchProductsStatus == AppStatus.success) {
      if (state.selectedLivraison?.details?.isNotEmpty ?? false) {
        List<LivraisonDetailEntity> details = state.selectedLivraison!.details!;
        return ListView.builder(
          itemCount: details.length,
          itemBuilder: (context, index) {
            LivraisonDetailEntity detail = details.elementAt(index);
            ProductEntity product = details.elementAt(index).product!
              ..quantity = detail.quantity?.toInt();
            return ProductItem(product: product);
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
    return NotFoundWidget(imgWidth: 180);
  }

  void fetchData() {
    BlocProvider.of<AddRetourBloc>(context).add(FetchData());
  }

  void selectDateRetour() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      BlocProvider.of<AddRetourBloc>(context).add(SelectDate(date));
    }
  }

  void onClientChanged(ClientEntity value) {
    BlocProvider.of<AddRetourBloc>(context).add(SelectClient(value));
  }

  void onEntrepotChanged(EntrepotEntity value) {
    BlocProvider.of<AddRetourBloc>(context).add(SelectEntrepot(value));
  }

  void onLivraisonChanged(LivraisonEntity value) {
    BlocProvider.of<AddRetourBloc>(context).add(SelectLivraison(value));
  }

  void valider() {
    if (formState.currentState!.validate()) {
      BlocProvider.of<AddRetourBloc>(context)
          .add(Valider(causeController.text));
    }
  }

  void listener(BuildContext context, AddRetourState state) {
    if (state.validerStatus == AppStatus.warning) {
      showToast("", context,
          description: state.error, type: ToastificationType.warning);
    } else if (state.validerStatus == AppStatus.success) {
      showToast("Success", context);
      _resetForm();
    } else if (state.validerStatus == AppStatus.error) {}
  }

  void _resetForm() {
    causeController.clear();
    formState.currentState?.reset();
    BlocProvider.of<AddRetourBloc>(context).add(ResetForm());
  }
}
