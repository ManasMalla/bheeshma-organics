import 'dart:math';

import 'package:bheeshmaorganics/presentation/bheeshma_logo.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SplashScreenExtended(),
        ),
      );
    });
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
            child: FilledButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  Navigator.of(context).pushNamed('/login');
                }
              },
              style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
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
                    'Get Started'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    FeatherIcons.arrowUpRight,
                    size: 20,
                    color: Color(0xFF3AB54A),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0).copyWith(top: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const BheeshmaOrganicsLogo(
                      height: 48,
                      color: Color(0xFF3AB54A),
                    ),
                    Text(
                      'Bheeshma\nOrganics'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3AB54A),
                          ),
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
}
