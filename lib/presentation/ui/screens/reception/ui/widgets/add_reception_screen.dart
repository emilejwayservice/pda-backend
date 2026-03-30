import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/utils/show_toast.dart';
import 'package:pda/presentation/ui/screens/reception/bloc/reception_bloc.dart';
import 'package:pda/presentation/ui/screens/reception/ui/widgets/reception_details_form.dart';
import 'package:pda/presentation/ui/screens/reception/ui/widgets/reception_header_form.dart';
import 'package:pda/presentation/ui/screens/reception/ui/widgets/reception_step_indicator.dart';
import 'package:toastification/toastification.dart';

class AddReceptionScreen extends StatefulWidget {
  const AddReceptionScreen({Key? key}) : super(key: key);

  @override
  State<AddReceptionScreen> createState() => _AddReceptionScreenState();
}

class _AddReceptionScreenState extends State<AddReceptionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _steps = ['Réception', 'Articles'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
    context.read<ReceptionBloc>().add(FetchReceptionData());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            BlocConsumer<ReceptionBloc, ReceptionState>(
              listenWhen: (previous, current) =>
                  previous.submitReceptionStatus !=
                      current.submitReceptionStatus ||
                  previous.submitDetailStatus != current.submitDetailStatus,
              listener: _listener,
              builder: (context, state) {
                if (state.fetchDataStatus == AppStatus.loading) {
                  return const Expanded(child: _LoadingView());
                }
                if (state.fetchDataStatus == AppStatus.error) {
                  return Expanded(
                    child: _ErrorView(
                      isOffline: state.isOffline ?? false,
                      onRetry: () => context
                          .read<ReceptionBloc>()
                          .add(FetchReceptionData()),
                    ),
                  );
                }
                return Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        _buildStepHeader(state),
                        Expanded(child: _buildBody(state)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF97316),
        boxShadow: [
          BoxShadow(
            color: Color(0x22F97316),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nouvelle réception',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Enregistrez une réception de marchandises',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_rounded,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(ReceptionState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: ReceptionStepIndicator(
        currentStep: state.currentStep,
        steps: _steps,
      ),
    );
  }

  Widget _buildBody(ReceptionState state) {
    if (state.currentStep == 0) {
      return const ReceptionHeaderForm();
    }
    return const ReceptionDetailForm();
  }

  void _listener(BuildContext context, ReceptionState state) {
    if (state.submitReceptionStatus == AppStatus.success) {
      showToast(
        'Réception créée avec succès',
        context,
        type: ToastificationType.success,
      );
      _animController.reset();
      _animController.forward();
    } else if (state.submitReceptionStatus == AppStatus.warning) {
      showToast(
        state.error ?? 'Validation échouée',
        context,
        type: ToastificationType.warning,
      );
    } else if (state.submitReceptionStatus == AppStatus.error) {
      showToast(
        state.isOffline == true
            ? 'Pas de connexion internet'
            : 'Erreur lors de la création',
        context,
        type: ToastificationType.error,
      );
    }

    if (state.submitDetailStatus == AppStatus.success) {
      showToast(
        'Article ajouté avec succès',
        context,
        type: ToastificationType.success,
      );
    } else if (state.submitDetailStatus == AppStatus.warning) {
      showToast(
        state.error ?? 'Validation échouée',
        context,
        type: ToastificationType.warning,
      );
    } else if (state.submitDetailStatus == AppStatus.error) {
      showToast(
        state.isOffline == true
            ? 'Pas de connexion internet'
            : "Erreur lors de l'ajout",
        context,
        type: ToastificationType.error,
      );
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF97316),
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des données...',
            style: GoogleFonts.poppins(
              color: const Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onRetry;

  const _ErrorView({required this.isOffline, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isOffline
                    ? const Color(0xFFFFF3E0)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isOffline
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                color: isOffline
                    ? const Color(0xFFF97316)
                    : const Color(0xFFEF5350),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isOffline ? 'Pas de connexion' : 'Erreur de chargement',
              style: GoogleFonts.poppins(
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isOffline
                  ? 'Vérifiez votre connexion internet et réessayez.'
                  : 'Une erreur est survenue. Veuillez réessayer.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('Réessayer',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
