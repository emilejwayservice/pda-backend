import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/extensions/extension_on_date.dart';
import 'package:pda/presentation/ui/screens/reception/bloc/reception_bloc.dart';

import 'reception_dropdown.dart';
import 'reception_text_field.dart';

class ReceptionDetailForm extends StatefulWidget {
  const ReceptionDetailForm({Key? key}) : super(key: key);

  @override
  State<ReceptionDetailForm> createState() => _ReceptionDetailFormState();
}

class _ReceptionDetailFormState extends State<ReceptionDetailForm> {
  late GlobalKey<FormState> _formKey;

  late TextEditingController _lotController;
  late TextEditingController _nbrCaisseController;
  late TextEditingController _puBrutController;
  late TextEditingController _priceController;

  late TextEditingController _poidsBrutController;
  late TextEditingController _totalHtController;
  late TextEditingController _totalTtcController;

  late TextEditingController _tvaController;
  late TextEditingController _uniteController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _lotController = TextEditingController();
    _nbrCaisseController = TextEditingController();
    _puBrutController = TextEditingController();
    _priceController = TextEditingController();
    _poidsBrutController = TextEditingController();
    _totalHtController = TextEditingController();
    _totalTtcController = TextEditingController();
    _tvaController = TextEditingController();
    _uniteController = TextEditingController();

