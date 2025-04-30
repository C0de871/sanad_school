import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  static const String idKey = 'id';
  static const String firstNameKey = 'first_name';
  static const String fatherNameKey = 'father_name';
  static const String lastNameKey = 'last_name';
  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String cityKey = 'city';
  static const String schoolKey = 'school';
  static const String typeIdKey = 'type_id';
  static const String photoKey = 'photo';

  const StudentModel({
    required super.id,
    required super.firstName,
    required super.fatherName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.city,
    required super.school,
    super.typeId,
    super.photo,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map[idKey],
      firstName: map[firstNameKey],
      fatherName: map[fatherNameKey],
      lastName: map[lastNameKey],
      email: map[emailKey],
      phone: map[phoneKey],
      city: map[cityKey],
      school: map[schoolKey],
      typeId: map[typeIdKey],
      photo: map[photoKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      firstNameKey: firstName,
      fatherNameKey: fatherName,
      lastNameKey: lastName,
      emailKey: email,
      phoneKey: phone,
      cityKey: city,
      schoolKey: school,
      typeIdKey: typeId,
      photoKey: photo,
    };
  }
}
