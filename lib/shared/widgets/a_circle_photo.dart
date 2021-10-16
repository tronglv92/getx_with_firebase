import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_button_circle.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ACirclePhoto extends StatefulWidget {
  const ACirclePhoto(
      {Key? key,
        required this.photoUrl,
      required this.onPressPhoto,
      required this.onPressEdit,
      this.showLoading = false})
      : super(key: key);
  final String? photoUrl;
  final VoidCallback? onPressPhoto;
  final VoidCallback onPressEdit;
  final bool showLoading;

  @override
  _ACirclePhotoState createState() => _ACirclePhotoState();
}

class _ACirclePhotoState extends State<ACirclePhoto> {
  @override
  Widget build(BuildContext context) {
    final double width = 120.W;
    return WButtonCircle(
      width: width,
      onPressed: widget.showLoading == false ? widget.onPressPhoto : null,
      color: Colors.grey,
      child: Stack(
        children: [
          if (widget.photoUrl?.isNullOrEmpty==false)
            ClipRRect(
              borderRadius: BorderRadius.circular(width / 2),
              child: CachedNetworkImage(
                imageUrl: widget.photoUrl!,
                fit: BoxFit.contain,
                width: width,
                height: width,
                placeholder: (BuildContext context, String url) =>
                    SpinKitCircle(
                  color: Colors.white,
                  size: 20.0.W,
                ),
                errorWidget: (BuildContext context, String url, dynamic error) {
                  logger.e('error ', error);
                  return Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 50.W,
                  );
                },
              ),
            ),
          Positioned(
            right: 10.W,
            bottom: 10.W,
            child: WButtonCircle(
              onPressed: widget.onPressEdit,
              width: 30.W,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20.W,
                ),
              ),
            ),
          ),
          if (widget.showLoading)
            Positioned.fill(
                child: SpinKitCircle(
              color: Colors.white,
              size: 20.0.W,
            )),
        ],
      ),
    );
  }
}
