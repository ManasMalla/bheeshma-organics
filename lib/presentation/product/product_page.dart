import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/cart_utll.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var quantitySelection = 0;
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      body: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        final product = productProvider.products
            .where((element) => element.id == productId)
            .first;
        return Consumer<CartProvider>(builder: (context, cartProvider, _) {
          final existInCart = doesProductExistInCart(
              cartProvider.cart, product, quantitySelection);
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      product.cover,
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2.5,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: FilterChip(
                                            label: Text(product.price.keys
                                                .toList()[index]),
                                            onSelected: (_) {
                                              setState(() {
                                                quantitySelection = index;
                                              });
                                            },
                                            selected:
                                                quantitySelection == index,
                                          ),
                                        );
                                      },
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: product.price.length,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 36,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${product.discountedPrices.values.toList()[quantitySelection]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "MRP: ₹${product.price.values.toList()[quantitySelection].toInt()}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "(${product.discount}% off)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 164, 179, 88),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'ABOUT',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '01',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  product.description,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '02',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  product.description,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '03',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  product.description,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '04',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  product.description,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 36,
                left: 24,
                right: 24,
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 36),
                    ),
                    onPressed: () {
                      if (existInCart) {
                        //TODO MODIFY CART
                      } else {
                        final cartItem = CartItem(
                            productId: productId,
                            quantity: 1,
                            size: quantitySelection);
                        cartProvider.addProductToCart(
                            cartItem, ScaffoldMessenger.of(context));
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          (existInCart ? 'Modify Cart' : 'Add to Cart')
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: getThemedColor(
                                      context,
                                      const Color(0xFF264431),
                                      Colors.green.shade100)),
                        ),
                        const Spacer(),
                        Icon(
                          FeatherIcons.shoppingBag,
                          color: getThemedColor(context,
                              const Color(0xFF264431), Colors.green.shade100),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
      }),
    );
  }
}

// class ProductPage2 extends StatelessWidget {
//   const ProductPage2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final name = ModalRoute.of(context)?.settings.arguments as String;
//     final product = products.where((element) => element.name == name).first;
//     return Scaffold(
//       backgroundColor: const Color(0xFF184E1A),
//       body: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Image.network(
//                   'https://hermisan.com/wp-content/uploads/2023/07/PORTADA-ENTRADA.jpg',
//                   height: 350,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product.name.toUpperCase(),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headlineLarge
//                                     ?.copyWith(
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   FilterChip(
//                                     label: const Text('500 G'),
//                                     onSelected: (_) {},
//                                     selected: true,
//                                     backgroundColor: const Color(0xFF184E1A),
//                                   ),
//                                   const SizedBox(
//                                     width: 12,
//                                   ),
//                                   FilterChip(
//                                     label: const Text('1 KG'),
//                                     onSelected: (_) {},
//                                     backgroundColor: const Color(0xFF184E1A),
//                                   ),
//                                 ],
//                               ),
//                               Theme(
//                                 data: Theme.of(context).copyWith(
//                                   scaffoldBackgroundColor:
//                                       const Color(0xFF184E1A),
//                                 ),
//                                 child: FilterChip(
//                                   label: const Text('5 KG'),
//                                   onSelected: (_) {},
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "₹" + product.price.toString(),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .displaySmall
//                                     ?.copyWith(
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white,
//                                     ),
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     "MRP: ₹" + product.price.toString(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white54,
//                                           decoration:
//                                               TextDecoration.lineThrough,
//                                           decorationColor: Colors.white54,
//                                         ),
//                                   ),
//                                   const SizedBox(
//                                     width: 4,
//                                   ),
//                                   Text(
//                                     "(${product.discount}% off)",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                           fontWeight: FontWeight.w500,
//                                           color: const Color(0xFFD4E28D),
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   color: const Color(0xFF074014),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'ABOUT',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                         ),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         const Divider(),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '01',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium
//                                   ?.copyWith(
//                                     color: Colors.white60,
//                                   ),
//                             ),
//                             const SizedBox(
//                               width: 12,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 product.description,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '02',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium
//                                   ?.copyWith(
//                                     color: Colors.white60,
//                                   ),
//                             ),
//                             const SizedBox(
//                               width: 12,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 product.description,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '03',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium
//                                   ?.copyWith(
//                                     color: Colors.white60,
//                                   ),
//                             ),
//                             const SizedBox(
//                               width: 12,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 product.description,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '04',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium
//                                   ?.copyWith(
//                                     color: Colors.white60,
//                                   ),
//                             ),
//                             const SizedBox(
//                               width: 12,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 product.description,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: -24,
//             height: 200,
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF074014),
//                     Color(0x00074112),
//                   ],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: -140,
//             left: 0,
//             right: 0,
//             height: 500,
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF095E2D),
//                     Color(0x60184E1A),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 54,
//             left: 24,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: const Icon(
//                     FeatherIcons.arrowLeft,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   product.name.toUpperCase(),
//                   style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 24,
//             left: 24,
//             right: 24,
//             child: SizedBox(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
//                 ),
//                 onPressed: () {},
//                 child: Row(
//                   children: [
//                     Text(
//                       'Add to Bag'.toUpperCase(),
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF264431)),
//                     ),
//                     const Spacer(),
//                     const Icon(
//                       FeatherIcons.shoppingBag,
//                       color: Color(0xFF264431),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
