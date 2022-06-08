import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/asset_utils.dart';
import '../search_screen/search__screen_controller.dart';
import 'controller.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({Key? key}) : super(key: key);

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  final Settings_screen_controller _settings_screen_controller = Get.put(
      Settings_screen_controller(),
      tag: Settings_screen_controller().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
   await  _settings_screen_controller.getBlockList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() =>
            (_settings_screen_controller.isSearchLoading.value == true)
                ? SizedBox.shrink()
                : ListView.builder(
              itemCount: _settings_screen_controller
                  .blockListModel!.data!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Container(
                      height: 70,
                      width: 70,
                      // color: Colors.white,
                      child: IconButton(
                        icon: Image.asset(
                          AssetUtils.user_icon3,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {},
                      )),
                    title: Text(
                      _settings_screen_controller
                          .blockListModel!.data![index].fullName!,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'PR'),
                    ),
                    subtitle: Text(
                      _settings_screen_controller
                          .blockListModel!.data![index].userName!,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'PR'),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        print(_settings_screen_controller
                            .blockListModel!.data![index].id);
                        _settings_screen_controller.Block_unblock_api(
                            context: context,
                            user_id: _settings_screen_controller
                                .blockListModel!.data![index].id!,
                            user_name: _settings_screen_controller
                                .blockListModel!.data![index].userName!,
                            social_bloc_type: _settings_screen_controller
                                .blockListModel!.data![index].socialType!,
                            block_unblock: "Unblock");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          child: Text(
                            'Unblock',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PR'),
                          ),
                        ),
                      ),
                    ));
              },
            ))),
      ),
    );
  }
}
