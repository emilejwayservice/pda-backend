import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pda/core/constants/app_images.dart';
import 'package:pda/core/utils/logout.dart';
import 'package:pda/core/utils/show_dialogue_question.dart';

import '../../../../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<Animation<double>> _tileAnimations;

  static const Color _orange = Color(0xFFE87722);
  static const Color _bgColor = Color(0xFFF4F6FA);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMuted = Color(0xFF9099B0);

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      name: "Ventes Direct",
      image: AppImages.ic_ventes,
      route: Routes.ventes,
      color: Color(0xFFE87722),
      spanX: 2,
      spanY: 1,
      icon: Icons.point_of_sale_rounded,
    ),
    _MenuItem(
      name: "Réception",
      image: AppImages.ic_warehouse,
      route: Routes.reception,
      color: Color(0xFF6C63FF),
      spanX: 1,
      spanY: 1,
      icon: Icons.inventory_2_rounded,
    ),
    _MenuItem(
      name: "Chargements",
      image: AppImages.ic_chargement,
      route: Routes.chargement,
      color: Color(0xFF00B4D8),
      spanX: 1,
      spanY: 1,
      icon: Icons.local_shipping_rounded,
    ),
    _MenuItem(
      name: "Livraison",
      image: AppImages.ic_delivry,
      route: Routes.livraison,
      color: Color(0xFF2EC4B6),
      spanX: 2,
      spanY: 1,
      icon: Icons.delivery_dining_rounded,
    ),
    _MenuItem(
      name: "Pre Commandes",
      image: AppImages.ic_shoping_cart,
      route: Routes.preCommand,
      color: Color(0xFFE87722),
      spanX: 1,
      spanY: 2,
      icon: Icons.shopping_cart_rounded,
    ),
    _MenuItem(
      name: "Clients",
      image: AppImages.ic_users,
      route: Routes.clients,
      color: Color(0xFF457B9D),
      spanX: 1,
      spanY: 1,
      icon: Icons.people_rounded,
    ),
    _MenuItem(
      name: "Stock",
      image: AppImages.ic_warehouse,
      route: Routes.stock,
      color: Color(0xFF2D9C6A),
      spanX: 1,
      spanY: 1,
      icon: Icons.warehouse_rounded,
    ),
    _MenuItem(
      name: "Retour",
      image: AppImages.ic_retour,
      route: Routes.retour,
      color: Color(0xFFE63946),
      spanX: 1,
      spanY: 1,
      icon: Icons.assignment_return_rounded,
    ),
    _MenuItem(
      name: "Historique",
      image: AppImages.ic_historique,
      route: Routes.livraisonHistorique,
      color: Color(0xFF9B5DE5),
      spanX: 2,
      spanY: 1,
      icon: Icons.history_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _tileAnimations = List.generate(_menuItems.length, (i) {
      final start = (i * 0.07).clamp(0.0, 0.7);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );
    });
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(),
                  _buildGrid(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _orange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33E87722),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            children: [
              Image.asset(AppImages.app_logo, height: 40),
              const Spacer(),
              Text(
                "Tableau de bord",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onLogout,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bonjour 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Que souhaitez-vous faire ?",
            style: TextStyle(
              fontSize: 13,
              color: _textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: StaggeredGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(_menuItems.length, (index) {
          final item = _menuItems[index];
          return StaggeredGridTile.count(
            crossAxisCellCount: item.spanX,
            mainAxisCellCount: item.spanY,
            child: AnimatedBuilder(
              animation: _tileAnimations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _tileAnimations[index].value,
                  child: Opacity(
                    opacity: _tileAnimations[index].value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: _buildTile(item),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTile(_MenuItem item) {
    return GestureDetector(
      onTap: () => navigate(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                right: -16,
                top: -16,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color.withOpacity(0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: item.spanX >= 2
                    ? _buildHorizontalContent(item)
                    : _buildVerticalContent(item),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalContent(_MenuItem item) {
    return Row(
      children: [
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Image.asset(item.image, width: 28, height: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.name,
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: -0.2,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: item.color.withOpacity(0.5),
          size: 13,
        ),
      ],
    );
  }

  Widget _buildVerticalContent(_MenuItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(item.image, width: 24, height: 24),
        ),
        const Spacer(),
        Text(
          item.name,
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: -0.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void navigate(String route) {
    if (route.isEmpty) {
      Fluttertoast.showToast(
        msg: "En développement",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: _orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    GoRouter.of(context).push(route);
  }

  void onLogout() async {
    var result = await showDialogueQuestion(
      context,
      "Voulez-vous vraiment vous déconnecter ?",
      "Oui",
      "Non",
    );
    if (result != null && result) {
      logout(context);
    }
  }
}

class _MenuItem {
  final String name;
  final String image;
  final String route;
  final Color color;
  final int spanX;
  final int spanY;
  final IconData icon;

  _MenuItem({
    required this.name,
    required this.image,
    required this.route,
    required this.color,
    required this.spanX,
    required this.spanY,
    required this.icon,
  });
}
