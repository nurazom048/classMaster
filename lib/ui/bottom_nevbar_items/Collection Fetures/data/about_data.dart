import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;
import 'package:flutter/material.dart';
import '../../../../core/constant/png_const.dart';
import 'about_model.dart';

final List<AboutData> aboutList = [
  AboutData(
    color: const Color.fromRGBO(46, 15, 92, 1.0),
    image: ConstPng.nurazom,
    name: 'Nur Azom',
    position: 'App Developer',
    personalInfo: [
      'Khulna Polytechnic Institute',
      'Season: 2018 - 2019',
      'Thana: Maheshpur',
      'Dist: Khulna',
      'Division: Khulna',
    ],
    socialLink: [
      SocialLink(
          icon: const fa.FaIcon(fa.FontAwesomeIcons.facebook),
          show: 'Facebook.com',
          link: 'https://www.facebook.com/noorazom049'),
      SocialLink(
          icon: const fa.FaIcon(fa.FontAwesomeIcons.whatsapp),
          show: "whatsapp",
          link: 'https://call.whatsapp.com/video/VWXIZOCkbECmG5ADJ7lNkK'),
      SocialLink(
          icon: const Icon(Icons.mail),
          show: 'Gmail',
          link: 'https://github.com/nurazom048'),
    ],
  ),
  // Add more AboutData objects here...
  AboutData(
    color: const Color.fromRGBO(196, 56, 255, 1.0),
    image: ConstPng.mmAnik,
    name: 'M. M. Anik',
    position: 'Ui/UX Designer',
    personalInfo: [
      'Jessore Polytechnic Institute',
      'Department: Electrical',
      'Season: 2018 - 2019',
      'Thana: Maheshpur',
      'Dist: Khulna',
      'Division: Khulna',
    ],
    socialLink: [
      SocialLink(
          icon: const fa.FaIcon(fa.FontAwesomeIcons.facebook),
          show: 'Facebook',
          link: 'https://www.facebook.com/M.M.Anik.02'),
      SocialLink(
        icon: const fa.FaIcon(fa.FontAwesomeIcons.whatsapp),
        show: "WhatsApp",
        link:
            'https://api.whatsapp.com/qr/SI32EFKIRDDUM1?autoload=1&app_absent=0',
      ),
      SocialLink(
          icon: const Icon(Icons.mail),
          show: 'Gmail',
          link: 'https://github.com/nurazom048'),
      SocialLink(
        icon: const fa.FaIcon(fa.FontAwesomeIcons.twitter),
        show: 'Twitter.com/MMAnik02',
        link: 'https://github.com/nurazom048',
      ),
      SocialLink(
        icon: const fa.FaIcon(fa.FontAwesomeIcons.behance),
        show: 'Behance.net',
        link: 'Behance.net/mmanik',
      ),
    ],
  ),
  AboutData(
    color: Colors.pinkAccent,
    image: ConstPng.nime,
    name: 'Md. Naimul Islam Naim',
    position: 'IT Expert',
    personalInfo: [
      'Khulna Polytechnic Institute',
      'Department: Electronics',
      'Season: 2018 - 2019',
    ],
    socialLink: [
      SocialLink(
          icon: const fa.FaIcon(fa.FontAwesomeIcons.facebook),
          show: 'Facebook',
          link: 'https://www.facebook.com/naim.octal'),
      // SocialLink(
      //   icon: const fa.FaIcon(fa.FontAwesomeIcons.whatsapp),
      //   show: "WhatsApp",
      //   link:
      //       'https://api.whatsapp.com/qr/SI32EFKIRDDUM1?autoload=1&app_absent=0',
      // ),
      SocialLink(
        icon: const Icon(Icons.mail),
        show: 'Gmail',
        link: 'naim.octal@gmail.com',
      ),
    ],
  ),
];
