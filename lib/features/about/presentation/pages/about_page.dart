import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/portfolio_service.dart';
import '../../../../shared/widgets/smooth_scroll.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color _ink = Color(0xFF6F6A5E);
  static const Color _inkSoft = Color(0xFF857E6D);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return SmoothScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 16,
              vertical: isWide ? 44 : 20,
            ),
            child: _PaperSheet(
              isWide: isWide,
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PortraitStack(size: 268),
                        const SizedBox(width: 52),
                        Expanded(child: _AboutBody(isWide: true)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: _PortraitStack(size: 186)),
                        const SizedBox(height: 28),
                        _AboutBody(isWide: false),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The yellow paper sheet the whole about story is written on.
class _PaperSheet extends StatelessWidget {
  const _PaperSheet({required this.child, required this.isWide});

  final Widget child;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardAbout,
        image: const DecorationImage(
          image: AssetImage('assets/images/yellowabout_bg.webp'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        isWide ? 76 : 26,
        isWide ? 52 : 30,
        isWide ? 60 : 26,
        isWide ? 52 : 30,
      ),
      child: child,
    );
  }
}

/// Photo taped onto the sheet: white print border, two paper tapes, and a
/// caption. Falls back to initials instead of an empty box if the image can
/// not be decoded.
class _PortraitStack extends StatelessWidget {
  const _PortraitStack({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final name = PortfolioService.info.name;
    final initials = name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size + 24,
          height: size + 20,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.rotate(
                angle: -0.035,
                child: Container(
                  width: size,
                  height: size,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(5, 9),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: Color(0xFFE7DCC0)),
                        Image.asset(
                          'assets/images/praveen_about.webp',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          frameBuilder: (context, child, frame, wasSynced) {
                            if (wasSynced) return child;
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                          errorBuilder: (context, error, stack) => Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: size * 0.34,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Paper tape, top-left and bottom-right.
              Positioned(
                top: -12,
                left: -16,
                child: _Tape(width: 82, angle: 0.42),
              ),
              Positioned(
                bottom: -10,
                right: -14,
                child: _Tape(width: 72, angle: -0.46),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Transform.rotate(
          angle: -0.05,
          child: const Text(
            'that\'s me',
            style: TextStyle(
              fontFamily: 'Nanum Pen Script',
              fontSize: 24,
              color: AppColors.territory,
            ),
          ),
        ),
      ],
    );
  }
}

class _Tape extends StatelessWidget {
  const _Tape({required this.width, required this.angle});

  final double width;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: 22,
        decoration: BoxDecoration(
          color: const Color(0xD9F6EDCE),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutBody extends StatelessWidget {
  const _AboutBody({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final info = PortfolioService.info;
    final about = info.about;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'about me',
              style: const TextStyle(
                fontFamily: 'Nanum Pen Script',
                fontSize: 28,
                height: 1.1,
                color: AppColors.territory,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          info.name,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: isWide ? 42 : 32,
            height: 1.1,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          info.tagline,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w500,
            color: AboutPage._ink,
          ),
        ),
        const SizedBox(height: 22),
        _StatsRow(),
        const SizedBox(height: 24),
        Text(
          about.intro,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 14.5,
            height: 1.8,
            color: AboutPage._ink,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            border: const Border(
              left: BorderSide(color: AppColors.territory, width: 3),
            ),
          ),
          child: Text(
            about.highlight,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          about.bio,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 13.5,
            height: 1.9,
            color: AboutPage._inkSoft,
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'toolbox',
          style: TextStyle(
            fontFamily: 'Nanum Pen Script',
            fontSize: 22,
            color: AppColors.territory,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in info.skills) _ToolChip(label: skill.name),
          ],
        ),
        const SizedBox(height: 26),
        Container(height: 1, color: Colors.black.withValues(alpha: 0.10)),
        const SizedBox(height: 18),
        const Text(
          'say hello',
          style: TextStyle(
            fontFamily: 'Nanum Pen Script',
            fontSize: 22,
            color: AppColors.territory,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SocialLink(
              asset: 'assets/images/linkedin.webp',
              label: 'LinkedIn',
              url: info.social.linkedin,
            ),
            _SocialLink(
              asset: 'assets/images/github.svg',
              label: 'GitHub',
              url: info.social.github,
            ),
            _SocialLink(
              asset: 'assets/images/twitter.webp',
              label: 'X',
              url: info.social.twitter,
            ),
            _SocialLink(
              asset: 'assets/images/instagram.webp',
              label: 'Instagram',
              url: info.social.instagram,
            ),
          ],
        ),
      ],
    );
  }
}

/// Numbers pulled straight from the portfolio data, so nothing has to be
/// kept in sync by hand.
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = PortfolioService.info;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Stat(value: '${info.projects.length}', label: 'projects'),
        _Stat(value: '${info.skills.length}', label: 'technologies'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        border: Border.all(
          color: const Color(0xFFC7A763).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 12,
              letterSpacing: 0.3,
              color: AboutPage._ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink({
    required this.asset,
    required this.label,
    required this.url,
  });

  final String asset;
  final String label;
  final String url;

  Future<void> _open() async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSvg = asset.endsWith('.svg');
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _open,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSvg
                  ? SvgPicture.asset(asset, width: 16, height: 16)
                  : Image.asset(asset, width: 16, height: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
