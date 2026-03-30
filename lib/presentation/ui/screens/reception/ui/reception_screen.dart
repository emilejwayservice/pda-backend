import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/presentation/ui/screens/reception/bloc/reception_bloc.dart';
import 'package:pda/presentation/ui/screens/reception/ui/widgets/add_reception_screen.dart';
import 'package:pda/presentation/ui/screens/reception/ui/widgets/reception_card.dart';

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({Key? key}) : super(key: key);

  static Widget page() {
    return BlocProvider<ReceptionBloc>(
      create: (_) => ReceptionBloc()..add(FetchReceptionList()),
      child: const ReceptionScreen(),
    );
  }

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabAnim;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fabAnim.forward();
    });
  }

  @override
  void dispose() {
    _fabAnim.dispose();
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
            Expanded(
              child: BlocBuilder<ReceptionBloc, ReceptionState>(
                builder: (context, state) {
                  if (state.fetchListStatus == AppStatus.loading) {
                    return const _LoadingBody();
                  }
                  if (state.fetchListStatus == AppStatus.error) {
                    return _ErrorBody(
                      isOffline: state.isOffline ?? false,
                      onRetry: () => context
                          .read<ReceptionBloc>()
                          .add(FetchReceptionList()),
                    );
                  }
                  if (state.fetchListStatus == AppStatus.success) {
                    if (state.receptions.isEmpty) {
                      return _EmptyBody(
                        onAdd: () => _openAddReception(context),
                      );
                    }
                    return _ReceptionList(receptions: state.receptions);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: _buildFab(context),
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
                  'Réceptions',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                BlocBuilder<ReceptionBloc, ReceptionState>(
                  builder: (context, state) {
                    if (state.fetchListStatus == AppStatus.success) {
                      return Text(
                        '${state.receptions.length} réception(s)',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<ReceptionBloc, ReceptionState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: state.fetchListStatus == AppStatus.loading
                    ? null
                    : () =>
                        context.read<ReceptionBloc>().add(FetchReceptionList()),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: state.fetchListStatus == AppStatus.loading
                      ? const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.refresh_rounded,
                          color: Colors.white, size: 20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () => _openAddReception(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF97316),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  void _openAddReception(BuildContext context) {
    final bloc = context.read<ReceptionBloc>();
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const AddReceptionScreen(),
          ),
        ))
        .then((_) => bloc.add(FetchReceptionList()));
  }
}

class _ReceptionList extends StatelessWidget {
  final List receptions;

  const _ReceptionList({required this.receptions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: receptions.length,
      itemBuilder: (context, index) {
        final reception = receptions[index];
        return ReceptionCard(reception: reception);
      },
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 5,
      itemBuilder: (_, __) => _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color.lerp(
            const Color(0xFFFFFFFF),
            const Color(0xFFE8EAF0),
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onRetry;

  const _ErrorBody({required this.isOffline, required this.onRetry});

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
                borderRadius: BorderRadius.circular(24),
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
                  ? 'Vérifiez votre connexion et réessayez.'
                  : 'Une erreur est survenue.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: const Color(0xFF9CA3AF), fontSize: 12),
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

class _EmptyBody extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyBody({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFFFE0B2)),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: Color(0xFFF97316), size: 46),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune réception',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre première réception\nen appuyant sur le bouton +',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: const Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(
              'Nouvelle réception',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
