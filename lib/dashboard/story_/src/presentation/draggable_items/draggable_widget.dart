import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../Utils/App_utils.dart';
import '../../domain/models/editable_items.dart';

// import 'package:stories_editor/src/domain/models/editable_items.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/gradient_notifier.dart';
// import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
// import 'package:stories_editor/src/presentation/utils/constants/item_type.dart';
// import 'package:stories_editor/src/presentation/utils/constants/text_animation_type.dart';
// import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';
// import 'package:stories_editor/src/presentation/widgets/file_image_bg.dart';

import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/story_/src/presentation/text_editor_view/widgets/animation_selector.dart';
import 'package:funky_new/dashboard/story_/src/presentation/text_editor_view/widgets/font_selector.dart';
import 'package:funky_new/dashboard/story_/src/presentation/text_editor_view/widgets/text_field_widget.dart';
import 'package:funky_new/dashboard/story_/src/presentation/text_editor_view/widgets/top_text_tools.dart';
import 'package:provider/provider.dart';

import '../../domain/models/editable_items.dart';
import '../../domain/providers/notifiers/control_provider.dart';
import '../../domain/providers/notifiers/draggable_widget_notifier.dart';
import '../../domain/providers/notifiers/gradient_notifier.dart';
import '../../domain/providers/notifiers/text_editing_notifier.dart';
import '../utils/constants/item_type.dart';
import '../utils/constants/text_animation_type.dart';
import '../widgets/animated_onTap_button.dart';
import '../widgets/color_selector.dart';
import '../widgets/file_image_bg.dart';
import '../widgets/size_slider_selector.dart';

