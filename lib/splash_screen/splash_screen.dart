import 'package:editingapp/home/UI/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
      // duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      splashIconSize: mq.height * 5,
      splash: Container(
        width: mq.width * .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mq.width * .3,
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
            SizedBox(
              height: mq.height * .0300,
            ),
            Text(
              "celebrare",
              style: TextStyle(
                  fontFamily: 'DancingScript', fontSize: mq.width * .1),
            )
          ],
        ),
      ),
      nextScreen: pick_image(),
      animationDuration: Duration(seconds: 3),
    );
  }
}
