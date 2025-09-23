import 'package:flutter/material.dart';
import 'fullscreen_image_page.dart'; // 👈 Make sure you create this page

class ProductDetailsPage extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String image;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> comments = [
      {
        'name': 'Alice',
        'photo': 'assets/users/user1.jpg',
        'rating': '5',
        'comment': 'Great product, highly recommended!',
      },
      {
        'name': 'Bob',
        'photo': 'assets/users/user2.jpg',
        'rating': '4',
        'comment': 'Very good quality for the price.',
      },
      {
        'name': 'Catherine',
        'photo': 'assets/users/user7.jpg',
        'rating': '4.5',
        'comment': 'Looks nice and works well.',
      },
      {
        'name': 'David',
        'photo': 'assets/users/user4.jpg',
        'rating': '5',
        'comment': 'I loved it! Shipping was fast.',
      },
      {
        'name': 'Emma',
        'photo': 'assets/users/user6.jpg',
        'rating': '3.5',
        'comment': 'It’s okay, could be better.',
      },
    ];

    final List<Color> availableColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    final List<String> sizes = ['S', 'M', 'L', 'XL'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image_$image', // unique tag for the animation
              child: GestureDetector(
                onTap: () async {
                  // Pre-cache the image before navigation
                  await precacheImage(AssetImage(image), context);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImagePage(image: image),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ↓↓↓ Add Padding around everything after the image ↓↓↓
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Rating: ⭐ 4.5', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    'Available Sizes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: sizes.map((s) => Chip(label: Text(s))).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Available Colors',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: availableColors
                        .map(
                          (c) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Customer Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...comments.map(
                    (c) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(c['photo']!),
                      ),
                      title: Text(c['name']!),
                      subtitle: Text(c['comment']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(c['rating']!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
