
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/image_viewer/zoomable_image.dart';

import 'package:photo_view/photo_view.dart';

import 'animated_interpolation.dart';



int mapToRange(int value, int low, int high) {
  assert(low <= high);
  if (value >= low && value <= high) {
    return value;
  }

  int len = high - low + 1;
  return value % len;
}

double mapValue(
    double value, double low1, double high1, double low2, double high2) {
  return low2 + (high2 - low2) * (value - low1) / (high1 - low1);
}

const Color kTranslucentBlackColor = Color(0x66000000);
const double _kMaxDragSpeed = 400.0;

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    this.initialIndex = 0,
    required this.imageProviders,
  });

  final int initialIndex;
  final List<ImageProvider> imageProviders;

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentPageIndex;

  //Spring
  late AnimationController _controllerSpring;
  bool runSpringComplete = true;

  late Animation<double>? _animation;

  // Drag vertical
  double translationY = 0;
  double snapPoint = 0;
  double midBound = 1.SH / 2;
  double upperBound = 1.SH;
  bool isDrag = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPageIndex = widget.initialIndex;
    initSpringAnimation();

    super.initState();
  }

  void initSpringAnimation() {
    _controllerSpring =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {


            if (_animation?.value != null && isDrag == false)
              setTranslationY(_animation?.value ?? 0);

            // widget.onChangeTranslationY(translationY);
          })
          ..addStatusListener((AnimationStatus status) {
            runSpringComplete = true;
          });
  }

  void runAnimateSpring({required double begin, required double end}) {
    runSpringComplete = false;

    _animation = _controllerSpring.drive(Tween(begin: begin, end: end));

    const SpringDescription spring = SpringDescription(
      damping: 20,
      mass: 1,
      stiffness: 100,

    );

    final SpringSimulation simulation = SpringSimulation(spring, 0, 1, 10);

    _controllerSpring.animateWith(simulation).whenCompleteOrCancel(() {
      if (snapPoint == upperBound) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerSpring.dispose();
    super.dispose();
  }

  void _onScaleStateChanged(PhotoViewScaleState scaleState) {
    // setState(() => _isLocked = scaleState != PhotoViewScaleState.initial);
  }

  void _onPageChanged(int index) {
    setState(() => _currentPageIndex =
        mapToRange(index, 0, widget.imageProviders.length - 1));
  }

  Widget _buildPage(dynamic _, int index) {
    final int idx = mapToRange(index, 0, widget.imageProviders.length - 1);
    final ImageProvider provider = widget.imageProviders[idx];

    return ZoomableImage(
      imageProvider: provider,
      onScaleStateChanged: _onScaleStateChanged,
    );
  }

  void setTranslationY(double translationY) {
    setState(() {
      this.translationY = translationY;
    });
  }

  void onVerticalDragStart(DragStartDetails detail) {
    isDrag = true;
  }

  void onVerticalDragUpdate(DragUpdateDetails detail) {
    if ((translationY + detail.delta.dy) >= 0) {
      setTranslationY(translationY + detail.delta.dy);
    } else {
      setTranslationY(0);
    }
  }

  void onVerticalDragEnd(DragEndDetails details) {
    isDrag = false;
    if (translationY < (snapPoint - midBound).abs()) {
      snapPoint = 0;
    } else {
      snapPoint = upperBound;
    }
    runAnimateSpring(begin: translationY, end: snapPoint);
  }

  Widget _wrapWithCloseGesture({required Widget child}) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      child: PhotoViewGestureDetectorScope(axis: Axis.vertical, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double opacity =
        InterpolationTween(inputRange: [0, 1.SH], outputRange: [1.0, 0.0])
            .transform(translationY);

    return Transform.translate(
      offset: Offset(0, translationY),
      child: Opacity(
        opacity: opacity,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            backgroundColor: kTranslucentBlackColor,
            middle: widget.imageProviders.length > 1
                ? Text(
                    '${_currentPageIndex + 1} of ${widget.imageProviders.length}',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                    ),
                  )
                : null,
            leading: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
          child: SafeArea(
            child: _wrapWithCloseGesture(
                child: PageView.builder(
              itemBuilder: _buildPage,
              physics: widget.imageProviders.length <= 1
                  ? const NeverScrollableScrollPhysics()
                  : null,
              controller: _pageController,
              onPageChanged: _onPageChanged,
            )),
          ),
        ),
      ),
    );
  }
}
