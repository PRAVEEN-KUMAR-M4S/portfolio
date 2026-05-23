import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../state/skills_animation_cubit.dart';

const _skills = [
  {'name': 'React JS', 'icon': 'assets/images/react.svg'},
  {'name': 'Postgres Sql', 'icon': 'assets/images/postgres.svg'},
  {'name': 'Tailwind Css', 'icon': 'assets/images/tailwindcss.svg'},
  {'name': 'Github', 'icon': 'assets/images/github.svg'},
  {'name': 'Node Js', 'icon': 'assets/images/node.svg'},
  {'name': 'Angular', 'icon': 'assets/images/angular.svg'},
];

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final GlobalKey _sectionKey = GlobalKey();

  // Track bucket tilt and per-item animation progress
  double _sectionProgress = 0.0;
  bool _animationDone = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final renderBox =
        _sectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportHeight =
        widget.scrollController.position.viewportDimension;
    final sectionOffset = renderBox.localToGlobal(Offset.zero);
    final sectionHeight = renderBox.size.height;
    if (sectionHeight <= 0) return;

    final progress =
        ((viewportHeight / 2 - sectionOffset.dy) /
                (sectionHeight - viewportHeight / 2))
            .clamp(0.0, 1.0);

    if (!mounted) return;
    setState(() {
      _sectionProgress = progress;
      final lastEnd = 0.2 + 0.2 + (_skills.length - 1) * 0.05;
      if (progress >= lastEnd && !_animationDone) {
        _animationDone = true;
        context.read<SkillsAnimationCubit>().markDone();
      }
    });
  }

  /// Bucket tilts from 0 -> -60 deg between progress 0.1..0.2
  double get _bucketRotation {
    if (_animationDone) return 0;
    if (_sectionProgress < 0.1) return 0;
    if (_sectionProgress > 0.2) return -60 * (math.pi / 180);
    final t = (_sectionProgress - 0.1) / 0.1;
    return -60 * t * (math.pi / 180);
  }

  /// Returns (x, y, rotation) for the i-th skill item
  (double, double, double) _itemTransform(int index) {
    final finalX = 150.0 + (index % 3) * 200.0;
    final finalY = -50.0 + (index ~/ 3) * 200.0;

    if (_animationDone) return (finalX, finalY, 0);

    const bucketX = 580.0;
    const bucketY = -380.0;
    const fallStartX = bucketX - 80;
    const fallStartY = bucketY + 50;

    const tiltStart = 0.1;
    const tiltEnd = 0.2;
    const fallStart = 0.2;
    final fallEnd = fallStart + 0.2 + index * 0.05;

    final p = _sectionProgress;

    if (p < tiltStart) {
      return (bucketX, bucketY + index * 40, 0);
    } else if (p <= tiltEnd) {
      final t = (p - tiltStart) / (tiltEnd - tiltStart);
      final x = bucketX + (fallStartX - bucketX) * t;
      final y =
          (bucketY + index * 40) + (fallStartY - (bucketY + index * 40)) * t;
      final r = -60 * t * (math.pi / 180);
      return (x, y, r);
    } else if (p < fallEnd) {
      final t = (p - fallStart) / (fallEnd - fallStart);
      final x = fallStartX + (finalX - fallStartX) * t;
      final y = fallStartY + (finalY - fallStartY) * t;
      final r = -60 * (1 - t) * (math.pi / 180);
      return (x, y, r);
    } else {
      return (finalX, finalY, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isWide ? 900 : 500),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Paper boxes background
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/boxes.webp',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
                alignment: Alignment.topLeft,
                filterQuality: FilterQuality.low,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 112 : 16,
              vertical: 16,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: isWide ? 700 : 350,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          Text(
                            'Skills',
                            style: GoogleFonts.nanumPenScript(
                              fontSize: isWide ? 96 : 60,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? 320 : 200,
                            child: Text(
                              'skills mean nothing until they build something real.',
                              style: GoogleFonts.dmSans(
                                fontSize: isWide ? 22 : 16,
                                color: const Color(0xFF374151),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Right: bucket (only wide)
                      if (isWide)
                        Transform.rotate(
                          angle: _bucketRotation,
                          child: SizedBox(
                            width: 220,
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/ringhandle.png',
                                  width: 220,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Image.asset(
                                    'assets/images/bucket.webp',
                                    width: 220,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Skill item grid - on small screens show plain grid
                if (!isWide) _buildSimpleGrid(),
              ],
            ),
          ),
          // Animated skill items (only wide)
          if (isWide)
            ..._skills.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;
              final (x, y, rot) = _itemTransform(index);

              return Positioned(
                left: x,
                top: y + 60,
                child: Transform.rotate(
                  angle: rot,
                  child: _SkillCard(
                    name: skill['name']!,
                    icon: skill['icon']!,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSimpleGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _skills
          .map((skill) => _SkillCard(
                name: skill['name']!,
                icon: skill['icon']!,
              ))
          .toList(),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.name, required this.icon});
  final String name;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1), width: 2),
            ),
            child: SvgPicture.asset(
              icon,
              width: 144,
              height: 144,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.nanumPenScript(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
