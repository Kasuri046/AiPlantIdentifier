import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselExample extends StatefulWidget {
  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {

  int _currentIndex = 0;
  final List<String> _images = [
    'https://via.placeholder.com/600x400/FF0000/FFFFFF?text=Image1',
    'https://via.placeholder.com/600x400/00FF00/FFFFFF?text=Image2',
    'https://via.placeholder.com/600x400/0000FF/FFFFFF?text=Image3',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel Slider Example'),
      ),
      body: Center(
        child: Container(
          height: screenHeight * 0.5, // Half of the screen height
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                items: _images
                    .map((image) => ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ))
                    .toList(),
                options: CarouselOptions(
                  height: screenHeight * 0.5,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _currentIndex = entry.key,
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.yellow
                              : Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
