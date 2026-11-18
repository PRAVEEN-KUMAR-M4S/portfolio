import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/router/app_router.dart';
import '../app/theme/app_theme.dart';
import '../shared/state/navigation_cubit.dart';
import '../shared/widgets/smooth_scroll.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => NavigationCubit())],
      child: MaterialApp.router(
        title: 'Praveen Kumar | Portfolio',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        scrollBehavior: const AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
