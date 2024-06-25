// 'dongdaemoon_beta_v1' 프로젝트 내의 사용자 모델 파일을 임포트합니다.
// 이 파일은 사용자 관련 데이터의 구조를 정의하는 'UserModel' 클래스를 포함하고 있습니다.
// 'UserModel'은 사용자의 이름, 이메일, 프로필 사진 URL 등 사용자의 기본적인 정보를 필드로 가지며,
// 애플리케이션에서 필요로 하는 사용자 정보를 쉽게 저장하고 접근할 수 있도록 구조화된 형태를 제공합니다.
import 'package:dongdaemoon_beta_v1/user/model/user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['uid'] as String,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.id,
      'email': instance.email,
      'photoURL': instance.photoURL,
      'displayName': instance.displayName,
    };