class DraggableWidget extends StatefulWidget {
  final EditableItem draggableWidget;
  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerMoveEvent)? onPointerMove;
  final BuildContext context;

  const DraggableWidget({
    Key? key,
    required this.context,
    required this.draggableWidget,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  }) : super(key: key);

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  VideoPlayerController? controller_last;

  @override
  void initState() {
    super.initState();

    var _control = Provider.of<ControlNotifier>(context, listen: false);

    controller_last = VideoPlayerController.file(File(_control.mediaPath));

    controller_last!.setLooping(true);
    controller_last!.initialize().then((_) {
      setState(() {});
    });
    controller_last!.play();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    controller_last!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _colorProvider =
        Provider.of<GradientNotifier>(widget.context, listen: false);
    var _controlProvider =
        Provider.of<ControlNotifier>(widget.context, listen: false);
    Widget overlayWidget;

    switch (widget.draggableWidget.type) {
      case ItemType.text:
        overlayWidget = IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 50,
                minWidth: 50,
                maxWidth: _size.width - 120,
              ),
              width: widget.draggableWidget.deletePosition ? 100 : null,
              height: widget.draggableWidget.deletePosition ? 100 : null,
              child: AnimatedOnTapButton(
                onTap: () => _onTap(context, widget.draggableWidget, _controlProvider),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: _text(
                          background: true,
                          paintingStyle: PaintingStyle.fill,
                          controlNotifier: _controlProvider),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Center(
                        child: _text(
                            background: true,
                            paintingStyle: PaintingStyle.stroke,
                            controlNotifier: _controlProvider),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.5, top: 2),
                      child: Stack(
                        children: [
                          Center(
                            child: _text(
                                paintingStyle: PaintingStyle.fill,
                                controlNotifier: _controlProvider),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        break;

      /// image [file_image_gb.dart]
      case ItemType.image:
        if (_controlProvider.mediaPath.isNotEmpty) {
          overlayWidget = Container(
            width: _size.width - 72,
            child: FileImageBG(
              filePath: File(_controlProvider.mediaPath),
              generatedGradient: (color1, color2) {
                _colorProvider.color1 = color1;
                _colorProvider.color2 = color2;
              },
            ),
          );
        } else {
          overlayWidget = Container();
        }

        break;

      case ItemType.gif:
        overlayWidget = SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// create Gif widget
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  child: GiphyRenderImage.original(gif: widget.draggableWidget.gif),
                ),
              ),
            ],
          ),
        );
        break;

      case ItemType.video:
        if (_controlProvider.mediaPath.isNotEmpty) {
          overlayWidget = SizedBox(
            width: _size.width - 72,
            child: VideoPlayer(controller_last!),
          );
        } else {
          overlayWidget = Container();
        }
      // overlayWidget = const Center();
    }

    /// set widget data position on main screen
    return AnimatedAlignPositioned(
      duration: const Duration(milliseconds: 50),
      dy: (widget.draggableWidget.deletePosition
          ? _deleteTopOffset(_size)
          : (widget.draggableWidget.position.dy * _size.height)),
      dx: (widget.draggableWidget.deletePosition
          ? 0
          : (widget.draggableWidget.position.dx * _size.width)),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: widget.draggableWidget.deletePosition
            ? _deleteScale()
            : widget.draggableWidget.scale,
        child: Transform.rotate(
          angle: widget.draggableWidget.rotation,
          child: Listener(
            onPointerDown: widget.onPointerDown,
            onPointerUp: widget.onPointerUp,
            onPointerMove: widget.onPointerMove,

            /// show widget
            child: overlayWidget,
          ),
        ),
      ),
    );
  }

  /// text widget
  Widget _text(
      {required ControlNotifier controlNotifier,
      required PaintingStyle paintingStyle,
      bool background = false}) {
    if (widget.draggableWidget.animationType == TextAnimationType.none) {
      return Text(widget.draggableWidget.text,
          textAlign: widget.draggableWidget.textAlign,
          style: _textStyle(
              controlNotifier: controlNotifier,
              paintingStyle: paintingStyle,
              background: background));
    } else {
      return DefaultTextStyle(
        style: _textStyle(
            controlNotifier: controlNotifier,
            paintingStyle: paintingStyle,
            background: background),
        child: AnimatedTextKit(
          repeatForever: true,
          onTap: () => _onTap(widget.context, widget.draggableWidget, controlNotifier),
          animatedTexts: [
            if (widget.draggableWidget.animationType == TextAnimationType.scale)
              ScaleAnimatedText(widget.draggableWidget.text,
                  duration: const Duration(milliseconds: 1200)),
            if (widget.draggableWidget.animationType == TextAnimationType.fade)
              ...widget.draggableWidget.textList.map((item) => FadeAnimatedText(item,
                  duration: const Duration(milliseconds: 1200))),
            if (widget.draggableWidget.animationType == TextAnimationType.typer)
              TyperAnimatedText(widget.draggableWidget.text,
                  speed: const Duration(milliseconds: 500)),
            if (widget.draggableWidget.animationType == TextAnimationType.typeWriter)
              TypewriterAnimatedText(
                widget.draggableWidget.text,
                speed: const Duration(milliseconds: 500),
              ),
            if (widget.draggableWidget.animationType == TextAnimationType.wavy)
              WavyAnimatedText(
                widget.draggableWidget.text,
                speed: const Duration(milliseconds: 500),
              ),
            if (widget.draggableWidget.animationType == TextAnimationType.flicker)
              FlickerAnimatedText(
                widget.draggableWidget.text,
                speed: const Duration(milliseconds: 1200),
              ),
          ],
        ),
      );
    }
  }

  _textStyle(
      {required ControlNotifier controlNotifier,
      required PaintingStyle paintingStyle,
      bool background = false}) {
    return TextStyle(
      fontFamily: controlNotifier.fontList![widget.draggableWidget.fontFamily],
      package: controlNotifier.isCustomFontList ? null : 'stories_editor',
      fontWeight: FontWeight.w500,
      // shadows: <Shadow>[
      //   Shadow(
      //       offset: const Offset(0, 0),
      //       //blurRadius: 3.0,
      //       color: draggableWidget.textColor == Colors.black
      //           ? Colors.white54
      //           : Colors.black)
      // ]
    ).copyWith(
        color: background ? Colors.black : widget.draggableWidget.textColor,
        fontSize: widget.draggableWidget.deletePosition ? 8 : widget.draggableWidget.fontSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = widget.draggableWidget.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1));
  }

  _deleteTopOffset(size) {
    double top = 0.0;
    if (widget.draggableWidget.type == ItemType.text) {
      top = size.width / 1.3;
      return top;
    } else if (widget.draggableWidget.type == ItemType.gif) {
      top = size.width / 1.3;
      return top;
    }
  }

  _deleteScale() {
    double scale = 0.0;
    if (widget.draggableWidget.type == ItemType.text) {
      scale = 0.4;
      return scale;
    } else if (widget.draggableWidget.type == ItemType.gif) {
      scale = 0.3;
      return scale;
    }
  }

  /// onTap text
  void _onTap(BuildContext context, EditableItem item,
      ControlNotifier controlNotifier) {
    var _editorProvider =
        Provider.of<TextEditingNotifier>(this.widget.context, listen: false);
    var _itemProvider =
        Provider.of<DraggableWidgetNotifier>(this.widget.context, listen: false);

    /// load text attributes
    _editorProvider.textController.text = item.text.trim();
    _editorProvider.text = item.text.trim();
    _editorProvider.fontFamilyIndex = item.fontFamily;
    _editorProvider.textSize = item.fontSize;
    _editorProvider.backGroundColor = item.backGroundColor;
    _editorProvider.textAlign = item.textAlign;
    _editorProvider.textColor =
        controlNotifier.colorList!.indexOf(item.textColor);
    _editorProvider.animationType = item.animationType;
    _editorProvider.textList = item.textList;
    _editorProvider.fontAnimationIndex = item.fontAnimationIndex;
    _itemProvider.draggableWidget
        .removeAt(_itemProvider.draggableWidget.indexOf(item));
    _editorProvider.fontFamilyController = PageController(
      initialPage: item.fontFamily,
      viewportFraction: .1,
    );

    /// create new text item
    controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
  }
}
