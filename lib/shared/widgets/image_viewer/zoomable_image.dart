import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImage extends StatefulWidget {
  const ZoomableImage({
    required this.imageProvider,
    required this.onScaleStateChanged,
  });

  final ImageProvider imageProvider;
  final Function onScaleStateChanged;

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final _controller = PhotoViewScaleStateController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: widget.imageProvider,
      // loadingBuilder: Center(
      //   child: CupertinoActivityIndicator(),
      // ),
      loadingBuilder:(BuildContext context, ImageChunkEvent? event)=> const Center(
        child:  SpinKitDoubleBounce(color: Colors.white),
      ),
      enableRotation: false,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: 5.0,
      scaleStateController: _controller,
      scaleStateChangedCallback: (PhotoViewScaleState s) {
        widget.onScaleStateChanged(s);
        if (s == PhotoViewScaleState.originalSize) {
          _controller.setInvisibly(PhotoViewScaleState.initial);
        }
      },
    );
  }
}
