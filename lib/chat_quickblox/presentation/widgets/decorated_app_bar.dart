import 'package:flutter/material.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class DecoratedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _shadowHeight = 0;

  const DecoratedAppBar({Key? key, required this.appBar}) : super(key: key);

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: this.appBar,
          decoration: new BoxDecoration(
            boxShadow: [

            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + _shadowHeight);
}
