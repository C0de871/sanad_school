// lib/features/student/data/models/student_model.dart
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  static const String idKey = 'id';
  static const String firstNameKey = 'first_name';
  static const String lastNameKey = 'last_name';
  static const String fatherNameKey = 'father_name';
  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String cityKey = 'city';
  static const String schoolKey = 'school';
  static const String photoKey = 'photo';
  static const String typeKey = 'type';
  static const String deviceIdKey = 'device_id';

  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fatherName,
    required super.email,
    required super.phone,
    required super.city,
    required super.school,
    super.photo,
    required super.type,
    required super.deviceId,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map[idKey],
      firstName: map[firstNameKey],
      lastName: map[lastNameKey],
      fatherName: map[fatherNameKey],
      email: map[emailKey],
      phone: map[phoneKey],
      city: map[cityKey],
      school: map[schoolKey],
      photo: map[photoKey],
      type: map[typeKey],
      deviceId: map[deviceIdKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      firstNameKey: firstName,
      lastNameKey: lastName,
      fatherNameKey: fatherName,
      emailKey: email,
      phoneKey: phone,
      cityKey: city,
      schoolKey: school,
      photoKey: photo,
      typeKey: type,
      deviceIdKey: deviceId,
    };
  }
}
