import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/address/address_bottom_sheet.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:bheeshmaorganics/presentation/onboarding/login_page.dart';
import 'package:bheeshmaorganics/presentation/profile/sign_out_bottom_sheet.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getThemedColor(context, const Color(0xFFD4E28D),
            const Color.fromARGB(255, 41, 43, 35)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    color: getThemedColor(context, const Color(0xFFD4E28D),
                        const Color.fromARGB(255, 41, 43, 35)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Profile",
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
                            "Your one stop repository to explore your daily dose of nature and everything you.."),
                        const SizedBox(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 88,
                  ),
                ],
              ),
              Positioned(
                right: 24,
                left: 24,
                bottom: 0,
                child: Container(
                  height: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFF09524B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SvgPicture.asset(
                          'assets/icons/logo.svg',
                          height: 100,
                          color: const Color.fromARGB(80, 7, 56, 51),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Transform.rotate(
                          angle: pi,
                          child: SvgPicture.asset(
                            'assets/icons/logo.svg',
                            height: 100,
                            color: const Color.fromARGB(80, 7, 56, 51),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? "User",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user?.email ??
                                        (user?.phoneNumber != null
                                            ? ("${user!.phoneNumber!.substring(0, 3)} ${user.phoneNumber!.substring(3, 8)} ${user.phoneNumber!.substring(8, 13)}")
                                            : "Anonymous"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Member since ${user?.metadata.creationTime?.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Builder(builder: (context) {
                                    String str = FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        "";
                                    List<String> list = [];
                                    for (int i = 0; i < str.length; i++) {
                                      if (i % 4 == 0 && i != 0) {
                                        list.add(" ");
                                      }
                                      list.add(str[i]);
                                    }
                                    return Text(
                                      list.take(19).join(' '),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              letterSpacing: 0.1),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  MaterialButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      showEditProfileBottomSheet(context);
                                    },
                                    child: Text(
                                      'Edit Profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/user-profile.png',
                                height: 130,
                                width: 130,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(bottom: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/orders');
                  },
                  leading: const Icon(
                    FeatherIcons.shoppingBag,
                  ),
                  title: const Text('My Orders'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/wishlist',
                    );
                  },
                  leading: const Icon(
                    FeatherIcons.heart,
                  ),
                  title: const Text('Wishlist'),
                ),
                ListTile(
                  leading: const Icon(
                    FeatherIcons.mapPin,
                  ),
                  title: const Text('Addressess'),
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: const Color(0xFF699E81),
                        context: context,
                        builder: (context) {
                          return const AddressBottomSheet();
                        });
                  },
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Support'),
                    leading: const Icon(
                      FeatherIcons.helpCircle,
                    ),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 48),
                        leading: const Icon(FeatherIcons.mail),
                        title: const Text('Email'),
                        onTap: () {
                          try {
                            launchUrl(
                                Uri.parse('mailto:bheeshmanaturals@gmail.com'));
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 48),
                        leading: const Icon(FeatherIcons.phone),
                        title: const Text('Phone'),
                        onTap: () {
                          launchUrlString('tel:+919550283557');
                        },
                      ),
                      // ListTile(
                      //   contentPadding: EdgeInsets.only(left: 48),
                      //   leading: Icon(FeatherIcons.gitPullRequest),
                      //   title: Text('Raise a request'),
                      // ),
                      ListTile(
                        onTap: () {
                          launchUrlString(
                              'https://bheeshmanaturals.manasmalla.dev/terms-conditions.html');
                        },
                        contentPadding: const EdgeInsets.only(left: 48),
                        title: const Text('Terms and Conditions'),
                        leading: const Icon(
                          FeatherIcons.info,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          launchUrlString(
                              'https://bheeshmanaturals.manasmalla.dev/privacy-policy.html');
                        },
                        contentPadding: const EdgeInsets.only(left: 48),
                        title: const Text('Privacy Policy'),
                        leading: const Icon(
                          FeatherIcons.lock,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final bytes = await rootBundle
                        .load('assets/images/bheeshma-naturals.png');
                    final Uint8List list = bytes.buffer.asUint8List();
                    Share.shareXFiles(
                      [
                        XFile.fromData(list,
                            name: 'bheeshma-naturals.png',
                            mimeType: 'image/png')
                      ],
                      subject: 'Checkout this awesome app!',
                      text:
                          'Checkout this awesome app to order natural products! Bheeshma Naturals provides you with the best quality products at the best price. Install now! Head over to the app store now: https://play.google.com/store/apps/details?id=com.manasmalla.bheeshmaorganics&hl=en_US',
                    );
                  },
                  title: const Text('Share App'),
                  leading: const Icon(
                    FeatherIcons.share,
                  ),
                ),
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const SignOutBottomSheet();
                        });
                  },
                  title: const Text('Sign out'),
                  leading: const Icon(
                    FeatherIcons.logOut,
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<dynamic> showEditProfileBottomSheet(BuildContext context) {
    var nameEditingController = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.displayName);
    var emailEditingController =
        TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    var phoneEditingController = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.phoneNumber);
    var otpEditingController = TextEditingController();

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Your one stop shop for all updating your\ndetails so that you never miss out the goodness',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                //Name
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                  controller: nameEditingController,
                ),
                SizedBox(
                  height: 16,
                ),
                //Phone
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                  controller: phoneEditingController,
                ),
                SizedBox(
                  height: 16,
                ),
                //Email
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                  controller: emailEditingController,
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (nameEditingController.text.isNotEmpty &&
                          nameEditingController.text !=
                              FirebaseAuth.instance.currentUser?.displayName) {
                        FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(nameEditingController.text);
                      }
                      if (emailEditingController.text.isNotEmpty &&
                          emailEditingController.text !=
                              FirebaseAuth.instance.currentUser?.email) {
                        FirebaseAuth.instance.currentUser
                            ?.updateEmail(emailEditingController.text);
                      }
                      if (phoneEditingController.text.isNotEmpty &&
                          phoneEditingController.text !=
                              FirebaseAuth.instance.currentUser?.phoneNumber) {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneEditingController.text,
                            verificationCompleted: (credential) {
                              FirebaseAuth.instance.currentUser
                                  ?.updatePhoneNumber(credential);
                            },
                            verificationFailed: (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                BheeshmaSnackbar(
                                    title: 'Unable to link phone number',
                                    message:
                                        'An unknown error occured when updating your phone number. ${failure.message}',
                                    contentType: ContentType.failure),
                              );
                            },
                            codeSent: (verificationId, [forceResendingToken]) {
                              OTPBottomSheet(
                                  phoneEditingController:
                                      phoneEditingController,
                                  verificationId: verificationId,
                                  otpEditingController: otpEditingController);
                            },
                            codeAutoRetrievalTimeout: (_) {});
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        BheeshmaSnackbar(
                          title: 'Profile updated successfully',
                          message:
                              'Please close and open your app to reflect the updated changes.',
                          contentType: ContentType.help,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Update'),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
