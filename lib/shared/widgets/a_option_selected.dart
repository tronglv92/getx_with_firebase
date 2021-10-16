import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';

class AOption extends StatelessWidget {
  const AOption({required this.label,this.isSelected=false,this.onPress});
  final String label;
  final bool? isSelected;
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            primary: isSelected==true? const Color.fromRGBO(243, 244, 247, 1):Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side:  BorderSide(
                  color: isSelected==true?Colors.deepOrange:Colors.transparent, width: 1),
            )),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.W,vertical: 15.H),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 20.W,
                  width: 20.W,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20.W/2,
                    ),
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey, width: 1),
                  ),
                  child:isSelected==true? Center(
                    child: Container(
                      height: 10.W,
                      width: 10.W,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10.W/2,

                        ),
                        color: Colors.deepOrange,
                      ),
                    ),
                  ):Container()),
              SizedBox(width: 10.W,),
              Text(label,style: txt14RegularRoboto(),)
            ],
          ),
        ));
  }
}
