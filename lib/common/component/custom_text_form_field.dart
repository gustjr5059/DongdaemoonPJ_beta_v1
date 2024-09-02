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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR, // 입력 필드의 기본 테두리 색상
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      // FocusNode 할당
      cursorColor: PRIMARY_COLOR,
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
      decoration: InputDecoration(
        contentPadding: hintTextPadding ?? EdgeInsets.all(20), // hintText의 위치를 조정하기 위한 padding 적용
        // 내부 패딩 설정.
        hintText: hintText,
        // 힌트 텍스트 설정.
        errorText: errorText,
        // 에러 텍스트 설정.
        hintStyle: hintStyle ?? TextStyle(
          color: BODY_TEXT_COLOR, // 기본 힌트 텍스트 스타일
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        // 입력 필드의 배경 색상
        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,
        // 배경 색상 사용 여부 설정.
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        // 기본 테두리 스타일 설정.
        enabledBorder: baseBorder,
        // 활성 상태일 때의 테두리 스타일 설정.
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: BUTTON_COLOR, // 포커스 상태일 때의 테두리 색상을 BUTTON_COLOR로 설정
          ),
        ),
      ),
    );
  }
}
