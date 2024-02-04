import 'package:flutter/material.dart';

void NavigationPushReplacementAnimated(BuildContext context,Widget headTo,Curve curve){
  Navigator.of(context).pushReplacement(
      PageRouteBuilder(
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              alignment: Alignment.center,
              scale: Tween<double>(begin: 0.1, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            );
          },
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation){
            return headTo;
          })
  );
}

void NavigationPushReplacement(BuildContext context,Widget headTo){
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context){
        return headTo;
      })
  );
}

void NavigateTo(BuildContext context,Widget headTo){
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context){
        return headTo;
      })
  );
}

ButtonStyle getButtonStyle(Color color){
  return ButtonStyle(
    backgroundColor:MaterialStateProperty.all(
        color
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          //side: BorderSide(color: Colors.lightBlue)
        )
    ),
  );
}

Widget getToastWidget(String msg,Color color,IconData icon){
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        SizedBox(
          width: 8.0,
        ),
        Text(msg),
      ],
    ),
  );
  return toast;
}