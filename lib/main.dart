import 'package:flutter/material.dart';
import 'package:r3cycle_app/home/top_bar.dart';
import 'package:r3cycle_app/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application. Try running your application
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  // The 'build' method returns a 'Scaffold' widget that lays out its children in a vertical column:
  Widget build(BuildContext context) {
    return Scaffold(
      // The 'body' property takes a 'Column' widget:
      body: Column(
        children: [
          // 'TopBar' widget displays at the top of the screen:
          const TopBar(),
          // 'SizedBox' provides empty space:
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.04, // It takes up 4% of the total height of the screen.
          ),
          // 'Expanded' fills the remaining space in the column:
          Expanded(
            child: Stack(
              // 'Stack' allows widgets to overlap one another.
              children: [
                // 'HomeScreen' widget is placed at the bottom of the stack:
                const HomeScreen(),
                // 'Positioned' widget is used to position the scan button on the screen:
                Positioned(
                  bottom:
                      40, // It is positioned 40 pixels from the bottom of the stack.
                  left:
                      40, // It is positioned 40 pixels from the left of the stack.
                  child: GestureDetector(
                    // 'GestureDetector' widget is used to detect tap events.
                    onTap: () {
                      // This function will be called when the user taps the scan button.
                      // (navigate to the scan screen)
                    },
                    child: Container(
                      height: 54, // Sets the height of the button.
                      width: 240, // Sets the width of the button.
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
                      ),
                      child: const Row(
                        // Contains a row of widgets (icon and text).
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centers the row's children on the main axis.
                        children: [
                          Icon(
                            Icons.qr_code, // Displays a QR code icon.
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                              width:
                                  10), // Provides a 10-pixel-wide space between the icon and the text.
                          Text(
                            "Scan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 'Positioned' widget is used to position the map button on the screen:
                Positioned(
                  bottom:
                      40, // It is positioned 40 pixels from the bottom of the stack.
                  right:
                      40, // It is positioned 40 pixels from the right of the stack.
                  child: GestureDetector(
                    onTap: () {
                      // This function will be called when the user taps the map button.
                      // (navigate to the map screen)
                    },
                    child: Container(
                      height: 54, // Sets the height of the button.
                      width: 80, // Sets the width of the button.
                      decoration: BoxDecoration(
                        // Provides styling for the button.
                        borderRadius: const BorderRadius.all(
                            Radius.circular(27.0)), // Makes the button round.
                        color: Colors.white, // Sets the button's color.
                        boxShadow: [
                          // Adds a shadow effect to the button.
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.map, // Displays a map icon.
                        color: Colors.grey[700],
                        size: 24,
                      ),
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
