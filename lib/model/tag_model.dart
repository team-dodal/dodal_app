import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable()
class Tag extends Equatable {
  final dynamic name;
  final dynamic value;

  const Tag({
    required this.name,
    required this.value,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  static createTagListByJsonList(List list) =>
      list.map((tag) => Tag.fromJson(tag)).toList();

  @override
  List<Object?> get props => [name, value];
}
