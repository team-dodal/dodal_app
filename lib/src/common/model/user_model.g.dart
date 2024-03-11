// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['user_id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      content: json['content'] as String,
      profileUrl: json['profile_url'] as String?,
      registerAt: DateTime.parse(json['register_at'] as String),
      socialId: json['social_id'] as String,
      socialType: $enumDecode(_$SocialTypeEnumMap, json['social_type']),
      categoryList:
          Category.createCategoryListByJsonList(json['category_list'] as List),
      tagList: Tag.createTagListByJsonList(json['tag_list'] as List),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'content': instance.content,
      'social_id': instance.socialId,
      'social_type': _$SocialTypeEnumMap[instance.socialType]!,
      'profile_url': instance.profileUrl,
      'register_at': instance.registerAt.toIso8601String(),
      'category_list': instance.categoryList,
      'tag_list': instance.tagList,
    };

const _$SocialTypeEnumMap = {
  SocialType.KAKAO: 'KAKAO',
  SocialType.GOOGLE: 'GOOGLE',
  SocialType.APPLE: 'APPLE',
};
