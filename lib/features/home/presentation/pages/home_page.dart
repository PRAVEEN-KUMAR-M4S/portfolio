import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll <= 0) return;

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
      child: _HomePageContent(
        scrollController: _scrollController,
        scrollProgress: _scrollProgress,
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
            alignment: Alignment.centerLeft,
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
            padding: const EdgeInsets.only(top: 120, bottom: 56),
            child: Text(
              'a bucket full of ideas waiting to spill',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 18, color: AppColors.primary),
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Parallax for rocket: y drifts down, x drifts right and back
    final rocketY = scrollProgress * 200;
    final rocketXFactor = math.sin(scrollProgress * math.pi) * 150 - 50;

    return Padding(
      padding: EdgeInsets.only(
        left: isWide ? 24 : 24,
        right: isWide ? 24 : 24,
        top: isWide ? 0 : 96,
        bottom: isWide ? 0 : 40,
      ),
      child: isWide
          ? _WideHero(
              rocketY: rocketY,
              rocketX: rocketXFactor,
              scrollProgress: scrollProgress,
            )
          : _NarrowHero(
              rocketY: rocketY,
              rocketX: rocketXFactor,
              screenWidth: screenWidth,
            ),
    );
  }
}

class _WideHero extends StatelessWidget {
  const _WideHero({
    required this.rocketY,
    required this.rocketX,
    required this.scrollProgress,
  });

  final double rocketY;
  final double rocketX;
  final double scrollProgress;

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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: SizedBox(
                  height: screenHeight - 80,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 72),
                      child: _HeroText(isWide: true),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 90),
              SizedBox(
                width: bucketWidth,
                height: 600,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Rocket (parallax) ──────────────────────────────────
                    Positioned(
                      top: 140 + rocketY,
                      right: -60 + rocketX,
                      child: const _RocketWidget(),
                    ),

                    // ── Ring handle (top: bucketBodyTop - 23, left: 0) ─────
                    Positioned(
                      top: bucketBodyTop - 23,
                      left: 0,
                      child: Image.asset(
                        'assets/images/ringhandle.png',
                        width: bucketImgWidth,
                      ),
                    ),

                    // ── Startup card: left-24 → left:96, -top-40 → top:-160 ─
                    Positioned(
                      top: bucketBodyTop - 160,
                      left: 96,
                      child: _FloatingCard(
                        image: 'assets/images/startupdecoration.webp',
                        label: 'Start Up',
                        rotation: 7,
                        cardColor: AppColors.cardStartup,
                        shadowColor: const Color(0xFFCFA9B1),
                        onTap: () {},
                        width: 176,
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
            ],
          ),
        );
      },
    );
  }
}

class _NarrowHero extends StatelessWidget {
  const _NarrowHero({
    required this.rocketY,
    required this.rocketX,
    required this.screenWidth,
  });

  final double rocketY;
  final double rocketX;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroText(isWide: false),
        const SizedBox(height: 64),
        SizedBox(
          width: double.infinity,
          height: 400,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Rocket
              Positioned(
                top: 0 + rocketY * 0.3,
                right: 0 + rocketX * 0.3,
                child: const _RocketWidget(),
              ),
              // Floating cards
              Positioned(
                top: 20,
                left: 72,
                child: _FloatingCard(
                  image: 'assets/images/startupdecoration.webp',
                  label: 'Start Up',
                  rotation: 7,
                  cardColor: AppColors.cardStartup,
                  shadowColor: const Color(0xFFCFA9B1),
                  onTap: () {},
                  width: 120,
                ),
              ),
              Positioned(
                top: 80,
                left: 10,
                child: _FloatingCard(
                  image: 'assets/images/aboutme.webp',
                  label: 'about me',
                  rotation: -6,
                  cardColor: AppColors.cardAbout,
                  shadowColor: const Color(0xFFCCB57E),
                  onTap: () => GoRouter.of(context).go('/about'),
                  width: 140,
                ),
              ),
              Positioned(
                top: 140,
                left: 104,
                child: _FloatingCard(
                  image: 'assets/images/workimage.webp',
                  label: 'works',
                  rotation: 7,
                  cardColor: AppColors.cardWork,
                  shadowColor: const Color(0xFFB0AFAE),
                  onTap: () => GoRouter.of(context).go('/work'),
                  width: 130,
                ),
              ),
              // Ring handle
              Positioned(
                top: -23,
                left: 0,
                child: Image.asset('assets/images/ringhandle.png', width: 256),
              ),
              // Bucket
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('assets/images/bucket.webp', width: 256),
              ),
              // Bucket ring
              Positioned(
                right: 0,
                top: 0,
                child: Image.asset('assets/images/bucketring.webp', width: 312),
              ),
            ],
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
          'hello, I am',
          style: GoogleFonts.dmSans(
            fontSize: isWide ? 22 : 16,
            fontWeight: FontWeight.w200,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Shahil',
          style: GoogleFonts.nanumPenScript(
            fontSize: isWide ? 120 : 72,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: isWide ? 500 : double.infinity,
          child: Text(
            'a builder who loves to build and create amazing products that makes a difference.',
            style: GoogleFonts.dmSans(
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
                        style: GoogleFonts.nanumPenScript(
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

class _RocketWidget extends StatelessWidget {
  const _RocketWidget();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/rocket.svg', width: 64, height: 64);
  }
}
