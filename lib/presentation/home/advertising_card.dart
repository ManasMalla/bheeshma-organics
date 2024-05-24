import 'package:bheeshmaorganics/data/entitites/advertisements.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdvertisingCard extends StatefulWidget {
  final List<Advertisement> advertisements;
  const AdvertisingCard({
    super.key,
    required this.advertisements,
  });

  @override
  State<AdvertisingCard> createState() => _AdvertisingCardState();
}

class _AdvertisingCardState extends State<AdvertisingCard> {
  int advertisementIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          width: double.infinity,
          color: getThemedColor(context, const Color(0xFFD4E28D),
              const Color.fromARGB(255, 41, 43, 35)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider.builder(
                      itemCount: widget.advertisements.length,
                      itemBuilder: (context, index, _) {
                        final advertisement = widget.advertisements[index];
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                advertisement.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                advertisement.subtitle,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                advertisement.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                color: Theme.of(context).colorScheme.background,
                                elevation: 0,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    advertisement.route,
                                    arguments: advertisement.arguments,
                                  );
                                },
                                child: Text(
                                  advertisement.cta,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                          aspectRatio: 1.46,
                          viewportFraction: 1,
                          autoPlay: true,
                          onPageChanged: (index, _) {
                            setState(() {
                              advertisementIndex = index;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      height: 8,
                      child: ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF976316).withOpacity(
                                    index == advertisementIndex ? 1 : 0.5),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(
                                width: 8,
                              ),
                          itemCount: widget.advertisements.length),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 100,
              ),
            ],
          ),
        ),
        SvgPicture.asset(
          'assets/images/almond.svg',
          width: 100,
        ),
      ],
    );
  }
}
