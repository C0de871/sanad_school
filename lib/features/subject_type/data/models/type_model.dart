import '../../domain/entities/type_entity.dart';

class TypeModel extends TypeEntity {
  const TypeModel({
    required super.id,
    required super.name,
  });

  factory TypeModel.fromMap(Map<String, dynamic> map) {
    return TypeModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
