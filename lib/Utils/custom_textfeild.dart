import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String title;
  final String? labelText;
  final TextEditingController? controller;
  final String? trailingImagePath;
  final TextInputType? keyboardType;
  final String image_path;
  final bool? isObscure;
  final bool? isMobileTextField;
  final Color? color;
  final int? maxLines;
  final double? height;
  final GestureTapCallback? tap;
  final GestureTapCallback? onpasswordTap;
  final bool? readOnly;
  final TextAlign? align;
  FormFieldValidator<String>? validator;

  final Function(String)? onChanged;
  final bool? enabled;
  final bool? touch = false;

  CommonTextFormField({
    Key? key,
    this.onChanged,
    required this.title,
    this.labelText,
    this.controller,
    this.trailingImagePath,
    this.keyboardType,
    required this.image_path,
    this.isObscure = false,
    this.isMobileTextField = false,
    this.color,
    this.maxLines,
    this.tap,
    this.readOnly,
    this.align,
    this.validator,
    this.enabled,
    this.height, this.onpasswordTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 45,right: 45.93),
      margin: const EdgeInsets.symmetric(horizontal: 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 18),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PR',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Container(
            // height: 45,
            // width: 300,

            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                  spreadRadius: -5,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: TextFormField(
              onChanged: onChanged,
              enabled: enabled,
              validator: validator,
              maxLines: maxLines,
              onTap: tap,
              obscureText: isObscure ?? false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                alignLabelWithHint: false,
                isDense: true,
                hintText: labelText ?? '',
                filled: true,
                border: InputBorder.none,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide:
                //   BorderSide(color: ColorUtils.blueColor, width: 1),
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'PR',
                  color: Colors.grey,
                ),
                suffixIcon: Container(
                  child: IconButton(
                    icon: Image.asset(
                      image_path,
                      color: Colors.black,
                      height: 20,
                      width: 20,
                    ),
                    onPressed: onpasswordTap,
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PR',
                color: Colors.black,
              ),
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}

class CommonTextFormField_text extends StatelessWidget {
  final String title;
  final String? labelText;
  final TextEditingController? controller;
  final String? trailingImagePath;
  final TextInputType? keyboardType;
  final String image_path;
  final bool? isObscure;
  final bool? isMobileTextField;
  final Color? color;
  final int? maxLines;
  final double? height;
  final GestureTapCallback? tap;
  final bool? readOnly;
  final TextAlign? align;
  FormFieldValidator<String>? validator;

  final Function(String)? onChanged;
  final bool? enabled;
  final bool? touch = false;

  CommonTextFormField_text({
    Key? key,
    this.onChanged,
    required this.title,
    this.labelText,
    this.controller,
    this.trailingImagePath,
    this.keyboardType,
    required this.image_path,
    this.isObscure = false,
    this.isMobileTextField = false,
    this.color,
    this.maxLines,
    this.tap,
    this.readOnly,
    this.align,
    this.validator,
    this.enabled,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 45,right: 45.93),
      margin: const EdgeInsets.symmetric(horizontal: 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 18),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PR',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Container(
            // width: 300,

            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                  spreadRadius: -5,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: TextFormField(
              maxLength: 150,
              onChanged: onChanged,
              enabled: enabled,
              validator: validator,
              maxLines: maxLines,
              onTap: tap,
              obscureText: isObscure ?? false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                alignLabelWithHint: false,
                isDense: true,
                labelText: labelText ?? '',
                counterStyle: TextStyle(
                  height: double.minPositive,
                ),
                counterText: "",
                filled: true,
                border: InputBorder.none,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide:
                //   BorderSide(color: ColorUtils.blueColor, width: 1),
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'PR',
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PR',
                color: Colors.black,
              ),
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.multiline,
            ),
          ),
        ],
      ),
    );
  }
}

class CommonTextFormField_search extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? trailingImagePath;
  final TextInputType? keyboardType;
  final bool? isObscure;
  final bool? isMobileTextField;
  final Color color;
  final Color Font_color;
  final Color icon_color;
  final IconData iconData;
  final int? maxLines;
  final GestureTapCallback? tap;
  final GestureTapCallback? onpress;
  final bool? readOnly;
  final TextAlign? align;
  FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final bool? enabled;
  final bool? touch = false;

  CommonTextFormField_search({
    Key? key,
    this.onChanged,
    this.labelText,
    this.controller,
    this.trailingImagePath,
    this.keyboardType,
    this.isObscure = false,
    this.isMobileTextField = false,
    required this.color,
    this.maxLines,
    this.tap,
    this.readOnly,
    this.align,
    this.validator,
    this.enabled,
    this.onpress, required this.icon_color, required this.iconData, required this.Font_color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 45,right: 45.93),
      margin: const EdgeInsets.symmetric(horizontal: 5),

      child: Container(
        height: 45,
        // width: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(0, 0),
              spreadRadius: -5,
            ),
          ],
          color:color,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: TextFormField(
          onChanged: onChanged,
          enabled: enabled,
          validator: validator,
          maxLines: maxLines,
          onTap: tap,
          obscureText: isObscure ?? false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 0),
            alignLabelWithHint: false,
            isDense: true,
            hintText: labelText ?? '',
            filled: true,
            border: InputBorder.none,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide:
            //   BorderSide(color: ColorUtils.blueColor, width: 1),
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            suffixIcon: IconButton(
              color: icon_color,
              icon: Icon(iconData),
              iconSize: 25,
              onPressed: onpress,
            ),
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'PR',
              color: Colors.grey,
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'PR',
            color: Font_color,
          ),
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.multiline,
        ),
      ),
    );
  }
}
