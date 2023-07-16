import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/heder/appbar_custom.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constant/constant.dart';
import '../../../auth_Section/auth_ui/SignUp_Screen.dart';
import '../data/about_data.dart';
import '../data/about_model.dart';

const String aboutApp =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom('About Us'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About App',
                style: TS.opensensBlue(fontSize: 22),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.amber,
                width: MediaQuery.of(context).size.width,
                height: 300,
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
          image: aboutData.image,
          name: aboutData.name,
          username: aboutData.position,
          color: aboutData.color,
        ),
        Container(
          height: 2,
          color: Colors.white,
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 50,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 1),
                    height: 100,
                    width: 100,
                    color: aboutData.color,
                    child: Center(
                        child: Text(
                      'Personal Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Open Sans',
                        fontStyle: FontStyle.normal,
                        height: 1.0,
                        letterSpacing: 0.0,
                        wordSpacing: 0.0,
                      ),
                      textAlign: TextAlign.justify,
                      textScaleFactor: 1.0,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.visible,
                    )),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 1),
                    height: 100,
                    width: 100,
                    color: aboutData.color,
                    child: Center(
                        child: Text(
                      'Social Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Open Sans',
                        fontStyle: FontStyle.normal,
                        height: 1.0,
                        letterSpacing: 0.0,
                        wordSpacing: 0.0,
                      ),
                      textAlign: TextAlign.justify,
                      textScaleFactor: 1.0,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.visible,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  margin: const EdgeInsets.only(right: 1),
                  constraints:
                      const BoxConstraints(maxHeight: 300, minHeight: 200),
                  width: 100,
                  color: aboutData.color,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: aboutData.personalInfo.length,
                    itemBuilder: (context, i) {
                      return BluetMarkInfoText(
                        // padding: EdgeInsets.zero,
                        color: Colors.white,
                        textColor: Colors.white,
                        flex: 5,
                        text: ' ${aboutData.personalInfo[i]}',
                      ).simle(
                        context,
                        MediaQuery.of(context).size.width * 0.36,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  constraints:
                      const BoxConstraints(maxHeight: 200, minHeight: 100),
                  margin: const EdgeInsets.only(left: 1),
                  color: aboutData.color,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
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
                              radius: 8,
                              backgroundImage: AssetImage(
                                aboutData.socialLink[i].icon,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text(
                                ' ${aboutData.socialLink[i].show}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TS.opensensBlue(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
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

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}

class AboutCard extends StatelessWidget {
  final String image;
  final String name;
  final String username;
  final Color color;
  const AboutCard({
    super.key,
    required this.image,
    required this.name,
    required this.username,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
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
                height: 200,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  color: color,
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
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TS.heading(color: Colors.white),
                ),
                Text(
                  username,
                  style: TS.heading(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
