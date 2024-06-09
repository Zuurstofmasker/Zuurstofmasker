import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:zuurstofmasker/config.dart';

String? validation<T>(T? value, bool isRequired,
    String? Function(T?)? validator, String? labelText,
    [bool isDouble = false, bool isInt = false]) {
  // Checking if the field is required
  if (isRequired) {
    if ((value ?? '') == '') {
      return "${labelText ?? "Dit veld"} is verplicht";
    }
  }

  // Checking if the value is a proper double
  if (isDouble && double.tryParse((value ?? '').toString()) == null) {
    return "${labelText ?? "Dit veld"} heeft een incorrect komma getal format";
  }

  // Checking if the value is a proper integer
  if (isInt && int.tryParse((value ?? '').toString()) == null) {
    return "${labelText ?? "Dit veld"} heeft een incorrect getal format";
  }

// Checking if a custom validator is present then use it
  if (validator != null) {
    return validator(value);
  }
  return null;
}

InputDecoration getInputDecoration(
    String? hintText, String? labelText, IconData? icon) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    isDense: true,
    hintText: hintText,
    labelText: labelText,
    hintStyle: const TextStyle(
      color: greyTextColor,
      fontWeight: FontWeight.w300,
    ),
    enabledBorder: inputBorder,
    focusedBorder: inputBorder,
    border: inputBorder,
    prefixIcon: icon != null
        ? Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              icon,
              color: primaryColor,
              size: 20,
            ),
          )
        : null,
  );
}

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final String? labelText;
  final TextAlign? textAlign;
  final bool isPassword;
  final bool isInt;
  final bool isDouble;
  final bool isMultiLine;
  final bool isRequired;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final Function()? onTap;

  final TextEditingController? controller;
  const InputField(
      {super.key,
      this.icon,
      this.hintText,
      this.labelText,
      this.controller,
      this.textAlign,
      this.isPassword = false,
      this.isInt = false,
      this.isRequired = true,
      this.validator,
      this.isDouble = false,
      this.onChange,
      this.isMultiLine = false,
      this.isReadOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReadOnly,
      controller: controller,
      onTap: onTap,
      maxLines: isMultiLine ? 5 : 1,
      validator: (value) =>
          validation(value, isRequired, validator, labelText, isDouble, isInt),
      obscureText: isPassword,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType:
          (isInt || isDouble) ? TextInputType.phone : TextInputType.text,
      inputFormatters: [
        if (isInt) FilteringTextInputFormatter.digitsOnly,
        if (isDouble)
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?([0-9]{1,2})?$'))
      ],
      onChanged: onChange,
      decoration: getInputDecoration(hintText, labelText, icon),
    );
  }
}

// ignore: must_be_immutable
class InputDropDown<T> extends StatefulWidget {
  InputDropDown({
    super.key,
    required this.items,
    this.value,
    this.onChange,
    this.hintText,
    this.labelText,
    this.isRequired = true,
    this.validator,
  });

  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChange;
  final String? hintText;
  final String? labelText;
  T? value;
  final bool isRequired;
  final String? Function(T?)? validator;

  @override
  // ignore: no_logic_in_create_state
  State<InputDropDown> createState() => _InputDropDownState<T>(
        onChange: onChange,
        validator: validator,
      );
}

class _InputDropDownState<S> extends State<InputDropDown> {
  final void Function(S? value)? onChange;
  final String? Function(S?)? validator;

  _InputDropDownState({
    this.onChange,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<S>(
      items: widget.items as List<DropdownMenuItem<S>>,
      value: widget.value,
      isExpanded: true,
      validator: (value) =>
          validation<S>(value, widget.isRequired, validator, widget.labelText),
      decoration: getInputDecoration(widget.hintText, widget.labelText, null),
      onChanged: (newValue) {
        if (onChange != null) onChange!(newValue);

        setState(() {
          widget.value = newValue;
        });
      },
    );
  }
}

// ignore: must_be_immutable
class InputColor extends StatefulWidget {
  Color value;
  final String labelText;
  final void Function(Color value)? onChange;

  InputColor({
    super.key,
    required this.value,
    required this.labelText,
    this.onChange,
  });

  @override
  State<InputColor> createState() => _InputColorState();
}

class _InputColorState extends State<InputColor> {
  Future<Color> pickColor(Color color) async {
    Color newColor = color;
    bool hasCancelled = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kies een kleur'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: widget.value,
              onColorChanged: (color) {
                newColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                hasCancelled = true;
                navigatorKey.currentState?.pop(widget.value);
              },
              child: const Text(
                'Annuleer',
                style: TextStyle(color: secondaryColor),
              ),
            ),
            TextButton(
              onPressed: () => navigatorKey.currentState?.pop(widget.value),
              child: const Text('Kies'),
            ),
          ],
        );
      },
    );

    return hasCancelled ? color : newColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(color: secondaryColor, fontSize: 16),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => pickColor(widget.value).then((value) {
            if (widget.value != value && widget.onChange != null) {
              widget.onChange!(value);
            }

            setState(() {
              widget.value = value;
            });
          }),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: widget.value,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: greyTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
