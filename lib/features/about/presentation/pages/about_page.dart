import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/portfolio_service.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 0 : 16,
            vertical: 20,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/yellowabout.webp'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 88, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile image placeholder
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.secondary.withOpacity(0.2),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  PortfolioService.info.about.intro,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 14,
                    color: Color(0xFF8E8570),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 12,
                      color: Color(0xFF8E8570),
                      height: 1.7,
                    ),
                    children: [
                      TextSpan(
                        text: PortfolioService.info.about.highlight,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: PortfolioService.info.about.bio,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
