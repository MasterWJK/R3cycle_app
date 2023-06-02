import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:r3cycle_app/tag_finish_screen.dart';

class TagConfigScreen extends StatefulWidget {
  final String qrCode;

  const TagConfigScreen({Key? key, required this.qrCode}) : super(key: key);

  @override
  State<TagConfigScreen> createState() => _TagConfigScreenState();
}

enum Quality { highQuality, mediumQuality, lowQuality }

class _TagConfigScreenState extends State<TagConfigScreen> {
  Quality? _selectedQuality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          color: Color(0xFF054F46),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Configure your tag',
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/mini_tag.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.qrCode,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF054F46),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Configuring...",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF054F46),
                      ),
                    ),
                    const SizedBox(height: 32),
                    QualityRadioButton(
                      quality: Quality.highQuality,
                      title: 'High Quality',
                      subtitle: 'Never washed, rarely worn',
                      coins: '50',
                      selectedQuality: _selectedQuality,
                      onQualityChanged: (Quality? value) {
                        setState(() {
                          _selectedQuality = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    QualityRadioButton(
                      quality: Quality.mediumQuality,
                      title: 'Medium Quality',
                      subtitle: 'Washed multiple times, no damages',
                      coins: '30',
                      selectedQuality: _selectedQuality,
                      onQualityChanged: (Quality? value) {
                        setState(() {
                          _selectedQuality = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    QualityRadioButton(
                      quality: Quality.lowQuality,
                      title: 'Low Quality',
                      subtitle: 'Damaged clothes (e.g. holes)',
                      coins: '10',
                      selectedQuality: _selectedQuality,
                      onQualityChanged: (Quality? value) {
                        setState(() {
                          _selectedQuality = value;
                        });
                      },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        // 'GestureDetector' widget is used to detect tap events.
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (_, __, ___) => TagFinishScreen(
                                qrCode: widget.qrCode,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
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
                          height: 54, // Sets the height of the button.
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 11.0,
                          ), // Adds padding inside the button.
                          decoration: BoxDecoration(
                            // Provides styling for the button.
                            borderRadius: const BorderRadius.all(
                                Radius.circular(
                                    27.0)), // Makes the button round.
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
                              // Provides a 10-pixel-wide space between the icon and the text.
                              Text(
                                "Next",
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
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        // This function will be called when the user taps the map button.
                        // (navigate to the map screen)
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
                          "Quality Guidelines",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[700],
                            letterSpacing: -0.02,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QualityRadioButton extends StatelessWidget {
  final Quality quality;
  final String title;
  final String subtitle;
  final String coins;
  final Quality? selectedQuality;
  final void Function(Quality?) onQualityChanged;

  const QualityRadioButton({
    required this.quality,
    required this.title,
    required this.subtitle,
    required this.coins,
    required this.selectedQuality,
    required this.onQualityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = quality == selectedQuality;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0x12054F46) : Colors.transparent,
        border: Border.all(
          color: isSelected ? Color(0xFF054F46) : const Color(0xFFD0D0D0),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: RadioListTile<Quality>(
          value: quality,
          groupValue: selectedQuality,
          onChanged: onQualityChanged,
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.02,
                  fontSize: 14,
                  color: isSelected
                      ? const Color(0xFF054F46)
                      : const Color(0xFF707070),
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.orangeAccent, Colors.orange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  coins,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white,
                    letterSpacing: -0.02,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/images/coin.svg', // replace with your SVG image asset path
                height: 14, // adjust size as needed
                width: 10, // adjust size as needed
              ),
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: -0.02,
              color: isSelected
                  ? const Color(0xFF054F46)
                  : const Color(0xFF707070),
            ),
          ),
          activeColor: Color(0xFF054F46),
        ),
      ),
    );
  }
}
