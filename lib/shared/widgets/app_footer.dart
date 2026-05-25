import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/portfolio_service.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            PortfolioService.info.footerText,
            style: const TextStyle(
              fontFamily: 'Nanum Pen Script',
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: [
              _SocialIcon(asset: 'assets/images/instagram.webp', url: PortfolioService.info.social.instagram),
              const SizedBox(width: 8),
              _SocialIcon(asset: 'assets/images/twitter.webp', url: PortfolioService.info.social.twitter),
              const SizedBox(width: 8),
              _SocialIcon(asset: 'assets/images/linkedin.webp', url: PortfolioService.info.social.linkedin),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.asset, required this.url});
  final String asset;
  final String url;

  Future<void> _launch() async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.platformDefault, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launch,
      child: Image.asset(asset, width: 25, height: 25),
    );
  }
}
