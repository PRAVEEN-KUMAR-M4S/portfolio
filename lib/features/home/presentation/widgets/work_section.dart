import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/models/portfolio_info.dart';
import '../../../../core/services/portfolio_service.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 24 : 16,
        vertical: isWide ? 96 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Work',
                style: TextStyle(
                  fontFamily: 'Nanum Pen Script',
                  fontSize: isWide ? 96 : 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset('assets/images/underline.svg'),
            ],
          ),
          const SizedBox(height: 32),
          // Projects
          Column(
            children: PortfolioService.info.projects.map((project) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 56),
                child: _ProjectCard(
                  project: project,
                  isWide: isWide,
                  onLaunch: _launch,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.isWide,
    required this.onLaunch,
  });

  final ProjectInfo project;
  final bool isWide;
  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    final imageWidget = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isWide ? 650 : 300),
      child: SvgPicture.asset(project.image, fit: BoxFit.fill),
    );

    final textWidget = SizedBox(
      width: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.category,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.title,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: isWide ? 16 : 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _ProjectButton(
            label: 'View Project',
            icon: 'assets/images/lamb.webp',
            onTap: () => onLaunch(project.projectUrl),
            isWide: isWide,
          ),
          const SizedBox(height: 20),
          _ProjectButton(
            label: 'Github',
            icon: 'assets/images/github.svg',
            onTap: () => onLaunch(project.githubUrl),
            isWide: isWide,
          ),
        ],
      ),
    );

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [imageWidget, const SizedBox(width: 64), textWidget],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [imageWidget, const SizedBox(height: 16), textWidget],
    );
  }
}

class _ProjectButton extends StatefulWidget {
  const _ProjectButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isWide,
  });
  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool isWide;

  @override
  State<_ProjectButton> createState() => _ProjectButtonState();
}

class _ProjectButtonState extends State<_ProjectButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _hovered ? 1.0 : 0.7,
          child: SizedBox(
            width: 330,
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/button.webp',
                  width: 160,
                  height: 40,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  left: widget.isWide ? 20 : 40,
                  top: widget.isWide ? 4 : 8,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Nanum Pen Script',
                      fontSize: widget.isWide ? 22 : 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                if (widget.isWide)
                  Positioned(
                    left: 136,
                    top: -8,
                    child: widget.icon.endsWith('.svg')
                        ? SvgPicture.asset(widget.icon, width: 70, height: 55)
                        : Image.asset(widget.icon, width: 70, height: 55),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
