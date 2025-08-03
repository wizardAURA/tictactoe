import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin:0.0, end: 1.0).animate(_controller!)..addListener((){
      setState(() {});
    });
    _controller!.forward();
    Timer(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacementNamed('/game');
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: FadeTransition(opacity: _animation!,child: Image.asset('assets/images/tic.png',
      width: 150,
      height: 150,))),
    );
  }
}
