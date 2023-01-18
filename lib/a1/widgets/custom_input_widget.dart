import 'package:flutter/material.dart';
import 'package:inmans/a1/utils/constants.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class _Mask {
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String> validator;
  final String hint;

  _Mask({@required this.formatter, this.validator, @required this.hint});
}

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool hide;
  final Function(String) onChanged;
  final TextInputType inputType;
  final FormFieldValidator<String> validator;
  final Widget prefix;
  final int lines;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool onWhite;

  const CustomTextInput({
    Key key,
    this.hintText,
    this.controller,
    this.hide = false,
    this.onChanged,
    this.inputType = TextInputType.text,
    this.validator,
    this.prefix,
    this.lines = 1,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.onWhite = false,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        child: TextFormField(
          controller: controller,
          obscureText: hide,
          onChanged: onChanged,
          keyboardType: inputType,
          enableInteractiveSelection: true,
          autovalidateMode: AutovalidateMode.always,
          validator: validator,
          maxLines: lines,
          textInputAction: textInputAction,
          style: TextStyle(color: onWhite ? Colors.black : Colors.white),
          enabled: enabled,
          
          decoration: InputDecoration(
            prefixIcon: prefix,
            isDense: true,
            border: onWhite ? inputBorderOnWhite : inputBorder,
            errorBorder: onWhite ? inputBorderOnWhite : inputBorder,
            enabledBorder: onWhite ? inputBorderOnWhite : inputBorder,
            focusedBorder: onWhite ? inputBorderOnWhite : inputBorder,
            disabledBorder: onWhite ? inputBorderOnWhite : inputBorder,
            focusedErrorBorder: onWhite ? inputBorderOnWhite : inputBorder,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
            errorStyle: TextStyle(
                color: onWhite ? Colors.red : Colors.white, fontSize: 14),
                      ),
          autocorrect: false,
        ),
      ),
    );
  }
}

class IbanTextInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool hide;
  final bool isIban;

  const IbanTextInput(
      {Key key,
      this.hintText,
      this.controller,
      this.hide = false,
      this.isIban = false})
      : super(key: key);

  @override
  _IbanTextInputState createState() => _IbanTextInputState();
}

class _IbanTextInputState extends State<IbanTextInput> {
  double height = 56;

  @override
  void initState() {
    super.initState();
    maskFormatter = _Mask(
        formatter: MaskTextInputFormatter(
          mask: "AA## #### #### #### #### #### ##",
        ),
        hint: "TR00 0000 0000 0000 0000 0000 00",
        validator: (String value) {
          if (value.isEmpty) {
            return null;
          }

          if (RegExp(
                  r"[A-Z]{2}[0-9]{2}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{2}")
              .hasMatch(value.replaceAll(" ", ""))) {
            return null;
          } else {
            return getString("invalidIBAN");
          }
        });
  }

  var maskFormatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        height: height,
        child: TextFormField(
          // ignore: void_checks
          onChanged: (String newStr) {
            if (RegExp(
                    r"[A-Z]{2}[0-9]{2}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{4}(\s)?[0-9]{2}")
                .hasMatch(newStr)) {
              setState(() {
                height = 56;
              });
            } else {
              setState(() {
                height = 75;
              });
              return "geçersiz iban";
            }
          },
          validator: maskFormatter.validator,
          autovalidateMode: AutovalidateMode.always,
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          obscureText: widget.hide,
          inputFormatters: [maskFormatter.formatter],
          decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.white, fontSize: 14),
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder,
              disabledBorder: inputBorder,
              focusedErrorBorder: inputBorder,
              hintText: maskFormatter.hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 20)),
        ),
      ),
    );
  }
}

InputBorder inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(color: kMainColor),
);

InputBorder inputBorderOnWhite = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(color: kSecondColor),
);
