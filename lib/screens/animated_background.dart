import 'package:flutter/material.dart';
import 'package:help_me_save/screens/home_screen.dart';
import 'package:help_me_save/utils/color.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController waveController;
  final padValue = 1;
  final progress = 0.1;
  @override
  void initState() {
    super.initState();
    waveController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        child: AnimatedBuilder(
          animation: waveController, // waveControllerを設定
          builder: (context, child) => Stack(
            children: <Widget>[
              Container(color: oxfordBlue),
              // ↓ 追加部分
              // 1
              ClipPath(
                // 3
                child: Container(color: oxfordBlue.shade800),
                // 2
                clipper: WaveClipper(context, waveController.value, 2000, 1),
              ),
              ClipPath(
                child: Container(color: oxfordBlue.withOpacity(0.4)),
                clipper: WaveClipper(context, waveController.value, 0.5, 1),
              ),
              // ↑ 追加部分
            ],
          ),
        ),
      ),
    );
  }
}
