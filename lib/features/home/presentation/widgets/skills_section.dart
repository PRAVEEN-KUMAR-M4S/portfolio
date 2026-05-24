import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/portfolio_service.dart';
import '../../state/skills_animation_cubit.dart';

const double _cardWidth = 200.0;
const double _cardGap = 250.0; // col spacing
const double _rowGap = 250.0; // row spacing
const int _cols = 3;

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final GlobalKey _sectionKey = GlobalKey();
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

    final viewportHeight = widget.scrollController.position.viewportDimension;
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
      final lastEnd = 0.2 + 0.2 + (PortfolioService.info.skills.length - 1) * 0.05;
      if (progress >= lastEnd && !_animationDone) {
        _animationDone = true;
        context.read<SkillsAnimationCubit>().markDone();
      }
    });
  }

  double get _bucketRotation {
    if (_animationDone) return 0;
    if (_sectionProgress < 0.1) return 0;
    if (_sectionProgress > 0.2) return -60 * (math.pi / 180);
    final t = (_sectionProgress - 0.1) / 0.1;
    return -60 * t * (math.pi / 180);
  }

  /// All positions are in Stack-local coordinates.
  /// [contentWidth] = section width − 2×112 (horizontal padding)
  /// Grid is centered inside that content area.
  ///
  /// Grid total width  = cols*cardWidth + (cols-1)*gap_between
  ///   gap_between = cardGap - cardWidth = 250 - 200 = 50px between cards
  ///   total = 3*200 + 2*50 = 700px
  /// centerOffset = (contentWidth - 700) / 2  → shifts grid to center
  ///
  /// Bucket sits at right side of content, x ≈ contentWidth - 176 (half of 352)
  (double, double, double) _itemTransform(int index, double sectionWidth) {
    const double hPad = 112.0;
    final double contentWidth = sectionWidth - 2 * hPad;

    // Grid geometry
    const double gridWidth =
        _cols * _cardWidth + (_cols - 1) * (_cardGap - _cardWidth);
    // = 3*200 + 2*50 = 700
    final double gridLeft = hPad + (contentWidth - gridWidth) / 2;

    // Final resting positions (Stack-local)
    final double finalX = gridLeft + (index % _cols) * _cardGap;
    // Cards sit below the 700px header + 16px top padding
    // Row 0: top of grid area; Row 1: +rowGap
    const double cardsTopY =
        716.0 + 40.0; // header(700) + py(16) + breathing room
    final double finalY = cardsTopY + (index ~/ _cols) * _rowGap;

    if (_animationDone) return (finalX, finalY, 0);

    // Bucket mouth position in Stack-local coords
    // Bucket is at the right of the content row, width 352, so its left edge:
    final double bucketLeft = hPad + contentWidth - 352.0;
    // Bucket mouth center-x ≈ bucketLeft + 176
    final double bucketMouthX = bucketLeft + 176.0 - _cardWidth / 2;
    // Bucket mouth y ≈ vertical center of 700px header (350) - some offset for mouth
    const double bucketMouthY = 280.0;

    const tiltStart = 0.1;
    const tiltEnd = 0.2;
    const fallStart = 0.2;
    final fallEnd = fallStart + 0.2 + index * 0.05;

    final p = _sectionProgress;

    if (p < tiltStart) {
      // Hidden inside bucket — stacked with tiny offset per card
      return (bucketMouthX, bucketMouthY - index * 6.0, 0);
    } else if (p <= tiltEnd) {
      // Bucket tilting — cards tilt with it
      final t = (p - tiltStart) / (tiltEnd - tiltStart);
      final r = -60 * t * (math.pi / 180);
      return (bucketMouthX, bucketMouthY - index * 6.0, r);
    } else if (p < fallEnd) {
      // Cards fly from bucket mouth to final grid positions
      final t = (p - fallStart) / (fallEnd - fallStart);
      final ease = 1 - math.pow(1 - t, 2).toDouble(); // ease-out
      final x = bucketMouthX + (finalX - bucketMouthX) * ease;
      final y =
          (bucketMouthY - index * 6.0) +
          (finalY - (bucketMouthY - index * 6.0)) * ease;
      final r = -60 * (1 - t) * (math.pi / 180);
      return (x, y, r);
    } else {
      return (finalX, finalY, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionWidth = constraints.maxWidth;

        return Container(
          key: _sectionKey,
          width: double.infinity,
          constraints: BoxConstraints(minHeight: isWide ? 1400 : 600),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Background — clipped to this section ──────────────────
              Positioned.fill(
                child: ClipRect(
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
              ),

              // ── Header row ────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 112.0 : 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isWide ? 700 : 350,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title + subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Skills',
                                    style: TextStyle(
                                      fontFamily: 'Nanum Pen Script',
                                      fontSize: isWide ? 96 : 60,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    'assets/images/underline.svg',
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: isWide ? 320 : 200,
                                child: Text(
                                  PortfolioService.info.skillsSubtitle,
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontSize: isWide ? 22 : 16,
                                    color: const Color(0xFF374151),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Animated bucket
                          if (isWide)
                            Transform.rotate(
                              angle: _bucketRotation,
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 352,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // ── Spark/shine lines: -top-[160px] left-[260px] ──
                                    Positioned(
                                      top: -160,
                                      left: 260,
                                      child: SizedBox(
                                        width: 100,
                                        height: 108,
                                        child: CustomPaint(
                                          painter: _SparkPainter(),
                                        ),
                                      ),
                                    ),

                                    // ── Ring handle ──────────────────────────────────
                                    Image.asset(
                                      'assets/images/ringhandle.png',
                                      width: 352,
                                    ),

                                    // ── Bucket body ──────────────────────────────────
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Image.asset(
                                        'assets/images/bucket.webp',
                                        width: 352,
                                      ),
                                    ),

                                    // ── Bucket bottom decoration: max-w-24 = 96px ─────
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Image.asset(
                                        'assets/images/bucketbottom.webp',
                                        width: 96,
                                      ),
                                    ),

                                    // ── Squiggle: bottom-8(32px) -left-10(-40px) ──────
                                    Positioned(
                                      bottom: 32,
                                      left: -40,
                                      child: SizedBox(
                                        width: 48,
                                        height: 30,
                                        child: CustomPaint(
                                          painter: _SquigglePainter(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (!isWide) _buildSimpleGrid(),
                  ],
                ),
              ),

              // ── Animated skill cards ──────────────────────────────────
              if (isWide)
                ...PortfolioService.info.skills.asMap().entries.map((entry) {
                  final index = entry.key;
                  final skill = entry.value;
                  final (x, y, rot) = _itemTransform(index, sectionWidth);

                  return Positioned(
                    left: x,
                    top: y,
                    child: Transform.rotate(
                      angle: rot,
                      child: _SkillCard(
                        name: skill.name,
                        icon: skill.icon,
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: PortfolioService.info.skills
            .map((s) => _SkillCard(name: s.name, icon: s.icon))
            .toList(),
      ),
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
      width: _cardWidth,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: SvgPicture.asset(
              icon,
              width: _cardWidth - 32,
              height: _cardWidth - 32,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nanum Pen Script',
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

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFAAAAAA).withOpacity(0.8)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(24.184, 2.678)
      ..cubicTo(18.875, 18.329, 7.248, 51.68, 3.211, 59.871);

    final path2 = Path()
      ..moveTo(36.656, 74.899)
      ..cubicTo(46.313, 64.225, 67.531, 41.925, 75.144, 38.112);

    final path3 = Path()
      ..moveTo(53.314, 100.678)
      ..cubicTo(61.175, 98.565, 80.16, 93.94, 93.211, 92.344);

    final scaleX = size.width / 96;
    final scaleY = size.height / 104;
    final matrix = Matrix4.diagonal3Values(scaleX, scaleY, 1);
    canvas.transform(matrix.storage);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SquigglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF999999)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(4.235, 16.614)
      ..cubicTo(0.827, 16.921, 5.389, 20.118, 6.927, 20.329)
      ..cubicTo(10.768, 20.858, 16.148, 20.694, 20.037, 20.245)
      ..cubicTo(28.597, 19.257, 32.378, 10.099, 29.284, 4.62)
      ..cubicTo(25.514, -2.058, 9.555, 13.671, 15.238, 19.823)
      ..cubicTo(19.267, 24.183, 34.394, 23.737, 39.0, 20.414);

    final scaleX = size.width / 42;
    final scaleY = size.height / 26;
    final matrix = Matrix4.diagonal3Values(scaleX, scaleY, 1);
    canvas.transform(matrix.storage);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
