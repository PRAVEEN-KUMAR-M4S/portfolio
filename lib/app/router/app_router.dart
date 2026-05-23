import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/skills/presentation/pages/skills_page.dart';
import '../../features/work/presentation/pages/work_page.dart';
import '../../shared/state/navigation_cubit.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/widgets/app_footer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _PortfolioShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              context.read<NavigationCubit>().navigateTo('/');
              return const HomePage();
            },
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) {
              context.read<NavigationCubit>().navigateTo('/about');
              return const AboutPage();
            },
          ),
          GoRoute(
            path: '/skills',
            builder: (context, state) {
              context.read<NavigationCubit>().navigateTo('/skills');
              return const SkillsPage();
            },
          ),
          GoRoute(
            path: '/work',
            builder: (context, state) {
              context.read<NavigationCubit>().navigateTo('/work');
              return const WorkPage();
            },
          ),
        ],
      ),
    ],
  );
}

class _PortfolioShell extends StatelessWidget {
  const _PortfolioShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/paper.webp'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          children: [
            const AppHeader(),
            Expanded(child: child),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
