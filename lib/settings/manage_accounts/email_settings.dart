import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';

class EmailSettings extends StatefulWidget {
  const EmailSettings({Key? key}) : super(key: key);

  @override
  State<EmailSettings> createState() => _EmailSettingsState();
}

class _EmailSettingsState extends State<EmailSettings> {
  bool isSwitched = false;
  String selected = 'security';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Email from Funky',
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
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'security';
                        });
                      },
                      child: Text(
                        'Security',
                        style: TextStyle(
                            fontSize: 16,
                            color: (selected == 'security'
                                ? HexColor(CommonColor.pinkFont)
                                :Colors.white),
                            fontFamily: 'PR'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'others';
                        });
                      },
                      child: Text(
                        'Others',
                        style: TextStyle(
                            fontSize: 16,
                            color: (selected == 'others'
                                ? HexColor(CommonColor.pinkFont)
                                :Colors.white),
                            fontFamily: 'PR'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              (selected == 'security'
                  ? Security_container()
                  : Others_container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget Security_container() {
    return Container(
      child: Text(
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.",
        style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR',height: 1.5 ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget Others_container() {
    return Container(
      child: Text(
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.",
        style: TextStyle(
            fontSize: 16, color: HexColor('#B5B5B5'), fontFamily: 'PR',height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
