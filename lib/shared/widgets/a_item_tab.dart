import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';

class AItemTab extends StatelessWidget {
  const AItemTab({required this.label,required this.iconData,this.isSelected=false,required this.onPress,required this.index});
  final String label;
  final IconData iconData;
  final bool isSelected;
  final Function onPress;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress(index);
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 15.H,
            ),
             Icon(
              iconData,
              color:isSelected==true? Colors.deepOrange:Colors.grey,
              size: 25,
            ),
            SizedBox(
              height: 2.H,
            ),
            Text(
              label,
              style: txt10RegularRoboto(color: isSelected==true? Colors.deepOrange:Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
