import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignOutBottomSheet extends StatelessWidget {
  const SignOutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final getThemedBlack = getThemedColor(context, Colors.black, Colors.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign out?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: getThemedBlack,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Are you sure you wan\'t to leave so early?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: SvgPicture.asset(
                'assets/images/character-two.svg',
                width: 200,
                colorFilter: Theme.of(context).brightness == Brightness.dark
                    ? ColorFilter.mode(
                        Colors.green.shade200.withOpacity(0.8),
                        BlendMode.srcIn,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: getThemedBlack,
                    width: 2,
                  ),
                  foregroundColor: getThemedBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FeatherIcons.arrowUpLeft,
                    size: 16,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'No, I\'m staying',
                  ),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: getThemedBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  )),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/splash', (route) => false);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FeatherIcons.logOut,
                    size: 16,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Sign out',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }
}
