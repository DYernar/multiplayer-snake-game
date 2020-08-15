import 'package:brain_wars/features/snake_game/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 1920, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => GameScreen(),
                ),
              );
            },
            child: Container(
              height: ScreenUtil().setHeight(130),
              width: ScreenUtil().setWidth(400),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 55.0,
                      spreadRadius: 15.0,
                      color: Colors.grey[600])
                ],
              ),
              child: Center(
                child: Text(
                  "Play",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
