import 'package:flutter/material.dart';
// import 'package:funky_project/controller/controllers_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../controller/controllers_class.dart';
import '../custom_widget/common_buttons.dart';
import '../getx_pagination/binding_utils.dart';

class SignupOption extends StatefulWidget {
  const SignupOption({Key? key}) : super(key: key);

  @override
  State<SignupOption> createState() => _SignupOptionState();
}

class _SignupOptionState extends State<SignupOption> {
  final SignUp_option_controller _signUp_option_controller =
  Get.put(SignUp_option_controller(), tag:SignUp_option_controller().toString());

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<SignUp_option_controller>(
      init: _signUp_option_controller,
      builder: (GetxController controller) {
        return  Stack(
          children: [
            // Container(
            //   color: Colors.black,
            //   height: MediaQuery.of(context).size.height,
            // ),
            Container(
              // decoration: BoxDecoration(
              //
              //   image: DecorationImage(
              //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
              //     fit: BoxFit.cover,
              //   ),
              // ),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   // stops: [0.1, 0.5, 0.7, 0.9],
                //   colors: [
                //     HexColor("#000000").withOpacity(0.5),
                //     HexColor("#000000").withOpacity(0.5),
                //     HexColor("#C12265").withOpacity(0.15),
                //     HexColor("#C12265").withOpacity(0.3),
                //     HexColor("#C12265").withOpacity(0.3),
                //     HexColor("#C12265").withOpacity(0.4),
                //     HexColor("#C12265").withOpacity(0.5),
                //     HexColor("#FFFFFF").withOpacity(0.5),
                //   ],
                // ),
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new AssetImage(
                    AssetUtils.backgroundImage5,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
              body: Container(
                width: screenwidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 86),
                        child: Image.asset(AssetUtils.logo,fit: BoxFit.cover,),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                        child: Text(
                          'Signup as',
                          style: TextStyle(fontSize: 16, fontFamily: 'PB',color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 41,
                      ),

                      common_button(
                        onTap: (){
                          Get.toNamed(BindingUtils.creator_signup);
                        },
                        backgroud_color: Colors.black,
                        lable_text: 'Creator',
                        lable_text_color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      common_button(
                        onTap: (){
                          Get.toNamed(BindingUtils.advertiser_signup);
                        },
                        backgroud_color: Colors.white,
                        lable_text: 'Advertiser',
                        lable_text_color: Colors.black,
                      ),

                      SizedBox(
                        height:20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
