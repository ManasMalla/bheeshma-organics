import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/cart_utll.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:bheeshmaorganics/presentation/product/modify_cart_sheet.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var quantitySelection = 0;
  @override
  Widget build(BuildContext context) {
    final productId = int.tryParse(
            ModalRoute.of(context)?.settings.arguments.toString() ?? "") ??
        0;
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
                      product.image,
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name.contains("|")
                                ? product.name.split(" | ").first
                                : product.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          product.name.contains("|")
                              ? Text(
                                  product.name.split(" | ").skip(1).join(" | "),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.w700),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Wrap(
                                  children: product.price.map((e) {
                                    final index = product.price.indexOf(e);
                                    return FilterChip(
                                      label: Text(e.quantity),
                                      onSelected: e.stock == 0
                                          ? null
                                          : (_) {
                                              setState(() {
                                                quantitySelection = index;
                                              });
                                            },
                                      selected: quantitySelection == index,
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                width: 18,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${product.discountedPrices[quantitySelection].price}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  product.price.first.discount <= 0
                                      ? SizedBox()
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "MRP: ₹${product.price[quantitySelection].price.toInt()}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "(${((product.price.first.discount * 100) / product.price.first.price).round()}% off)",
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
                          Builder(builder: (context) {
                            final description =
                                product.description.split("\n\n");
                            return ListView.separated(
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (index + 1).toString().padLeft(2, "0"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          description[index],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 12,
                                  );
                                },
                                primary: false,
                                shrinkWrap: true,
                                itemCount: description.length);
                          }),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor:
                                Theme.of(context).colorScheme.error,
                            disabledForegroundColor:
                                Theme.of(context).colorScheme.onError,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 36),
                          ),
                          onPressed: !existInCart &&
                                  product.price[quantitySelection].stock == 0
                              ? null
                              : () {
                                  if (existInCart) {
                                    showModifyCartBottomSheet(
                                        context,
                                        product,
                                        cartProvider.cart
                                            .where((element) =>
                                                element.productId == product.id)
                                            .toList());
                                  } else {
                                    final cartItem = CartItem(
                                        productId: productId,
                                        quantity: 1,
                                        size: quantitySelection);
                                    cartProvider.addProductToCart(cartItem,
                                        ScaffoldMessenger.of(context));
                                  }
                                },
                          child: Row(
                            children: [
                              Text(
                                (existInCart
                                    ? 'Modify Cart'
                                    : (product.price[quantitySelection].stock ==
                                            0
                                        ? 'Out of Stock'
                                        : 'Add to Cart')),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !existInCart &&
                                                product.price[quantitySelection]
                                                        .stock ==
                                                    0
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onError
                                            : getThemedColor(
                                                context,
                                                const Color(0xFF264431),
                                                Colors.green.shade100)),
                              ),
                              const Spacer(),
                              Icon(
                                FeatherIcons.shoppingBag,
                                color: !existInCart &&
                                        product.price[quantitySelection]
                                                .stock ==
                                            0
                                    ? Theme.of(context).colorScheme.onError
                                    : getThemedColor(
                                        context,
                                        const Color(0xFF264431),
                                        Colors.green.shade100),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 12,
                      // ),
                      // FilledButton.icon(
                      //   onPressed: () async {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       BheeshmaSnackbar(
                      //           title: 'Just a moment...',
                      //           message: 'We are working on it',
                      //           contentType: ContentType.help),
                      //     );

                      //     Response imageResponse =
                      //         await get(Uri.parse(product.image));

                      //     Share.shareXFiles([
                      //       XFile.fromData(imageResponse.bodyBytes,
                      //           name: product.image
                      //               .split("/")
                      //               .last
                      //               .split("?")
                      //               .first,
                      //           mimeType:
                      //               'image/${product.image.split("/").last.split("?").first.split(".").last}')
                      //     ],
                      //         subject:
                      //             'Check out fresh ${product.name} on Bheeshma Naturals!',
                      //         text:
                      //             'Check out fresh ${product.name} on Bheeshma Naturals!\n${product.description}.\n\nOrder now at https://bheeshmanaturals.com/products/${product.id}');
                      //   },
                      //   icon: Icon(
                      //     FeatherIcons.share,
                      //     size: 16,
                      //   ),
                      //   label: Text("Share"),
                      // ),
                    ],
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
//                                 product.name,
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
//                   product.name,
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
//                       'Add to Bag',
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
