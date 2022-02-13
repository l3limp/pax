import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pax/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation1 = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));
  late final Animation<Offset> _offsetAnimation2 = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2;
    OurTheme _theme = OurTheme();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/init');
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: AnimationLimiter(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:
                                      AnimationConfiguration.toStaggeredList(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    childAnimationBuilder: (widget) =>
                                        SlideAnimation(
                                      horizontalOffset: -50.0,
                                      child: FadeInAnimation(
                                        child: widget,
                                      ),
                                    ),
                                    children: [
                                      Text(
                                        "HAVE\n",
                                        style: TextStyle(
                                            color: _theme.primaryColor,
                                            letterSpacing: .5,
                                            fontSize: 30),
                                      ),
                                      Text(
                                        "CRAX\n",
                                        style: TextStyle(
                                            color: _theme.primaryColor,
                                            letterSpacing: .5,
                                            fontSize: 30),
                                      ),
                                      Text(
                                        "WITH\n",
                                        style: TextStyle(
                                            color: _theme.primaryColor,
                                            letterSpacing: .5,
                                            fontSize: 30),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Center(
                                          child: Text(
                                            "PAX\n",
                                            style: TextStyle(
                                                color: _theme.primaryColor,
                                                letterSpacing: .5,
                                                fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SlideTransition(
                    position: _offsetAnimation1,
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: _theme.secondaryColor),
                  ),
                  SlideTransition(
                    position: _offsetAnimation2,
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: _theme.primaryColor),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
