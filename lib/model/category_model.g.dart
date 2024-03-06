// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      name: json['name'] as String,
      subName: json['sub_name'] as String,
      value: json['value'] as String?,
      emoji: json['emoji'] as String,
      tags: json['tags'] == null
          ? []
          : Tag.createTagListByJsonList(json['tags'] as List),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'sub_name': instance.subName,
      'emoji': instance.emoji,
      'value': instance.value,
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
    };
