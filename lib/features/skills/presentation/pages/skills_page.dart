import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/state/skills_animation_cubit.dart';
import '../../../home/presentation/widgets/skills_section.dart';
import '../../../../shared/widgets/smooth_scroll.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SkillsAnimationCubit(),
      child: SmoothScrollView(
        controller: _scrollController,
        child: SkillsSection(scrollController: _scrollController),
      ),
    );
  }
}
