import 'dart:ui';

class AboutData {
  final String image;
  final Color color;
  final String name;
  final String position;
  final List<String> personalInfo;
  final List<SocialLink> socialLink;

  AboutData({
    required this.image,
    required this.color,
    required this.name,
    required this.position,
    required this.personalInfo,
    required this.socialLink,
  });
}

class SocialLink {
  final String icon;
  final String show;
  final String link;

  SocialLink({
    required this.icon,
    required this.show,
    required this.link,
  });
}
