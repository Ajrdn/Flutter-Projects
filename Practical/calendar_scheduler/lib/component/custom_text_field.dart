import 'package:calendar_scheduler/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.initialValue,
    required this.isTime,
    required this.onSaved,
    Key? key,
  }) : super(key: key);

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      validator: (String? value) {
        if(value == null || value.isEmpty) {
          return '값을 입력해주세요.';
        }

        if(isTime) {
          int time = int.parse(value);
          if(time < 0) {
            return '0 이상의 숫자를 입력해주세요.';
          } else if(time > 24) {
            return '24 이하의 숫자를 입력해주세요.';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
      cursorColor: Colors.grey,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime ? [
        FilteringTextInputFormatter.digitsOnly,
      ] : [],
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      initialValue: initialValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        isTime ? renderTextField() : Expanded(child: renderTextField()),
      ],
    );
  }
}
