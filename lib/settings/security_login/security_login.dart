import 'package:flutter/material.dart';
import 'package:funky_new/settings/security_login/saved_login_info.dart';
// import 'package:funky_project/settings/security_login/saved_login_info.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';
import 'change_password _screen.dart';

class Security_Login extends StatefulWidget {
  const Security_Login({Key? key}) : super(key: key);

  @override
  State<Security_Login> createState() => _Security_LoginState();
}

class _Security_LoginState extends State<Security_Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Privacy Settings',
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'Login security',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.to(ChangePassword());
                },
                child:  ListTile(
                  visualDensity: VisualDensity(horizontal: -4,vertical: 0),
                  title: Text(
                    'Password',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color:  HexColor('#582338'),
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.to(SaveLoginInfo());
                },
                child:  ListTile(
                  visualDensity: VisualDensity(horizontal: -4,vertical: 0),

                  title: Text(
                    'Saved login info',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color:  HexColor('#582338'),
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
