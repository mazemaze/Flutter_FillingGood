import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:help_me_save/admob/admob.dart';
import 'package:help_me_save/screens/animated_background.dart';
import 'package:help_me_save/utils/color.dart';
import 'dart:math';

import 'package:help_me_save/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final BannerAd myBanner = BannerAd(
    adUnitId: AdMobService().getBannerAdUnitId()!,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  TextEditingController goal = TextEditingController();
  TextEditingController goalAmount = TextEditingController();
  TextEditingController amount = TextEditingController();
  late int currentAmount;
  late String currentGoal;
  late int currentGoalAmount;
  late AnimationController _controller;
  int padValue = 1;
  void initData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      currentAmount = pref.getInt("amount") ?? 0;
      currentGoal = pref.getString("goal") ?? "未設定";
      currentGoalAmount = pref.getInt("goalAmount") ?? 0;
      padValue = ((currentAmount / currentGoalAmount) * 10).toInt();
      print(padValue);
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
    myBanner.load();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      reverseDuration: Duration(seconds: 2),
    );
    print(_controller.status);
    _controller
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
    _controller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: oxfordBlue,
          ),
          AnimatedBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "目標：$currentGoal",
                  style: TextStyle(
                    color: platinum,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "目標金額：¥$currentGoalAmount",
                  style: TextStyle(
                    color: platinum,
                    fontSize: 14,
                  ),
                ),
                _buildAnimatedCircle(context),
                _buildGoalSettingButtons(context),
              ],
            ),
          ),
          _buildAdMobBanner(context),
        ],
      ),
    );
  }

  Align _buildAdMobBanner(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
        child: AdWidget(ad: myBanner),
      ),
    );
  }

  Widget _buildAnimatedCircle(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        width: 200,
        height: 200,
        child: MyFillingContainer(
          amount: "$currentAmount",
          progress: padValue / 10,
          size: 200,
          backgroundColor: Colors.black,
          progressColor: Colors.blue,
          function: () => showDialog(
            context: context,
            builder: (_) => _buildInputDialog(context, () {
              LocalStorageService().addAmount(
                currentAmount,
                int.parse(
                  amount.text,
                ),
              );
              initData();
              amount.text = "";
              Navigator.of(context).pop();
            }, amount, "貯金額を入力", TextInputType.number),
          ),
        ),
      ),
      builder: (context, child) => Transform.translate(
        offset: Offset(_controller.value * 2, _controller.value * 10),
        child: child,
      ),
    );
  }

  Widget _buildInputDialog(BuildContext context, VoidCallback callback,
      TextEditingController tc, String title, TextInputType type) {
    return SimpleDialog(
      backgroundColor: oxfordBlue,
      title: Text(
        title,
        style: TextStyle(color: platinum),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: tc,
            keyboardType: type,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
            color: oxfordBlue.shade900,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextButton(
            onPressed: callback,
            child: Text("入力", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSettingButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: oxfordBlue.shade900,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _buildInputDialog(context, () {
                  setState(() {
                    LocalStorageService().saveNewGoal(goal.text);
                    initData();
                    Navigator.of(context).pop();
                    goal.text = "";
                  });
                }, goal, "貯金の目標を入力", TextInputType.text),
              ),
              child: Text(
                "目標",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: oxfordBlue.shade900,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _buildInputDialog(
                  context,
                  () => setState(() {
                    LocalStorageService()
                        .setToNewGoalAmount(int.parse(goalAmount.text));
                    initData();
                    Navigator.of(context).pop();
                    goalAmount.text = "";
                  }),
                  goalAmount,
                  "目標額を入力",
                  TextInputType.number,
                ),
              ),
              child: Text("目標額", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: oxfordBlue.shade900,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextButton(
              onPressed: () {
                LocalStorageService().resetAmount();
                initData();
              },
              child: Text("貯金額リセット", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFillingContainer extends StatefulWidget {
  final double? progress;
  final double? size;
  final Color? backgroundColor;
  final Color? progressColor;
  final String? amount;
  final VoidCallback? function;
  const MyFillingContainer(
      {Key? key,
      this.function,
      this.amount,
      this.progress,
      this.size,
      this.backgroundColor,
      this.progressColor})
      : super(key: key);

  @override
  State<MyFillingContainer> createState() => _MyFillingContainerState();
}

class _MyFillingContainerState extends State<MyFillingContainer>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size!),
        child: SizedBox(
          height: widget.size,
          width: widget.size,
          child: Stack(
            children: [
              Container(
                color: widget.backgroundColor,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: widget.size! * widget.progress!,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (ctx, child) => Stack(
                      children: [
                        ClipPath(
                          child: Container(
                            color: Colors.blue,
                          ),
                          clipper:
                              WaveClipper(context, _controller.value, 0, 1),
                        ),
                        ClipPath(
                          child: Container(color: Colors.blueAccent),
                          clipper:
                              WaveClipper(context, _controller.value, 0.5, 1),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ("現在：¥${widget.amount!}"),
                        style: TextStyle(
                          color: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        ("タップして貯金額追加"),
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WaveClipper extends CustomClipper<Path> {
  WaveClipper(this.context, this.waveControllerValue, this.offset, this.value) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height / value;

    for (var i = 0; i <= width / 3; i++) {
      final step = (i / width) - waveControllerValue;
      coordinateList.add(
        Offset(
          i.toDouble() * 3,
          sin(step * 2 * pi - offset) * 45 + height * 0.5,
        ),
      );
    }
  }

  final value;
  final BuildContext context;
  final double waveControllerValue;
  final double offset;
  final List<Offset> coordinateList = [];

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addPolygon(coordinateList, false)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      waveControllerValue != oldClipper.waveControllerValue;
}
