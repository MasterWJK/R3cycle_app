import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/layout_provider.dart';
import 'package:flutter/cupertino.dart';
// import ownprofile
import '../profile/own_profile.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: LayoutProvider(context).indentation,
          vertical: LayoutProvider(context).topBarHeight * 0.46,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: LayoutProvider(context).topBarHeight,
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: SvgPicture.asset(
                  'assets/R3_logo.svg',
                  height: LayoutProvider(context).topBarHeight - 5.0,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            Container(
              height: 54, // Adjust the height according to your needs
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: const Color(0xFFF3F3F3),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align items in the center
                children: [
                  SvgPicture.asset(
                    'assets/images/coin.svg',
                    height: 24, // Adjust the size according to your needs
                    fit: BoxFit
                        .contain, // It's recommended to use BoxFit.contain for SVGs to prevent distortion
                  ),
                  const Text(
                    '80',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const OwnProfile()),
                );
              },
              child: Container(
                height: 38,
                width: 38,
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/rec_profile_pic.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
