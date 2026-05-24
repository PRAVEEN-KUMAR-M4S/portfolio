class PortfolioInfo {
  const PortfolioInfo({
    required this.name,
    required this.siteName,
    required this.greeting,
    required this.tagline,
    required this.bucketQuote,
    required this.skillsSubtitle,
    required this.footerText,
    required this.about,
    required this.social,
    required this.projects,
    required this.skills,
  });

  final String name;
  final String siteName;
  final String greeting;
  final String tagline;
  final String bucketQuote;
  final String skillsSubtitle;
  final String footerText;
  final AboutInfo about;
  final SocialLinks social;
  final List<ProjectInfo> projects;
  final List<SkillInfo> skills;

  factory PortfolioInfo.fromJson(Map<String, dynamic> json) => PortfolioInfo(
        name: json['name'] as String,
        siteName: json['siteName'] as String,
        greeting: json['greeting'] as String,
        tagline: json['tagline'] as String,
        bucketQuote: json['bucketQuote'] as String,
        skillsSubtitle: json['skillsSubtitle'] as String,
        footerText: json['footerText'] as String,
        about: AboutInfo.fromJson(json['about'] as Map<String, dynamic>),
        social: SocialLinks.fromJson(json['social'] as Map<String, dynamic>),
        projects: (json['projects'] as List<dynamic>)
            .map((e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
        skills: (json['skills'] as List<dynamic>)
            .map((e) => SkillInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class AboutInfo {
  const AboutInfo({
    required this.intro,
    required this.highlight,
    required this.bio,
  });

  final String intro;
  final String highlight;
  final String bio;

  factory AboutInfo.fromJson(Map<String, dynamic> json) => AboutInfo(
        intro: json['intro'] as String,
        highlight: json['highlight'] as String,
        bio: json['bio'] as String,
      );
}

class SocialLinks {
  const SocialLinks({
    required this.instagram,
    required this.twitter,
    required this.linkedin,
  });

  final String instagram;
  final String twitter;
  final String linkedin;

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
        instagram: json['instagram'] as String,
        twitter: json['twitter'] as String,
        linkedin: json['linkedin'] as String,
      );
}

class ProjectInfo {
  const ProjectInfo({
    required this.category,
    required this.title,
    required this.description,
    required this.image,
    required this.projectUrl,
    required this.githubUrl,
  });

  final String category;
  final String title;
  final String description;
  final String image;
  final String projectUrl;
  final String githubUrl;

  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
        category: json['category'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        image: json['image'] as String,
        projectUrl: json['projectUrl'] as String,
        githubUrl: json['githubUrl'] as String,
      );
}

class SkillInfo {
  const SkillInfo({required this.name, required this.icon});

  final String name;
  final String icon;

  factory SkillInfo.fromJson(Map<String, dynamic> json) => SkillInfo(
        name: json['name'] as String,
        icon: json['icon'] as String,
      );
}
