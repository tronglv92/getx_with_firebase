import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';

class AOptionNormal extends StatelessWidget {
  const AOptionNormal({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 0
        ),
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
              ),
              SizedBox(width: 10.W,),
              Text(label,style: txt14RegularRoboto(),)
            ],
          ),
        ));
  }
}
