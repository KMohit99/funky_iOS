import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';

class Temrs_servicesScreen extends StatefulWidget {
  const Temrs_servicesScreen({Key? key}) : super(key: key);

  @override
  State<Temrs_servicesScreen> createState() => _Temrs_servicesScreenState();
}

class _Temrs_servicesScreenState extends State<Temrs_servicesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms of service',
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
                child: Container(
                  child: Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy.",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PR',height: 1.5 ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
