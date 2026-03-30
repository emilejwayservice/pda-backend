import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/presentation/ui/screens/reception/bloc/reception_bloc.dart';

import 'reception_dropdown.dart';
import 'reception_text_field.dart';

class ReceptionHeaderForm extends StatefulWidget {
  const ReceptionHeaderForm({Key? key}) : super(key: key);

  @override
  State<ReceptionHeaderForm> createState() => _ReceptionHeaderFormState();
}

class _ReceptionHeaderFormState extends State<ReceptionHeaderForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _dateController;
  late TextEditingController _refController;
  late TextEditingController _fraisController;
  late TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _dateController = TextEditingController();
    _refController = TextEditingController();
    _fraisController = TextEditingController();
    _destinationController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceptionBloc>().add(FetchNextRef());
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _refController.dispose();
    _fraisController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionBloc, ReceptionState>(
      builder: (context, state) {
        _dateController.text = state.selectedDateReception.formattedDateFr;

        if (state.nextRef != null && _refController.text != state.nextRef) {
          _refController.text = state.nextRef!;
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _RefField(
                controller: _refController,
                isLoading: state.fetchNextRefStatus == AppStatus.loading,
                hasError: state.fetchNextRefStatus == AppStatus.error,
                onRetry: () =>
                    context.read<ReceptionBloc>().add(FetchNextRef()),
              ),
              const SizedBox(height: 16),
              ReceptionTextField(
                label: "Date de réception",
                hint: "Sélectionner une date",
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                suffix: const Icon(Icons.calendar_today_rounded,
                    color: Color(0xFFF97316), size: 18),
              ),
              const SizedBox(height: 16),
              ReceptionDropdown<int>(
                hint: "Sélectionner un entrepôt",
                label: "Entrepôt",
                prefixIcon: Icons.warehouse_rounded,
                value: state.selectedEntrepot?.id,
                items: state.entrepots
                    .map((e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.libelle ?? '',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A1A2E),
                                  fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  context.read<ReceptionBloc>().add(SelectEntrepotReception(
                      state.entrepots.firstWhere((e) => e.id == id)));
                },
              ),
              const SizedBox(height: 16),
              ReceptionTextField(
                label: "Destination  (optionnel)",
                hint: "Ex: PORT AGADIR",
                controller: _destinationController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              ReceptionTextField(
                label: "Frais  (optionnel)",
                hint: "Ex: 1500.00",
                controller: _fraisController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              const SizedBox(height: 28),
              _SubmitButton(
                isLoading: state.submitReceptionStatus == AppStatus.loading,
                onPressed: () => _submit(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFF97316),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null && context.mounted) {
      context.read<ReceptionBloc>().add(SelectReceptionDate(date));
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ReceptionBloc>().add(SubmitReception(
          destination: _destinationController.text.trim().isEmpty
              ? null
              : _destinationController.text.trim(),
          frais: _fraisController.text.trim().isEmpty
              ? null
              : double.tryParse(_fraisController.text),
        ));
  }
}

class _RefField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;

  const _RefField({
    required this.controller,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Référence",
          style: GoogleFonts.poppins(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFEF4444).withOpacity(0.5)
                  : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.tag_rounded, color: Color(0xFF9CA3AF), size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: isLoading
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Color(0xFFF97316)),
                          ),
                          const SizedBox(width: 10),
                          Text("Chargement...",
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 13)),
                        ],
                      )
                    : hasError
                        ? Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Color(0xFFEF4444), size: 15),
                              const SizedBox(width: 8),
                              Text("Erreur",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFFEF4444),
                                      fontSize: 13)),
                            ],
                          )
                        : Text(
                            controller.text.isEmpty ? "—" : controller.text,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFF97316),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
              ),
              if (hasError)
                GestureDetector(
                  onTap: onRetry,
                  child: const Icon(Icons.refresh_rounded,
                      color: Color(0xFFF97316), size: 18),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFFE0B2)),
                  ),
                  child: Text(
                    "AUTO",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFFF97316),
                        fontSize: 9,
                        fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF97316),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          shadowColor: const Color(0xFFF97316).withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text("Créer la réception",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
      ),
    );
  }
}
