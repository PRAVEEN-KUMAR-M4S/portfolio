import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/portfolio_service.dart';
import 'package:personal_portfolio_paper_flutter/shared/widgets/app_footer.dart';
import '../../../../app/theme/app_colors.dart';
import '../../state/skills_animation_cubit.dart';
import '../widgets/skills_section.dart';
import '../widgets/work_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  double _scrollProgress = 0;
  double _scrollVelocity = 0;
  double _lastScrollPixels = 0;
  DateTime _lastScrollTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll <= 0) return;

    final now = DateTime.now();
    final dt = now.difference(_lastScrollTime).inMilliseconds / 1000.0;
    if (dt > 0) {
      _scrollVelocity = (current - _lastScrollPixels) / dt;
    }
    _lastScrollPixels = current;
    _lastScrollTime = now;

    setState(() {
      _scrollProgress = (current / maxScroll).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SkillsAnimationCubit(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HomePageContent(
            scrollController: _scrollController,
            scrollProgress: _scrollProgress,
          ),
          _FixedRocket(
            scrollProgress: _scrollProgress,
            scrollVelocity: _scrollVelocity,
          ),
        ],
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({
    required this.scrollController,
    required this.scrollProgress,
  });

  final ScrollController scrollController;
  final double scrollProgress;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _HeroSection(scrollProgress: scrollProgress),
          const Divider(height: 2, thickness: 2, color: Color(0x44CCCCCC)),
          const WorkSection(),
          SkillsSection(scrollController: scrollController),
          const SizedBox(height: 80),
          const Divider(height: 2, thickness: 2, color: Color(0x44CCCCCC)),
          // Vertical line
          Image.asset(
            'assets/images/line.png',
            width: 2,
            height: 300,
            fit: BoxFit.cover,
          ),
          // Footer bucket
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: SizedBox(
                width: 200,
                child: Image.asset(
                  'assets/images/footerbucket.webp',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 56),
            child: Text(
              PortfolioService.info.bucketQuote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.scrollProgress});
  final double scrollProgress;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Padding(
      padding: EdgeInsets.only(
        left: isWide ? 24 : 24,
        right: isWide ? 24 : 24,
        top: isWide ? 0 : 96,
        bottom: isWide ? 0 : 40,
      ),
      child: isWide ? const _WideHero() : const _NarrowHero(),
    );
  }
}

class _WideHero extends StatelessWidget {
  const _WideHero();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final bucketWidth = (availableWidth * 0.50).clamp(280.0, 500.0);

        // Match React: bucket at top:0 left:0, all cards/ring relative to that
        // We use bucketBodyTop as the Y anchor for bucket body inside the Stack
        const double bucketBodyTop =
            200.0; // vertical center within the 540h box (increased from 160)
        const double bucketImgWidth = 352.0; // lg:max-w-[22rem]
        const double bucketRingWidth = 416.0; // lg:max-w-[26rem]

