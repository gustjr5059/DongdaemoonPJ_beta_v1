

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
