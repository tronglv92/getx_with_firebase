import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';

class AItemTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 5,
            shadowColor: Colors.white.withOpacity(0.5),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.W,vertical: 15.H)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.W,
              width: 50.W,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(229, 228, 229, 1),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: const Color.fromRGBO(174, 173, 174, 1),
                  size: 30.W,
                ),
              ),
            ),
            SizedBox(width: 15.W,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 5.H,),
                  Text('Wesame Shama',style: txt16RegularRoboto(),),
                  SizedBox(height: 8.H,),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5.W,
                      ),
                      Text(
                        '20 My 2021 | 04:28 PM',
                        style: txt12RegularRoboto(),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.W,vertical: 6.H),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.orangeAccent.withOpacity(0.2),
              ),
              child: Text('Pending',style: txt10RegularRoboto(color: Colors.deepOrange),),
            )
          ],
        ));
  }
}
