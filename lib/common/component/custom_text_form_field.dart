
import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? hintTextPadding; // hintText의 위치 조정을 위한 padding 추가
  final InputDecoration? decoration; // decoration 변수 추가
  final TextStyle? textStyle; // 텍스트 스타일 추가

  const CustomTextFormField({
    this.controller,
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.focusNode, // FocusNode 초기화
    this.hintStyle,
    this.hintTextPadding, // hintText 위치 조정을 위한 padding 초기화
    this.decoration, // decoration 초기화
    this.textStyle, // 텍스트 스타일 초기화
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF5C5C5C), // 입력 필드의 기본 테두리 색상
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      // FocusNode 할당
      cursorColor: Color(0xFFE17735),
      // 커서 색상을 PRIMARY_COLOR로 설정
      // 비밀번호 입력할때
      obscureText: obscureText,
      // 비밀번호 입력 필드 여부 설정.
      autofocus: autofocus,
      // 자동 포커스 여부 설정.
      keyboardType: keyboardType,
      // 키보드 타입 설정.
      onChanged: onChanged,
      // 값이 변경될 때 호출되는 콜백 함수.
      style: textStyle, // 텍스트 스타일을 여기서 설정
      decoration: (decoration ?? InputDecoration()).copyWith(
        contentPadding: hintTextPadding ?? EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: hintStyle ?? TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: decoration?.fillColor ?? INPUT_BG_COLOR,
        filled: decoration?.filled ?? true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: decoration?.focusedBorder ?? OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE17735), // 외부에서 제공된 색상으로 포커스된 테두리 색상 설정
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}