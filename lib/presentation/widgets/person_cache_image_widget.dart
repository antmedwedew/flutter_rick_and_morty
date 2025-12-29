import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonCacheImage extends StatelessWidget {
  final String? imageUrl;
  final double width, height;

  const PersonCacheImage({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) {
        return _imageWidget(imageProvider);
      },
      placeholder: (context, url) {
        return Center(child: CircularProgressIndicator());
      },
      errorWidget: (context, url, error) {
        return _imageWidget(AssetImage('assets/images/noimage.png'));
      },
    );
  }

  Widget _imageWidget(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }
}
