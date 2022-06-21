import 'package:flutter/material.dart';

import 'asset_utils.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final String lable_tex;

  // final VoidCallback ondrawertap;
  const CustomAppbar(
      {Key? key, required this.lable_tex,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          lable_tex,
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, top: 0.0, bottom: 5.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AssetUtils.noti_icon,
                      height: 20.0,
                      width: 20.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, top: 0.0, bottom: 5.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AssetUtils.chat_icon,
                      height: 20.0,
                      width: 20.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
        leadingWidth: 100,
        leading: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 0, bottom: 0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: (Image.asset(
                    AssetUtils.drawer_icon,
                    color: Colors.white,
                    height: 12.0,
                    width: 19.0,
                    fit: BoxFit.contain,
                  ))),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 18, top: 0, bottom: 0),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: (Image.asset(
                      AssetUtils.user_icon,
                      color: Colors.white,
                      height: 20.0,
                      width: 20.0,
                      fit: BoxFit.contain,
                    ))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
