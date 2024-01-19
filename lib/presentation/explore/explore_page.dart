import 'package:bheeshmaorganics/data/providers/category_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/product/product_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    _tabController = TabController(length: categories.length, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    searchController.addListener(() {
      setState(() {});
    });
  }

  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
        final categories = categoryProvider.categories;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    color: getThemedColor(context, const Color(0xFFD4E28D),
                        Color.fromARGB(255, 41, 43, 35)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Explore our wide range",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. "),
                        const SizedBox(
                          height: 140,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 24,
                    left: 24,
                    bottom: -60,
                    child: Container(
                      height: 210,
                      padding: const EdgeInsets.all(24.0)
                          .copyWith(right: 0, bottom: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF09524B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lorem ipsum dolor',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  onPressed: () {},
                                  child: Text(
                                    'Know More'.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(2, 0),
                            child: SvgPicture.asset(
                              'assets/images/almond_unicolor.svg',
                              width: 80,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24.0).copyWith(top: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: categories
                          .map(
                            (e) => Tab(
                              text: e.name,
                            ),
                          )
                          .toList(),
                      controller: _tabController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        isDense: true,
                        filled: true,
                        hintText: 'Search',
                        fillColor: const Color(0x50787F54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none),
                        suffixIcon: const Icon(
                          FeatherIcons.search,
                        ),
                      ),
                      controller: searchController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                      final categoricalProducts = productProvider.products
                          .where((element) =>
                              element.category ==
                              categories[_tabController.index])
                          .where((element) =>
                              searchController.text.isEmpty ||
                              element.name.toLowerCase().contains(
                                  searchController.text.toLowerCase()))
                          .toList();
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return ProductCard(
                            categoricalProducts[index],
                          );
                        },
                        separatorBuilder: (context, _) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: categoricalProducts.length,
                        primary: false,
                        shrinkWrap: true,
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