    _nbrCaisseController.addListener(_recalculate);
    _puBrutController.addListener(_recalculate);
    _priceController.addListener(_recalculate);
  }

  @override
  void dispose() {
    _lotController.dispose();
    _nbrCaisseController.dispose();
    _puBrutController.dispose();
    _priceController.dispose();
    _poidsBrutController.dispose();
    _totalHtController.dispose();
    _totalTtcController.dispose();
    _tvaController.dispose();
    _uniteController.dispose();
    super.dispose();
  }

  void _recalculate() {
    final nbrCaisse = int.tryParse(_nbrCaisseController.text) ?? 0;
    final puBrut = double.tryParse(_puBrutController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final tva = double.tryParse(_tvaController.text) ?? 0.0;

    final poidsBrut = puBrut * nbrCaisse;
    final totalHt = nbrCaisse * price;
    final totalTtc = nbrCaisse * price * (1 + tva / 100);

    setState(() {
      _poidsBrutController.text = poidsBrut > 0 ? _fmt(poidsBrut) : '';
      _totalHtController.text = totalHt > 0 ? _fmt(totalHt) : '';
      _totalTtcController.text = totalTtc > 0 ? _fmt(totalTtc) : '';
    });
  }

  String _fmt(double v) => v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionBloc, ReceptionState>(
      builder: (context, state) {
        _lotController.text = state.selectedLot.formattedDateFr;

        final unit = state.articleUnit;
        if (unit != null) {
          final newTva = unit.tva?.toString() ?? '';
          if (_tvaController.text != newTva) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _tvaController.text = newTva;
              _uniteController.text =
                  '${unit.label ?? ''} (${unit.unite ?? ''})'.trim();
              _recalculate();
            });
          }
        }

        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _receptionBadge(state),
              const SizedBox(height: 20),
              ReceptionDropdown<int>(
                hint: "Sélectionner un article",
                label: "Article",
                prefixIcon: Icons.inventory_2_rounded,
                value: state.selectedArticle?.id,
                items: state.articles
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
                  final article = state.articles.firstWhere((a) => a.id == id);
                  context.read<ReceptionBloc>().add(SelectArticle(article));
                  _tvaController.clear();
                  _uniteController.clear();
                  _recalculate();
                },
              ),
              const SizedBox(height: 16),
              _buildArticleUnitSection(state),
              const SizedBox(height: 16),
              ReceptionDropdown<int>(
                hint: "Sélectionner un bateau",
                label: "Bateau",
                prefixIcon: Icons.directions_boat_rounded,
                value: state.selectedBateau?.id,
                items: state.bateaux
                    .map((e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.nom ?? '',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF1A1A2E),
                                  fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  context.read<ReceptionBloc>().add(SelectBateau(
                      state.bateaux.firstWhere((b) => b.id == id)));
                },
              ),
              const SizedBox(height: 16),
              ReceptionTextField(
                label: "Date du lot",
                hint: "Sélectionner une date",
                controller: _lotController,
                readOnly: true,
                onTap: () => _selectLot(context),
                suffix: const Icon(Icons.calendar_today_rounded,
                    color: Color(0xFFF97316), size: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ReceptionTextField(
                      label: "Nbr caisses",
                      hint: "0",
                      controller: _nbrCaisseController,
                      keyboardType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Requis" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReceptionTextField(
                      label: "PU Brut (unitaire)",
                      hint: "0.0000",
                      controller: _puBrutController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,4}'))
                      ],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Requis" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DisabledCalcField(
                label: "Poids brut  (auto = PU Brut × Nbr caisses)",
                controller: _poidsBrutController,
                hint: "Calculé automatiquement",
                color: const Color(0xFF3B82F6),
                icon: Icons.scale_rounded,
              ),
              const SizedBox(height: 16),
              ReceptionTextField(
                label: "Prix unitaire  (optionnel)",
                hint: "0.00",
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DisabledCalcField(
                      label: "Total HT  (auto)",
                      controller: _totalHtController,
                      hint: "Calculé",
                      color: const Color(0xFF10B981),
                      icon: Icons.receipt_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DisabledCalcField(
                      label: "Total TTC  (auto)",
                      controller: _totalTtcController,
                      hint: "Calculé",
                      color: const Color(0xFFF97316),
                      icon: Icons.receipt_long_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<ReceptionBloc>().add(ResetReception()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        side: const BorderSide(
                            color: Color(0xFFE5E7EB), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text("Nouvelle",
                          style: GoogleFonts.poppins(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: state.submitDetailStatus == AppStatus.loading
                          ? null
                          : () => _submit(context, state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      icon: state.submitDetailStatus == AppStatus.loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white)),
                            )
                          : const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text("Ajouter article",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticleUnitSection(ReceptionState state) {
    final isLoading = state.fetchArticleUnitStatus == AppStatus.loading;
    final hasArticle = state.selectedArticle != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DisabledCalcField(
                label: "TVA (%)  (auto)",
                controller: _tvaController,
                hint: hasArticle
                    ? (isLoading ? "Chargement..." : "—")
                    : "Sélect. article",
                color: const Color(0xFFF97316),
                icon: isLoading
                    ? Icons.hourglass_empty_rounded
                    : Icons.percent_rounded,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DisabledCalcField(
                label: "Unité  (auto)",
                controller: _uniteController,
                hint: hasArticle
                    ? (isLoading ? "Chargement..." : "—")
                    : "Sélect. article",
                color: const Color(0xFF3B82F6),
                icon: isLoading
                    ? Icons.hourglass_empty_rounded
                    : Icons.straighten_rounded,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
        if (state.fetchArticleUnitStatus == AppStatus.error)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Color(0xFFEF4444), size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text("Erreur chargement infos article",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFEF4444), fontSize: 11)),
                ),
                GestureDetector(
                  onTap: () {
                    if (state.selectedArticle?.id != null) {
                      context
                          .read<ReceptionBloc>()
                          .add(FetchArticleUnit(state.selectedArticle!.id!));
                    }
                  },
                  child: const Icon(Icons.refresh_rounded,
                      color: Color(0xFFF97316), size: 18),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _receptionBadge(ReceptionState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                color: Color(0xFFF97316), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Réception #${state.createdReceptionId}",
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFF97316),
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                Text(
                  "Ajoutez les articles à cette réception",
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF9CA3AF), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectLot(BuildContext context) async {
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
      context.read<ReceptionBloc>().add(SelectLotDate(date));
    }
  }

  void _submit(BuildContext context, ReceptionState state) {
    if (!_formKey.currentState!.validate()) return;
    final tva =
        double.tryParse(_tvaController.text) ?? state.articleUnit?.tva ?? 0.0;
    context.read<ReceptionBloc>().add(SubmitReceptionDetail(
          nbrCaisse: int.tryParse(_nbrCaisseController.text) ?? 0,
          puBrut: double.tryParse(_puBrutController.text) ?? 0.0,
          poidsBrut: double.tryParse(_poidsBrutController.text) ?? 0.0,
          price: _priceController.text.trim().isEmpty
              ? null
              : double.tryParse(_priceController.text),
          tva: tva,
        ));
  }
}

class _DisabledCalcField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final Color color;
  final IconData icon;
  final bool isLoading;

  const _DisabledCalcField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.color,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            children: [
              isLoading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: color),
                    )
                  : Icon(icon, size: 15, color: color.withOpacity(0.7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.text.isEmpty ? hint : controller.text,
                  style: GoogleFonts.poppins(
                    color: controller.text.isEmpty
                        ? const Color(0xFFD1D5DB)
                        : color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
