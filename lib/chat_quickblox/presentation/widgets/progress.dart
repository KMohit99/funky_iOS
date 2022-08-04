import 'package:flutter/material.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class Progress extends StatelessWidget {
  final Alignment _alignment;
  final Color? color;

  Progress(this._alignment, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: _alignment,
        // height: 25,
        // width: 25,
        child:
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(color), strokeWidth: 2.5));
  }
}
