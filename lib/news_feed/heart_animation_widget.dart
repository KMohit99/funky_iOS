import 'package:flutter/material.dart';

class HeartAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration? duration;
  final VoidCallback onEnd;

  const HeartAnimationWidget(
      {Key? key,
      required this.child,
      required this.isAnimating,
        this.duration =const Duration(milliseconds: 150), required this.onEnd})
      : super(key: key);

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final halfduration = widget.duration!.inMilliseconds ~/2;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: halfduration),
    );

    scale = Tween<double>(begin: 0, end: 1.2).animate(controller!);
  }

  @override
  void didUpdateWidget(covariant HeartAnimationWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating != oldWidget.isAnimating){
      doAnimation();
    }
  }
  Future doAnimation() async {
    await controller?.forward();
    await controller!.reverse();
    // await Future.delayed(Duration(milliseconds: 400));

    if(widget.onEnd != null){
      widget.onEnd();
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    child: widget.child,
    scale: scale!,
  );

}
