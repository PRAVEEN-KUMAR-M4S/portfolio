import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/navigation_cubit.dart';
import '../../app/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;
    if (!isWide) return const SizedBox.shrink();

    return BlocBuilder<NavigationCubit, String>(
      builder: (context, currentRoute) {
        return SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Text(
                    'Shahil.co',
                    style: GoogleFonts.nanumPenScript(
                      fontSize: 32,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _NavLink(
                      label: 'work',
                      route: '/work',
                      currentRoute: currentRoute,
                    ),
                    const SizedBox(width: 40),
                    _NavLink(
                      label: 'about me',
                      route: '/about',
                      currentRoute: currentRoute,
                    ),
                    const SizedBox(width: 40),
                    _NavLink(
                      label: 'startup',
                      route: 'http://flaro.co',
                      currentRoute: currentRoute,
                      isExternal: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.route,
    required this.currentRoute,
    this.isExternal = false,
  });

  final String label;
  final String route;
  final String currentRoute;
  final bool isExternal;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = !widget.isExternal && widget.currentRoute == widget.route;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (!widget.isExternal) {
            context.go(widget.route);
          }
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.nanumPenScript(
            fontSize: 28,
            color: (isActive || _hovered)
                ? AppColors.primary
                : AppColors.secondary,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
