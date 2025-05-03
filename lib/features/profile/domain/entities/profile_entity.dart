// lib/features/student/domain/entities/student_entity.dart
import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String email;
  final String phone;
  final String city;
  final String school;
  final String? photo;
  final String type;
  final String? deviceId;

  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.email,
    required this.phone,
    required this.city,
    required this.school,
    this.photo,
    required this.type,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        fatherName,
        email,
        phone,
        city,
        school,
        photo,
        type,
        deviceId,
      ];
}
