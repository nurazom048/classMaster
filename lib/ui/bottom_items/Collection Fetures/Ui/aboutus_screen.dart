import 'package:flutter/material.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:classmate/widgets/heder/appbar_custom.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;

import '../../../../constant/constant.dart';
import '../../../auth_Section/auth_ui/SignUp_Screen.dart';
import '../data/about_data.dart';
import '../data/about_model.dart';

const String aboutApp =
    'Introducing an all-in-one institute management software designed to revolutionize the way educational institutions and coaching centers operate. Our powerful software streamlines essential functions, such as creating routines and notices, facilitating seamless communication, and sharing class notes. With our intuitive interface, users can easily access real-time information about class schedules, room assignments, and teacher allocations. Say goodbye to manual paperwork and administrative hassles, as our app simplifies and automates the necessary tasks for running an institute. Experience a new level of efficiency and organization with our comprehensive institute management software.';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom('About Us'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About App',
                style: TS.opensensBlue(fontSize: 22),
              ),
              fa.FaIcon(
                fa.FontAwesomeIcons.github,
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(minHeight: 400),
                child: Text(
                  aboutApp,
                  style: TS.opensensBlue(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
              ),
              Text(
                'Admin Panel',
                style: TS.opensensBlue(fontSize: 22),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: aboutList.length,
                itemBuilder: (context, i) {
                  return AboutInfoCard(aboutData: aboutList[i]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AboutInfoCard extends StatelessWidget {
  final AboutData aboutData;
  const AboutInfoCard({
    super.key,
    required this.aboutData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        AboutCard(
          aboutData: aboutData,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  margin: const EdgeInsets.only(right: 1),
                  constraints: const BoxConstraints(maxHeight: 300),
                  width: 100,
                  color: aboutData.color,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: aboutData.personalInfo.length,
                    itemBuilder: (context, i) {
                      return BluetMarkInfoText(
                        padding: const EdgeInsets.only(top: 4),
                        color: Colors.white,
                        textColor: Colors.white,
                        flex: 9,
                        text: ' ${aboutData.personalInfo[i]}',
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AboutCard extends StatelessWidget {
  final AboutData aboutData;
  const AboutCard({
    super.key,
    required this.aboutData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 272,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          // color: Colors.amber,
          ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          //

          Positioned(
            top: 50,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  color: aboutData.color,
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    // backgroundColor: Colors.red,
                    child: ClipOval(
                      child: Image.asset(
                        aboutData.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  aboutData.name,
                  style: TS.heading(color: Colors.white),
                ),
                Text(
                  aboutData.position,
                  style: TS.heading(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          //

          Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: aboutData.color,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
          Positioned(
            bottom: 40,
            child: Column(
              children: [
                Container(
                  height: 50,
                  constraints: const BoxConstraints(maxWidth: 200),
                  color: aboutData.color,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    itemCount: aboutData.socialLink.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () async {
                          print(aboutData.socialLink[i].show);
                          if (aboutData.socialLink[i].show == 'Gmail') {
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

// ···
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: Const.appEmail,
                              query: encodeQueryParameters(<String, String>{
                                'subject':
                                    'Example Subject & Symbols are allowed!',
                              }),
                            );

                            launchUrl(emailLaunchUri);
                          } else {
                            final url = Uri.parse(aboutData.socialLink[i].link);
                            // final url = Uri.parse(aboutData.socialLink[i].link);
                            _launchUrl(url);
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: aboutData.socialLink[i].icon,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
