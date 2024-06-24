import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? title;
  final int? maxLen;
  final String? suffexText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final bool withprefix;
  final bool withsuffex;
  final bool isPassword;
  final bool mulitLine;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final bool enabled;
  final bool isMetersHW;
  Function? onTap = () {};

  CustomTextField(
      {Key? key,
      required this.controller,
      this.hint,
      this.mulitLine = false,
      this.keyboardType,
      this.prefixIcon,
      this.withprefix = false,
      this.withsuffex = true,
      this.suffexText,
      this.validator,
      this.maxLen,
      this.isPassword = false,
      this.title,
      this.onChange,
      this.enabled = true,
      this.isMetersHW = false,
      this.onTap})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}
class _CustomTextFieldState extends State<CustomTextField> {
  bool _obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == null
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    color:  Colors.black,
                    fontSize: 14,
                    // fontWeight: FontWeight.w600
                  ),
                )),
        TextFormField(
          // onTapOutside: (event) {
          //   debugPrint('TextFeild');
          //   widget.isMetersHW == true ? widget.onTap!() : null;
          // },
          // onSaved: (newValue) {
          //   debugPrint('TextFeild');
          //   widget.isMetersHW == true ? widget.onTap!() : null;
          // },
          // onEditingComplete: () {
          //   debugPrint('TextFeild');
          //   widget.isMetersHW == true ? widget.onTap!() : null;
          // },
          // onFieldSubmitted: (value) {
          //   debugPrint('TextFeild');
          //   widget.isMetersHW == true ? widget.onTap!() : null;
          // },
          // onTap: () {
          //   debugPrint('TextFeild');
          //   widget.isMetersHW == true ? widget.onTap!() : null;
          // },
          textAlign:
              widget.isMetersHW == true ? TextAlign.center : TextAlign.start,
          enabled: widget.enabled,
          onChanged: widget.onChange,
          minLines: widget.mulitLine ? 5 : 1,
          maxLines: widget.mulitLine ? null : 1,
          style: const TextStyle(
              color:  Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600),
          validator: widget.validator,
          controller: widget.controller,
          maxLength: widget.maxLen,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obsecureText : false,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 15.0,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: widget.isMetersHW == true ? 3 : 20, vertical: 18),
            fillColor: Colors.transparent,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red)),
            hintText: widget.hint,
            hintStyle: TextStyle(
                fontSize: 16.0,
                color: const Color(0xffD6D6D6)),
            prefixIcon: widget.prefixIcon,
            suffix: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obsecureText = !_obsecureText;
                      });
                    },
                    child: null,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatefulWidget {
  final Function onPrss;
  final String buttonTitle;
  final double? width;
  final Color? bgColor;
  final Color? disableBgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final double? radius;
  final bool withSatr;
  final String? image;

  const CustomButton(
      {Key? key,
      required this.onPrss,
      required this.buttonTitle,
      this.width,
      this.bgColor,
      this.disableBgColor,
      this.textColor,
      this.fontSize,
      this.radius,
      this.borderColor,
      this.withSatr = false,
      this.image})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: widget.bgColor ?? Colors.blue,
          shape: RoundedRectangleBorder(
              // side: BorderSide(color: widget.borderColor ?? widget.bgColor),
              borderRadius: BorderRadius.circular(widget.radius ?? 25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.withSatr
                ? const Icon(Icons.star, color: Colors.white)
                : const SizedBox(),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.image != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(widget.image!),
                              //widget.Image!,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    widget.buttonTitle,
                    style: Theme.of(context).textTheme.displayLarge!.merge(
                          TextStyle(
                              height: 1.3,
                              fontSize: widget.fontSize ?? 14,
                              color: widget.textColor),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            widget.image != null
                ? const SizedBox(
                    width: 24,
                  )
                : const SizedBox(),
          ],
        ),
        onPressed: () {
          widget.onPrss();
        },
      ),
    );
  }
}

class SharedMethods {
  static void showInSnackBar(
      {required BuildContext context,
      String? message,
      Color? bgColor,
      TextStyle? textStyke}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      elevation: 6.0,
      content:  Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            
      ),
      backgroundColor: bgColor ?? Colors.redAccent,
    ));
  }}