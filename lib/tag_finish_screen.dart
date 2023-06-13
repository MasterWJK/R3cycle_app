import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:r3cycle_app/main.dart';
import 'package:r3cycle_app/map_screen.dart';

class TagFinishScreen extends StatefulWidget {
  final String qrCode;

  const TagFinishScreen({Key? key, required this.qrCode}) : super(key: key);

  @override
  State<TagFinishScreen> createState() => _TagFinishScreenState();
}

enum Quality { highQuality, mediumQuality, lowQuality }

class _TagFinishScreenState extends State<TagFinishScreen> {
  Quality? _selectedQuality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: Color(0xFF054F46),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Last steps',
          style: TextStyle(
            color: Color(0xFF054F46),
            fontFamily: 'OpenSansItalic',
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bag.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF054F46), // Dark green color
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "1",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                16), // Add spacing between the circle and text
                        const Expanded(
                          child: Text(
                            "Grab a durable bag that does not tear easily.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF054F46),
                              letterSpacing: -0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF054F46), // Dark green color
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                16), // Add spacing between the circle and text
                        const Expanded(
                          child: Text(
                            "Put the clothes and the tag into the bag and seal it.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF054F46),
                              letterSpacing: -0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF054F46), // Dark green color
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                16), // Add spacing between the circle and text
                        const Expanded(
                          child: Text(
                            "Find the nearest donation container and drop the bag there.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF054F46),
                              letterSpacing: -0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // This function will be called when the user taps the map button.
                    // (navigate to the map screen)
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MapScreen()),
                    //   (route) => route.isFirst,
                    // );
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (_, __, ___) => MapScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 11.0,
                    ),
                    alignment: Alignment.center,
                    height: 54, // Sets the height of the button.
                    //width: 80, // Sets the width of the button.
                    decoration: BoxDecoration(
                      // Provides styling for the button.
                      borderRadius: const BorderRadius.all(
                          Radius.circular(27.0)), // Makes the button round.
                      color: Colors.white, // Sets the button's color.
                      boxShadow: [
                        // Adds a shadow effect to the button.
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Find nearest container",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                        letterSpacing: -0.02,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  // 'GestureDetector' widget is used to detect tap events.
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MyTransition(
                        oldScreen: widget,
                        newScreen: MyHomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 54, // Sets the height of the button.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 11.0,
                    ), // Adds padding inside the button.
                    decoration: BoxDecoration(
                      // Provides styling for the button.
                      borderRadius: const BorderRadius.all(
                          Radius.circular(27.0)), // Makes the button round.
                      gradient: LinearGradient(
                        // Adds a gradient effect to the button's color.
                        colors: [
                          const Color(0xFF054F46).withOpacity(1.0),
                          const Color(0xFF054F46).withOpacity(1.0),
                        ],
                        begin: const Alignment(-1.0, -2.0),
                        end: const Alignment(1.0, 2.0),
                      ),
                      boxShadow: [
                        // Adds a shadow effect to the button.
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      // Contains a row of widgets (icon and text).
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centers the row's children on the main axis.
                      children: [
                        Text(
                          "Finish",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTransition extends PageRouteBuilder {
  final Widget oldScreen;
  final Widget newScreen;

  MyTransition({required this.oldScreen, required this.newScreen})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                newScreen,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                Stack(
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: Offset.zero,
                      ).animate(animation),
                      child: newScreen,
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(0.0, 1.0),
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut, // Apply ease-out curve
                        ),
                      ),
                      child: oldScreen,
                    ),
                  ],
                ),
            transitionDuration: const Duration(milliseconds: 300));
}
