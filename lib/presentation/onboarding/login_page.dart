import 'package:bheeshmaorganics/data/utils/phone_number_formatter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 24,
                )),
            onPressed: () {
              FirebaseAuth.instance.signInAnonymously().then((value) {
                Navigator.of(context).pushNamed('/home');
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
                  'lorem ipsum\ndolor sit amet',
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
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        controller: phoneEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                              borderSide: const BorderSide(
                                color: Colors.black,
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
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          )),
                      onPressed: () {
                        if (isPhoneLogin) {
                          if (phoneEditingController.text.isNotEmpty) {
                            FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: "+91${phoneEditingController.text}",
                              verificationCompleted: (phoneAuthCredential) {
                                FirebaseAuth.instance
                                    .signInWithCredential(phoneAuthCredential)
                                    .then((value) {
                                  if (value.user != null) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error verifying phone number',
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                              codeSent: (verificationId, forceResendingToken) {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return OTPBottomSheet(
                                        phoneEditingController:
                                            phoneEditingController,
                                        verificationId: verificationId,
                                        otpEditingController:
                                            otpEditingController,
                                      );
                                    });
                              },
                              verificationFailed: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please enter a valid phone number')));
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
                            'Login'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
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

class OTPBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                    'Enter OTP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Enter the OTP sent to your\nphone number\n+91 ${phoneEditingController.text.substring(0, 5)} ${phoneEditingController.text.substring(5, 10)}',
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
          controller: otpEditingController,
          length: 6,
          defaultPinTheme: PinTheme(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
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
                  side: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  foregroundColor: Colors.black,
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
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  )),
              onPressed: () {
                if (otpEditingController.text.isEmpty ||
                    otpEditingController.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid OTP',
                      ),
                    ),
                  );
                  return;
                }
                FirebaseAuth.instance
                    .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otpEditingController.text))
                    .then((value) {
                  if (value.user != null) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error verifying phone number',
                        ),
                      ),
                    );
                  }
                });
              },
              child: const Text('Sign in'),
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
