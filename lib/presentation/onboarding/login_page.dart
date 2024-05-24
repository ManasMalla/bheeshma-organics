import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/data/providers/advertisement_provider.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/category_provider.dart';
import 'package:bheeshmaorganics/data/providers/coupon_provider.dart';
import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/providers/notification_provider.dart';
import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPhoneLogin = true;
  final usernameEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final otpEditingController = TextEditingController();
  var isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor:
                    getThemedColor(context, Colors.black, Colors.white),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 24,
                )),
            onPressed: () {
              FirebaseAuth.instance.signInAnonymously().then((value) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (route) => route.settings.name == '/splash');
              });
            },
            child: const Text("SKIP"),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  'your step towards\nEverything Natural',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'GET STARTED',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 48,
                ),
                isPhoneLogin
                    ? TextField(
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: phoneEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 10) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        decoration: InputDecoration(
                            counter: const SizedBox(),
                            prefixIcon: const Icon(
                              FeatherIcons.phone,
                              size: 20,
                            ),
                            prefixText: '+91 ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              borderSide: BorderSide(
                                color: getThemedColor(
                                    context, Colors.black, Colors.white),
                              ),
                            ),
                            hintText: 'Phone Number'),
                      )
                    : TextField(
                        controller: usernameEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: 'Username'),
                      ),
                isPhoneLogin
                    ? const SizedBox()
                    : const SizedBox(
                        height: 16,
                      ),
                isPhoneLogin
                    ? const SizedBox()
                    : TextField(
                        controller: passwordEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: 'Password'),
                      ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Spacer(),
                    isPhoneLogin
                        ? const SizedBox()
                        : TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
                            onPressed: () {},
                            child: const Text(
                              'forgot password',
                            ),
                          ),
                    const SizedBox(
                      width: 16,
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: getThemedColor(
                              context, Colors.black, Colors.white),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          )),
                      onPressed: isLoggingIn
                          ? null
                          : () {
                              if (isPhoneLogin) {
                                if (phoneEditingController.text.isNotEmpty) {
                                  isLoggingIn = true;
                                  setState(() {});
                                  FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber:
                                        "+91${phoneEditingController.text}",
                                    verificationCompleted:
                                        (phoneAuthCredential) {
                                      FirebaseAuth.instance
                                          .signInWithCredential(
                                              phoneAuthCredential)
                                          .then((value) {
                                        if (value.user != null) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/home',
                                                  (route) =>
                                                      route.settings.name ==
                                                      '/splash');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error verifying phone number',
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    codeSent:
                                        (verificationId, forceResendingToken) {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: OTPBottomSheet(
                                                phoneEditingController:
                                                    phoneEditingController,
                                                verificationId: verificationId,
                                                otpEditingController:
                                                    otpEditingController,
                                              ),
                                            );
                                          });
                                    },
                                    verificationFailed: (error) {
                                      setState(() {
                                        isLoggingIn = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            error.message ??
                                                "Error verifying phone number",
                                          ),
                                        ),
                                      );
                                    },
                                    codeAutoRetrievalTimeout: (verificationId) {
                                      //Code autoretrival timeout
                                      setState(() {
                                        isLoggingIn = false;
                                      });
                                    },
                                  );
                                } else {
                                  isLoggingIn = false;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid phone number'),
                                    ),
                                  );
                                  setState(() {});
                                }
                              }
                            },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          Text(
                            isLoggingIn ? "... We're logging you in" : 'Login',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isLoggingIn
                                      ? Colors.grey
                                      : getThemedColor(
                                          context, Colors.white, Colors.black),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          const Icon(
                            FeatherIcons.arrowUpRight,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: SvgPicture.asset(
              'assets/images/almond-crown.svg',
              fit: BoxFit.fitWidth,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}

class OTPBottomSheet extends StatefulWidget {
  const OTPBottomSheet({
    super.key,
    required this.phoneEditingController,
    required this.verificationId,
    required this.otpEditingController,
  });

  final TextEditingController phoneEditingController;
  final String verificationId;
  final TextEditingController otpEditingController;

  @override
  State<OTPBottomSheet> createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<OTPBottomSheet> {
  var isOTPLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    var getThemedBlack = getThemedColor(context, Colors.black, Colors.white);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter OTP',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: getThemedBlack,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Enter the OTP sent to your\nphone number\n+91 ${widget.phoneEditingController.text.substring(0, 5)} ${widget.phoneEditingController.text.substring(5, 10)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Transform.translate(
              offset: const Offset(0, -5),
              child: SvgPicture.asset(
                'assets/images/character-two.svg',
                width: 150,
                color: getThemedBlack,
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
        Pinput(
          controller: widget.otpEditingController,
          length: 6,
          defaultPinTheme: PinTheme(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: getThemedBlack,
                ),
                borderRadius: BorderRadius.circular(8),
              )),
        ),
        const SizedBox(
          height: 24,
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
              onPressed: () {},
              child: const Text(
                'Resent OTP',
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: getThemedBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  )),
              onPressed: isOTPLoggingIn
                  ? null
                  : () async {
                      if (widget.otpEditingController.text.isEmpty ||
                          widget.otpEditingController.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a valid OTP',
                            ),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        isOTPLoggingIn = true;
                      });
                      if (FirebaseAuth.instance.currentUser == null) {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: widget.otpEditingController.text))
                            .then((value) async {
                          if (value.user != null) {
                            await fetchDataFromDatabase(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                (route) => route.settings.name == '/splash');
                          } else {
                            setState(() {
                              isOTPLoggingIn = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Error verifying phone number',
                                ),
                              ),
                            );
                          }
                        });
                      } else {
                        FirebaseAuth.instance.currentUser!.updatePhoneNumber(
                            PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: widget.otpEditingController.text));
                      }
                    },
              child: Text(isOTPLoggingIn ? '.. Verifying' : 'Sign in'),
            ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }

  Future<void> fetchDataFromDatabase(context) async {
    print("456");
    if (FirebaseAuth.instance.currentUser == null) {
      print("123");
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
        print("categories");
        await categoryProvider.fetchSubcategories().then((_) async {
          await couponProvider.fetchCoupons().then((_) async {
            await addressProvider.fetchAddresses().then((_) async {
              await productProvider
                  .fetchProducts(categoryProvider.categories,
                      categoryProvider.subcategories)
                  .then((_) async {
                print(_);
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
      ScaffoldMessenger.of(context).showSnackBar(BheeshmaSnackbar(
        title: "Error fetching fresh content!",
        message:
            "We're trying our best to get things right again. However, you can still explore our wide range of products, which are fresh for sure.",
        contentType: ContentType.failure,
      ));
    }
  }
}
