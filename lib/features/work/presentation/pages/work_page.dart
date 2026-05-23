import 'package:flutter/material.dart';
import '../../../home/presentation/widgets/work_section.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: WorkSection(),
    );
  }
}
