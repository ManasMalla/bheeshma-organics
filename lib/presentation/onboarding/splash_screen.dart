import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/data/providers/advertisement_provider.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/category_provider.dart';
import 'package:bheeshmaorganics/data/providers/coupon_provider.dart';
import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/providers/notification_provider.dart';
import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_logo.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> rotationAnimation;
  late Animation<double> translationAnimation;
  late Animation<double> translationAnimation2;
  late AnimationController controller;
  late Animation<Offset> faceAnimation;
  late Animation<Color?> faceColorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    rotationAnimation =
        Tween<double>(begin: 0.0, end: pi * 0.25).animate(controller);
    translationAnimation =
        Tween<double>(begin: 0.0, end: 150.0).animate(controller);
    faceAnimation =
        Tween(begin: const Offset(100, 100), end: const Offset(250, 175))
            .animate(controller);
    faceColorAnimation =
        ColorTween(end: const Color(0xFF006738), begin: Colors.white)
            .animate(controller);
    translationAnimation2 =
        Tween<double>(begin: 0.0, end: 200.0).animate(controller)
          ..addListener(() {
            setState(() {});
          });
    controller.forward().then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SplashScreenExtended(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final _appLinks = AppLinks();

// Subscribe to all events when app is started.
// (Use allStringLinkStream to get it as [String])
      _appLinks.allUriLinkStream.listen((uri) {
        print('Received uri: ${uri.pathSegments}');
        if (FirebaseAuth.instance.currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please login to continue'),
          ));
          return;
        }
        if (uri.pathSegments.contains('products')) {
          Navigator.of(context).pushNamed('/product',
              arguments: int.parse(uri.pathSegments.last.toString()));
        }
      });
      return Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            Hero(
              tag: 0,
              child: Transform.translate(
                offset: Offset(
                    -(translationAnimation.value), translationAnimation2.value),
                child: Transform.rotate(
                  angle: -(rotationAnimation.value),
                  child: SvgPicture.asset(
                    'assets/images/splash-left.svg',
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                    alignment: Alignment.topLeft,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.shade800
                        : const Color.fromARGB(255, 5, 115, 65),
                  ),
                ),
              ),
            ),
            Hero(
              tag: 1,
              child: Transform.translate(
                offset: Offset(
                    translationAnimation2.value, translationAnimation.value),
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: SvgPicture.asset(
                    'assets/images/splash-right.svg',
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                    alignment: Alignment.topRight,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.shade800
                        : null,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: faceAnimation.value.dx,
              right: faceAnimation.value.dy,
              child: Hero(
                tag: 2,
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: SvgPicture.asset(
                    'assets/images/splash-face.svg',
                    color: faceColorAnimation.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SplashScreenExtended extends StatefulWidget {
  const SplashScreenExtended({super.key});

  @override
  State<SplashScreenExtended> createState() => _SplashScreenStateExtended();
}

class _SplashScreenStateExtended extends State<SplashScreenExtended>
    with TickerProviderStateMixin {
  late Animation<double> rotationAnimation;
  late Animation<double> translationAnimation;
  late Animation<double> translationAnimation2;
  late AnimationController controller;
  late Animation<Offset> faceAnimation;
  late Animation<Color?> faceColorAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        value: 1, duration: const Duration(milliseconds: 500), vsync: this);
    rotationAnimation =
        Tween<double>(begin: 0.0, end: pi * 0.25).animate(controller);
    translationAnimation =
        Tween<double>(begin: 0.0, end: 150.0).animate(controller);
    faceAnimation =
        Tween(begin: const Offset(100, 100), end: const Offset(250, 175))
            .animate(controller);
    faceColorAnimation =
        ColorTween(end: const Color(0xFF006738), begin: Colors.white)
            .animate(controller);
    translationAnimation2 =
        Tween<double>(begin: 0.0, end: 200.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Hero(
            tag: 0,
            child: Transform.translate(
              offset: Offset(
                  -(translationAnimation.value), translationAnimation2.value),
              child: Transform.rotate(
                angle: -(rotationAnimation.value),
                child: SvgPicture.asset(
                  'assets/images/splash-left.svg',
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                  alignment: Alignment.topLeft,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.green.shade800
                      : const Color.fromARGB(255, 5, 115, 65),
                ),
              ),
            ),
          ),
          Hero(
            tag: 1,
            child: Transform.translate(
              offset: Offset(
                  translationAnimation2.value, translationAnimation.value),
              child: Transform.rotate(
                angle: rotationAnimation.value,
                child: SvgPicture.asset(
                  'assets/images/splash-right.svg',
                  fit: BoxFit.fitHeight,
                  height: double.infinity,
                  alignment: Alignment.topRight,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.green.shade800
                      : null,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: faceAnimation.value.dx,
            right: faceAnimation.value.dy,
            child: Hero(
              tag: 2,
              child: Transform.rotate(
                angle: rotationAnimation.value,
                child: SvgPicture.asset(
                  'assets/images/splash-face.svg',
                  color: faceColorAnimation.value,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 27,
            right: 27,
            child: FutureBuilder(
                future: fetchDataFromDatabase(context),
                builder: (context, future) {
                  if (future.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
                  // if (FirebaseAuth.instance.currentUser != null) {
                  //   Navigator.of(context).pushReplacementNamed('/home');
                  // }
                  return FilledButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: getThemedColor(context, Colors.white,
                            Colors.white.withOpacity(0.5)),
                        foregroundColor: const Color(0xFF006738),
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF006738),
                                  ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          FeatherIcons.arrowUpRight,
                          size: 20,
                          color: getThemedColor(context,
                              const Color(0xFF3AB54A), const Color(0xFF006738)),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0).copyWith(top: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    BheeshmaOrganicsLogo(
                      height: 48,
                      color: Color(0xFF3AB54A),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'GO FOR\n'),
                      TextSpan(
                        text: 'BETTER\nHEALTH\n',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: const Color(0xFF3AB54A),
                                ),
                      ),
                      const TextSpan(text: 'WITH '),
                      TextSpan(
                        text: 'FOOD',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.wavy,
                                  decorationColor: const Color(0xFFD4E28D),
                                  decorationThickness: 1.5,
                                ),
                      )
                    ],
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: const Color(0xFF006738)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchDataFromDatabase(context) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<LikedItemsProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final advertisementProvider =
        Provider.of<AdvertisementProvider>(context, listen: false);
    final notificationsProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    try {
      await categoryProvider.fetchCategories().then((_) async {
        await categoryProvider.fetchSubcategories().then((_) async {
          await couponProvider.fetchCoupons().then((_) async {
            await addressProvider.fetchAddresses().then((_) async {
              print("123");
              await productProvider
                  .fetchProducts(categoryProvider.categories,
                      categoryProvider.subcategories)
                  .then((_) async {
                print("123");
                await wishlistProvider.fetchWishlist().then((_) async {
                  await orderProvider
                      .fetchOrders(addressProvider.addresses)
                      .then((_) async {
                    await cartProvider.fetchCart().then((_) async {
                      await advertisementProvider
                          .fetchImageAdvertisements()
                          .then((_) async {
                        await notificationsProvider.fetchNotification();
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
