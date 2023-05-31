import 'package:flutter/material.dart';
import 'package:r3cycle_app/components/layout_provider.dart';
// refreshcontroller
import 'package:pull_to_refresh/pull_to_refresh.dart';
// Boxshadow
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // what happens when you pull down
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 800));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: CustomHeader(
        builder: (context, mode) {
          late Widget text;
          if (mode == RefreshStatus.idle) {
            text = const Text(
              "Pull down refresh",
              style: TextStyle(
                color: Color(0xFFB0B0B0),
              ),
            );
          } else if (mode == RefreshStatus.refreshing) {
            text = SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: const Color(0xFF054F46).withOpacity(0.7),
                ));
          } else if (mode == RefreshStatus.canRefresh) {
            text = const Text(
              "Release to refresh",
              style: TextStyle(
                color: Color(0xFFB0B0B0),
              ),
            );
          } else if (mode == RefreshStatus.completed) {
            text = const Text(
              "Refresh completed!",
              style: TextStyle(
                color: Color(0xFFB0B0B0),
              ),
            );
          }
          return SizedBox(
            height: 60.0,
            child: Center(
              child: text,
            ),
          );
        },
      ),
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: () {
        // something could happen while loading
      },
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const SizedBox(
              height: 55.0,
              child: Center(
                  child: Text(
                "Pull up load",
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              )),
            );
          } else if (mode == LoadStatus.loading) {
            body = SizedBox(
                height: 55,
                child: Center(
                    child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: const Color(0xFF054F46).withOpacity(0.7),
                        ))));
          } else if (mode == LoadStatus.failed) {
            body = const SizedBox(
              height: 55.0,
              child: Center(
                  child: Text(
                "Load failed!",
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              )),
            );
          } else if (mode == LoadStatus.canLoading) {
            body = const SizedBox(
              height: 55.0,
              child: Center(
                  child: Text(
                "Release to load more",
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              )),
            );
          } else {
            body = const SizedBox(
              height: 55.0,
              child: Center(
                  child: Text(
                "No more posts",
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              )),
            );
          }
          return body;
        },
      ),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return // create container with indentation on each side and a height of 100
              Container(
            margin: EdgeInsets.symmetric(
              horizontal: LayoutProvider(context).indentation,
              vertical: 10,
            ),
            height: 100,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: <Widget>[
                  // First child in the stack, the background image
                  Container(
                    decoration: BoxDecoration(
                      //darken the image
                      image: const DecorationImage(
                        image: AssetImage('assets/images/IU_2023.jpg'),
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.black54, BlendMode.darken),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Second child in the stack, the additional image
                  Positioned(
                    left: 20,
                    top: 20,
                    bottom: 20,
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        // add background color and a border
                        color: Colors.white,

                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      // add image as child
                      child: Image.asset(
                        'assets/images/New_Balance_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Third child in the stack, the text section
                  Positioned(
                    right: 40,
                    top: 15,
                    bottom: 40,
                    child: Container(
                      width: 200, // specify the width of the text section here
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'New Balance - 10% Coupon', // replace with your text
                          style: TextStyle(
                            color: Colors.white, // text color
                            fontSize: 12, // text size
                            fontWeight: FontWeight.w800, // text weight
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Fourth child in the stack, small box at the right bottom
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 100, // specify the width of the small box here
                      height: 30, // specify the height of the small box here
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.6), // black color with 0.5 opacity
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Aligns children at the center
                        children: <Widget>[
                          // First child in the Row, the text
                          const Text(
                            '50', // replace with your text
                            style: TextStyle(
                              color: Color(0xFFFFD843), // text color
                              fontSize: 12, // text size
                              fontWeight: FontWeight.bold, // text weight
                            ),
                          ),
                          // Second child in the Row, the SVG picture
                          SvgPicture.asset(
                            'assets/images/coin.svg', // replace with your SVG image asset path
                            height: 20, // adjust size as needed
                            width: 10, // adjust size as needed
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
