import 'package:babel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  IntroState createState() => IntroState();
}

class IntroState extends State<Intro> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [
              _buildPage("assets/images/image2.svg"),
              _buildPage("assets/images/image1.png"),
              _buildPage("assets/images/image3.png"),
              _buildPage("assets/images/image4.png"),
            ],
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              currentPageText(localization),
              style: const TextStyle(
                fontFamily: 'Neo Sans Arabic',
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: Color(0xFFD6B56A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return _buildIndicator(index == currentPage);
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Method to get the current page text dynamically
  String currentPageText(AppLocalizations localization) {
    switch (currentPage) {
      case 0:
        return localization.translate('intro1');
      case 1:
        return localization.translate('intro2');
      case 2:
        return localization.translate('intro3');
      case 3:
        return localization.translate('intro4');
      default:
        return "";
    }
  }

  Widget _buildPage(String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imagePath.endsWith('.svg'))
          SvgPicture.asset(
            imagePath,
            width: 250,
          )
        else
          Image.asset(
            imagePath,
            width: 300,
          ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.yellow : Colors.grey,
      ),
    );
  }
}
