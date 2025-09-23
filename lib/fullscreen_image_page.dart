import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class FullscreenImagePage extends StatefulWidget {
  final String image;
  const FullscreenImagePage({super.key, required this.image});

  @override
  State<FullscreenImagePage> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  Color _bgColor = Colors.black;
  late final Future<void> _loadImage;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _extractColor();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _loadImage = precacheImage(AssetImage(widget.image), context);
      _precached = true;
    }
  }

  Future<void> _extractColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.image),
    );
    if (mounted) {
      setState(() {
        _bgColor = palette.dominantColor?.color ?? Colors.black;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadImage,
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _bgColor,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(widget.image, fit: BoxFit.cover),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Center(
                  child: Hero(
                    tag: 'image_${widget.image}',
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
