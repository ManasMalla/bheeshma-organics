import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bheeshmaorganics/data/entitites/order.dart';
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
import 'package:bheeshmaorganics/firebase_options.dart';
import 'package:bheeshmaorganics/presentation/basket/basket_sheet.dart';
import 'package:bheeshmaorganics/presentation/basket/order_page.dart';
import 'package:bheeshmaorganics/presentation/basket/review_page.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_logo.dart';
import 'package:bheeshmaorganics/presentation/explore/explore_page.dart';
import 'package:bheeshmaorganics/presentation/home/home_page.dart';
import 'package:bheeshmaorganics/presentation/notifications/notification_page.dart';
import 'package:bheeshmaorganics/presentation/onboarding/login_page.dart';
import 'package:bheeshmaorganics/presentation/onboarding/splash_screen.dart';
import 'package:bheeshmaorganics/presentation/product/product_list_grid.dart';
import 'package:bheeshmaorganics/presentation/product/product_page.dart';
import 'package:bheeshmaorganics/presentation/profile/my_orders_page.dart';
import 'package:bheeshmaorganics/presentation/profile/profile_page.dart';
import 'package:bheeshmaorganics/presentation/profile/wishlist_page.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// FlutterFire's Firebase Cloud Messaging plugin
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isAndroid) {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    // It requests a registration token for sending messages to users from your App server or other trusted server environment.
    String? token = await messaging.getToken();

    if (kDebugMode) {
      print('Registration Token=$token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      _messageStreamController.sink.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LikedItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdvertisementProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bheeshma Naturals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006738)),
        useMaterial3: true,
        fontFamily: 'Gilroy',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006738), brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Gilroy',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const MyHomePage(title: 'Bheeshma Organics'),
        '/review': (context) => const ReviewPage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/product': (context) => const ProductPage(),
        '/wishlist': (context) => const WishlistPage(),
        '/notifications': (context) => const NotificationPage(),
        '/order-status': (context) => const OrderPage(),
        '/orders': (context) => const MyOrdersPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).checkIfPaymentsPending(
        Provider.of<CartProvider>(context, listen: false),
        Provider.of<ProductProvider>(context, listen: false).products,
        context,
        Provider.of<ProductProvider>(context, listen: false),
        Provider.of<AddressProvider>(context, listen: false)
            .addresses
            .firstOrNull);
    _messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          print(message.notification?.title);
        } else {
          print(message.data);
          // _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: pageIndex,
        backgroundColor: getThemedColor(context, const Color(0xFFEAEFD1),
            const Color.fromARGB(255, 32, 32, 30)),
        indicatorColor: getThemedColor(context, const Color(0xFFD4E28D),
            const Color.fromARGB(255, 50, 52, 42)),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FeatherIcons.compass),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(FeatherIcons.shoppingCart),
            label: 'Cart',
          ),
        ],
        onDestinationSelected: (page) {
          if (page == 2) {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: const Color(0xFF699E81),
                context: context,
                builder: (context) {
                  return const BasketBottomSheet();
                });
            return;
          }
          setState(() {
            pageIndex = page;
            searchController.clear();
          });
        },
      ),
      appBar: pageIndex == 0
          ? homeScreenAppBar(context, searchController)
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: const Icon(
                  FeatherIcons.arrowLeft,
                ),
                color: Colors.white,
              ),
              backgroundColor: getThemedColor(context, const Color(0xFFD4E28D),
                  const Color.fromARGB(255, 41, 43, 35)),
            ),
      body: searchController.text.isNotEmpty
          ? Consumer<ProductProvider>(builder: (context, productProvider, _) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        productProvider.products
                                .where((element) => element.name
                                    .toLowerCase()
                                    .contains(
                                        searchController.text.toLowerCase()))
                                .isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/hungry.svg',
                                    colorFilter: ColorFilter.mode(
                                        getThemedColor(
                                            context,
                                            const Color(0x60074014),
                                            const Color(0x60699E81)),
                                        BlendMode.srcIn),
                                    width: 170,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    'No search results found for "${searchController.text}"',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    FeatherIcons.search,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Search results for "${searchController.text}"',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 16,
                        ),
                        ProductGridList(productProvider.products
                            .where((element) => element.name
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                            .toList()),
                      ],
                    ),
                  ),
                ),
              );
            })
          : pageIndex == 0
              ? HomePage(
                  onShowExplorePage: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                )
              : const ExplorePage(),
    );
  }
}

PreferredSizeWidget homeScreenAppBar(BuildContext context, searchContorller) {
  return AppBar(
    toolbarHeight: 72,
    // backgroundColor: Theme,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    // backgroundColor: getThemedColor(context, const Color(0xFFD4E28D),
    //     const Color.fromARGB(255, 41, 43, 35)),
    title: Row(
      children: [
        SizedBox(
          width: 8,
        ),
        BheeshmaOrganicsLogo(
          height: 36,
          color: Color(0xFF787F54),
        ),
        SizedBox(
          width: 24,
        ),
        Expanded(
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: searchContorller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                isDense: true,
                filled: true,
                hintText: 'Search',
                fillColor: getThemedColor(context, const Color(0xFFD4E28D),
                        const Color.fromARGB(255, 41, 43, 35))
                    .withOpacity(0.5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/notifications');
        },
        icon: const Icon(FeatherIcons.bell),
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/profile');
        },
        icon: const Icon(FeatherIcons.user),
      ),
    ],
    automaticallyImplyLeading: false,
  );
}
