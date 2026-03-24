import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/app_colors.dart';
import 'package:pda/core/constants/app_strings.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/core/validator/validator.dart';
import 'package:pda/domain/entities/type_client.dart';
import 'package:pda/presentation/ui/components/custom_button.dart';
import 'package:pda/presentation/ui/components/dropdownlist.dart';
import 'package:pda/presentation/ui/components/form_field.dart';
import 'package:toastification/toastification.dart';

import '../../../../blocs/clients/clients_bloc.dart';

class ClientDialog extends StatefulWidget {
  ClientDialog();

  static Widget page(ClientsBloc clientsBloc) {
    return BlocProvider.value(
      value: clientsBloc,
      child: ClientDialog(),
    );
  }

  @override
  State<ClientDialog> createState() => _ClientDialogState();
}

class _ClientDialogState extends State<ClientDialog> {
  late TextEditingController rsController;
  late GlobalKey<FormState> formState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rsController = TextEditingController();
    formState = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        width: width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400),
        padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocListener<ClientsBloc,ClientsState>(
                  listener: listener,
                child: SizedBox(),
              ),
              BlocBuilder<ClientsBloc, ClientsState>(
                builder: (context, state) => Form(
                  key: formState,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ajouter un nouveau client",
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      MyFormField(
                        hint: "Entrez Nom/RS",
                        label: "Nom/RS",
                        borderColor: Colors.black,
                        activeBorderColor: Colors.black,
                        labelColor: Colors.black,
                        hintColor: Colors.grey,
                        validator: Validator().required().make(),
                        controller: rsController,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: DropdownButton(
                              hint: Text(
                                "Entrez le type de client",
                                style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.w700, color: Colors.grey),
                              ),
                              menuMaxHeight: 400,
                              underline: null,
                              isExpanded: true,
                              value: state.selectedType,
                              items: List<DropdownMenuItem<TypeClientEntity>>.from(
                                  state.types!.map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          "${e.libelle}",
                                          style: GoogleFonts.aBeeZee(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ))),
                              onChanged: onChanged),
                        ),
                      ),
                      const SizedBox(height: 25,),
                      MyCustomButton(
                          name: "Ajouter",
                        color: AppColors.primaryColor,
                        onClick: onAddClient,
                        isLoading: state.addClientStatus==AppStatus.loading,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onChanged(TypeClientEntity? value) {
    if (value == null) return;
    BlocProvider.of<ClientsBloc>(context).add(SelectType(value));
  }

  void onAddClient() {
    if(!formState.currentState!.validate()){
      return;
    }
    if(BlocProvider.of<ClientsBloc>(context).state.selectedType==null){
      showToast("choisir le type de client", context,type: ToastificationType.info);
      return;
    }
    BlocProvider.of<ClientsBloc>(context).add(AddClient(rsController.text));
  }

  void listener(BuildContext context, ClientsState state) {
    if(state.addClientStatus==AppStatus.error){
      showToast("Error", context,description: AppStrings.tryAgain,type: ToastificationType.error);
    }else if(state.addClientStatus==AppStatus.success){
      Navigator.pop(context,true);
    }
  }
}
