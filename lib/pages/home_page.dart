import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> _isFav = List.generate(30, (_) => false);

  final List<String> _images = [
    'assets/images/book1.jpg',
    'assets/images/book2.jpg',
    'assets/images/blender1.jpg',
    'assets/images/cloths1.jpg',
    'assets/images/cloths2.jpg',
    'assets/images/car.jpg',
    'assets/images/microwave1.jpg',
    'assets/images/pc1.jpg',
    'assets/images/phone1.jpg',
    'assets/images/food1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ translations

    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 800;
    final int crossAxisCount = isDesktop ? 9 : 3;
    final int itemCount = isDesktop ? 30 : 15;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.products), // ✅ localized
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.55,
        ),
        itemBuilder: (context, index) {
          final productName = '${t.product} ${index + 1}'; // ✅ localized
          final productPrice =
              '${t.price}: \$${(index + 1) * 5}'; // ✅ localized
          final productImage = _images[index % _images.length];
          final productDesc = '${t.description} ${index + 1}'; // ✅ localized

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(
                    name: productName,
                    price: productPrice,
                    image: productImage,
                    description: productDesc,
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              productImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          productName,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productPrice,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                SizedBox(width: 2),
                                Text('4.5', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFav[index] = !_isFav[index];
                      });
                    },
                    child: Icon(
                      _isFav[index] ? Icons.favorite : Icons.favorite_border,
                      color: _isFav[index] ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
