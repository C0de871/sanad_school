import '../../domain/entities/type_entity.dart';

class TypeModel extends TypeEntity {
  static const String idKey = 'id';
  static const String nameKey = 'name';

  const TypeModel({
    required super.id,
    required super.name,
  });

  factory TypeModel.fromMap(Map<String, dynamic> map) {
    return TypeModel(
      id: map[idKey],
      name: map[nameKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
    };
  }
}
