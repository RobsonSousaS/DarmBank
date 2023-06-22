import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final List<String> imageList = [
    'assets/card.png',
    'assets/money.png',
    'assets/sprinkle.png',
  ];

  int currentIndex = 0;
  final CarouselController _carouselController = CarouselController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: SafeArea(
        child: Stack(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, _) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: imageList.map((imageUrl) {
                return Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: ElevatedButton(
                onPressed: () {
                  // Ação do botão "Skip"
                },
                child: Text('Skip'),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: imageList.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.black,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                  spacing: 8.0,
                ),
              ),
            ),
            Positioned(
              right: 16.0,
              bottom: 16.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentIndex = (currentIndex + 1) % imageList.length;
                    _carouselController.nextPage();
                  });
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
