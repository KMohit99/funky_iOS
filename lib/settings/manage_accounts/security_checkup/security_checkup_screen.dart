import 'package:flutter/material.dart';
import 'package:funky_new/settings/manage_accounts/security_checkup/phone_number_verification.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
// import 'package:funky_project/settings/manage_accounts/security_checkup/phone_number_verification.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import 'email_verification.dart';

class SecurityCheckup extends StatefulWidget {
  const SecurityCheckup({Key? key}) : super(key: key);

  @override
  State<SecurityCheckup> createState() => _SecurityCheckupState();
}

class _SecurityCheckupState extends State<SecurityCheckup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Security checkup',
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
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 134,
                width: 134,
                child: ClipRRect(
                    // borderRadius: BorderRadius.circular(100),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            HexColor("#000000"),
                            HexColor("#C12265"),
                            HexColor("#FFFFFF")
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Image.asset(
                          AssetUtils.security_3x,
                          height: 53,
                          width: 65,
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 51,),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 54),
                child: Text(
                  'Help secure your acccount',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(height: 51,),
              GestureDetector(
                onTap: (){
                  Get.to(EmailVerification());
                },
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                  dense: true,
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mail,
                      color: HexColor(CommonColor.pinkFont),
                    ),
                  ),
                  title: Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR'),
                  ),
                  subtitle: Text(
                    'Create a stronger password',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white , fontFamily: 'PR'),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                height: 1,
                color: HexColor('#E84F90').withOpacity(0.15),
              ),
              GestureDetector(
                onTap: (){
                  Get.to(MobileVerification());
                },
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                  dense: true,
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mail,
                      color: HexColor(CommonColor.pinkFont),
                    ),
                  ),
                  title: Text(
                    'Mobile phone number',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR'),
                  ),
                  subtitle: Text(
                    'Check that your mobile number is correct',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white , fontFamily: 'PR'),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                height: 1,
                color: HexColor('#E84F90').withOpacity(0.15),
              ),
              Container(
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                  dense: true,
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mail,
                      color: HexColor(CommonColor.pinkFont),
                    ),
                  ),

                  title: Text(
                    'Two-factor authentication',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR'),
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
