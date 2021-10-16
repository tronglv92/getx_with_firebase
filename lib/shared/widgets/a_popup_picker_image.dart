import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/w_divider_line.dart';


class APopupPickerImage extends StatelessWidget {
  const APopupPickerImage({Key? key, this.onPressTakePhoto, this.onPressChooseLibrary,this.onPressCancelImage})
      : super(key: key);
  final VoidCallback? onPressTakePhoto;
  final VoidCallback? onPressChooseLibrary;
  final VoidCallback? onPressCancelImage;
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.W),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14), color: Colors.white),
            child: Column(
              children: [
                Container(
                  height: 40.H,
                  child: Center(
                    child: Text(
                      'Load photos',
                      style: txt14RegularRoboto(color: Colors.grey),
                    ),
                  ),
                ),
                const WDividerLine(
                  height: 0.5,
                  color: Colors.grey,
                ),
                ElevatedButton(
                  onPressed: onPressTakePhoto,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20.H),
                    primary: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Take photo',
                      style: txt18RegularRoboto(color: Colors.blue),
                    ),
                  ),
                ),
                const WDividerLine(
                  height: 0.5,
                  color: Colors.grey,
                ),
                ElevatedButton(
                  onPressed: onPressChooseLibrary,
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20.H),
                      primary: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14)))),
                  child: Center(
                    child: Text(
                      'Choose From Library',
                      style: txt18RegularRoboto(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.H,
          ),
          ElevatedButton(
            onPressed: onPressCancelImage,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.H),
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            child: Center(
              child: Text(
                'Cancel',
                style: txt18BoldRoboto(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: bottomPadding,
          )
        ],
      ),
    );
  }
}
