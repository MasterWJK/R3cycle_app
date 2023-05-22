import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:r3cycle_app/components/layout_provider.dart';
import 'package:r3cycle_app/components/my_scroll_behavior.dart';
import 'package:r3cycle_app/profile/own_profile.dart';

class InPost extends StatefulWidget {
  const InPost({super.key});

  @override
  State<InPost> createState() => _InPostState();
}

class _InPostState extends State<InPost> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            LayoutProvider(context).topBarHeight +
                2 * LayoutProvider(context).topBarHeight * 0.46,
          ),
          child: SafeArea(
            child: SizedBox(
              height: LayoutProvider(context).topBarHeight +
                  2 * LayoutProvider(context).topBarHeight * 0.46,
              child: Row(
                children: [
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: Colors.black,
                          size: LayoutProvider(context).topBarHeight * 1.1,
                        ),
                      )),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const OwnProfile()),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: LayoutProvider(context).topBarHeight,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: const Image(
                                    image: AssetImage(
                                        'assets/images/rec_profile_pic.png'))),
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Name
                            const Text(
                              "R3Cycle",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            ),
                            const SizedBox(
                              width: 6.0,
                            ),
                            true
                                ? const Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: Color(0xFF42A5F5),
                                  )
                                // ignore: dead_code
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      LayoutProvider(context).indentation,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "widget.post.title",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            "widget.post.description",
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    endIndent: LayoutProvider(context).indentation,
                    indent: LayoutProvider(context).indentation,
                    thickness: 1.3,
                  ),
                  Container(height: 200),
                ],
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06 +
                      MediaQuery.of(context).padding.bottom,
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color(0x20000000),
                        offset: Offset(0, 0),
                        blurRadius: 8.0),
                  ]),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        LayoutProvider(context).indentation,
                        5,
                        LayoutProvider(context).indentation,
                        5),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom * 0.5),
                      child: Row(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF707070).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(1000)),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 17),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Coming soon!"),
                                ),
                              )),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: LayoutProvider(context).indentation),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: LayoutProvider(context).indentation + 40,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border_outlined,
                                    color: Color(0xFFA0A0A0),
                                    size: 18.0,
                                  ),
                                  SizedBox(width: 7.0),
                                  Text(
                                    "0",
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
