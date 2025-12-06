import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/menu_screen.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.banners});

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
          ),
          items: banners
              .map(
                (url) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    child: Container(
                      width: 360,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(url) as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 10.0),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  Container(
                    width: 20,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(400),
                      color: controller.carousalCurrentIndex.value == i
                          ? Colors.black26
                          : Colors.black12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