        return SizedBox(
          height: screenHeight - 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 72),
                    child: _HeroText(isWide: true),
                  ),
                ),
              ),
              const SizedBox(width: 90),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: bucketWidth,
                  height: 600,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ── Ring handle (top: bucketBodyTop - 23, left: 0) ─────
                      Positioned(
                        top: bucketBodyTop - 23,
                        left: 0,
                        child: Image.asset(
                          'assets/images/ringhandle.png',
                          width: bucketImgWidth,
                        ),
                      ),

                      // ── About me card: left:10, -top-25 → top:-100 ─────────
                      Positioned(
                        top: bucketBodyTop - 100,
                        left: 10,
                        child: _FloatingCard(
                          image: 'assets/images/aboutme.webp',
                          label: 'about me',
                          rotation: -6,
                          cardColor: AppColors.cardAbout,
                          shadowColor: const Color(0xFFCCB57E),
                          onTap: () => GoRouter.of(context).go('/about'),
                          width: 176,
                        ),
                      ),

                      // ── Works card: left-38 → left:152, -top-20 → top:-80 ──
                      Positioned(
                        top: bucketBodyTop - 80,
                        left: 152,
                        child: _FloatingCard(
                          image: 'assets/images/workimage.webp',
                          label: 'works',
                          rotation: 7,
                          cardColor: AppColors.cardWork,
                          shadowColor: const Color(0xFFB0AFAE),
                          onTap: () => GoRouter.of(context).go('/work'),
                          width: 176,
                        ),
                      ),

                      // ── Bucket body: top:bucketBodyTop, left:0 ─────────────
                      Positioned(
                        top: bucketBodyTop,
                        left: 0,
                        child: Image.asset(
                          'assets/images/bucket.webp',
                          width: bucketImgWidth,
                        ),
                      ),

                      // ── Bucket ring: right:2, top:bucketBodyTop ────────────
                      Positioned(
                        top: bucketBodyTop,
                        left: 0,
                        child: Image.asset(
                          'assets/images/bucketring.webp',
                          width: bucketRingWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NarrowHero extends StatelessWidget {
  const _NarrowHero();

  @override
  Widget build(BuildContext context) {
    const double bucketBodyTop = 144.0;
    const double bucketImgWidth = 253.0;
    const double bucketRingWidth = 300.0;
    const double cardWidth = 127.0;

    return Column(
      children: [
        _HeroText(isWide: false),
        const SizedBox(height: 48),
        Center(
          child: SizedBox(
            width: bucketRingWidth,
            height: 432,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Ring handle ─────────────────────────────
                Positioned(
                  top: bucketBodyTop - 17,
                  left: 0,
                  child: Image.asset(
                    'assets/images/ringhandle.png',
                    width: bucketImgWidth,
                  ),
                ),
                // ── About me card ─────────────────────────────
                Positioned(
                  top: 72,
                  left: 7,
                  child: _FloatingCard(
                    image: 'assets/images/aboutme.webp',
                    label: 'about me',
                    rotation: -6,
                    cardColor: AppColors.cardAbout,
                    shadowColor: const Color(0xFFCCB57E),
                    onTap: () => GoRouter.of(context).go('/about'),
                    width: cardWidth,
                  ),
                ),
                // ── Works card ────────────────────────────────
                Positioned(
                  top: 86,
                  left: 109,
                  child: _FloatingCard(
                    image: 'assets/images/workimage.webp',
                    label: 'works',
                    rotation: 7,
                    cardColor: AppColors.cardWork,
                    shadowColor: const Color(0xFFB0AFAE),
                    onTap: () => GoRouter.of(context).go('/work'),
                    width: cardWidth,
                  ),
                ),
                // ── Bucket body ──────────────────────────────
                Positioned(
                  top: bucketBodyTop,
                  left: 0,
                  child: Image.asset(
                    'assets/images/bucket.webp',
                    width: bucketImgWidth,
                  ),
                ),
                // ── Bucket ring ──────────────────────────────
                Positioned(
                  top: bucketBodyTop,
                  left: 0,
                  child: Image.asset(
                    'assets/images/bucketring.webp',
                    width: bucketRingWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioService.info.greeting,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: isWide ? 22 : 16,
            fontWeight: FontWeight.w200,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          PortfolioService.info.name,
          style: TextStyle(
            fontFamily: 'Nanum Pen Script',
            fontSize: isWide ? 120 : 72,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: isWide ? 500 : double.infinity,
          child: Text(
            PortfolioService.info.tagline,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: isWide ? 22 : 16,
              fontWeight: isWide ? FontWeight.w300 : FontWeight.w200,
              color: const Color(0xFF484848),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingCard extends StatefulWidget {
  const _FloatingCard({
    required this.image,
    required this.label,
    required this.rotation,
    required this.cardColor,
    required this.shadowColor,
    required this.onTap,
    this.width = 176,
  });

  final String image;
  final String label;
  final double rotation;
  final Color cardColor;
  final Color shadowColor;
  final VoidCallback onTap;
  final double width;

  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, _hovered ? -10.0 : 0.0),
          child: Transform.rotate(
            angle: widget.rotation * math.pi / 180,
            child: SizedBox(
              width: widget.width,
              child: Stack(
                children: [
                  Image.asset(widget.image, width: widget.width),
                  Positioned(
                    top: 20,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: widget.shadowColor,
                            offset: const Offset(1, 1),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: 'Nanum Pen Script',
                          fontSize: 18,
                          color: const Color(0xFF696969),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FixedRocket extends StatefulWidget {
  const _FixedRocket({
    required this.scrollProgress,
    required this.scrollVelocity,
  });
  final double scrollProgress;
  final double scrollVelocity;

  @override
  State<_FixedRocket> createState() => _FixedRocketState();
}

class _FixedRocketState extends State<_FixedRocket>
    with SingleTickerProviderStateMixin {
  double _displayX = -50;
  double _displayY = 0;
  double _displayRotate = 0;

  double _velX = 0;
  double _velY = 0;
  double _velR = 0;

  late final Ticker _ticker;
  Duration? _lastTime;

  static const double _stiffnessXY = 100;
  static const double _dampingXY = 30;
  static const double _stiffnessR = 400;
  static const double _dampingR = 30;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_lastTime == null) {
      _lastTime = elapsed;
      return;
    }
    final dt = (elapsed - _lastTime!).inMilliseconds / 1000.0;
    _lastTime = elapsed;
    if (dt <= 0 || dt > 0.1) return;

    final targetY = widget.scrollProgress * 250;
    final targetX = _lerpX(widget.scrollProgress);
    final targetRotate = (widget.scrollVelocity / 1000.0 * 25).clamp(
      -25.0,
      25.0,
    );

    _velX += (-_stiffnessXY * (_displayX - targetX) - _dampingXY * _velX) * dt;
    _velY += (-_stiffnessXY * (_displayY - targetY) - _dampingXY * _velY) * dt;
    _velR +=
        (-_stiffnessR * (_displayRotate - targetRotate) - _dampingR * _velR) *
        dt;

    setState(() {
      _displayX += _velX * dt;
      _displayY += _velY * dt;
      _displayRotate += _velR * dt;
    });
  }

  double _lerpX(double t) {
    if (t <= 0.5) return -50 + (250 - (-50)) * (t / 0.5);
    return 250 + (-50 - 250) * ((t - 0.5) / 0.5);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 1024;

    final double anchorTop = isWide ? 160.0 : 100.0;
    final double anchorLeft = isWide ? 350.0 : 60.0;
    final double rocketSize = isWide ? 64.0 : 48.0;

    return Positioned(
      top: anchorTop + _displayY,
      left: anchorLeft + _displayX,
      child: Transform.rotate(
        angle: _displayRotate * math.pi / 180,
        child: SvgPicture.asset(
          'assets/images/rocket.svg',
          width: rocketSize,
          height: rocketSize,
        ),
      ),
    );
  }
}
