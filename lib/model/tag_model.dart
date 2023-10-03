import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final dynamic name;
  final dynamic value;

  const Tag({
    required this.name,
    required this.value,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, value];
}
