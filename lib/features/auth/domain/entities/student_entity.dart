import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final int id;
  final String? firstName;
  final String? fatherName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? city;
  final String? school;
  final int? typeId;
  final String? photo;

  const StudentEntity({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.school,
    this.typeId,
    this.photo,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        fatherName,
        lastName,
        email,
        phone,
        city,
        school,
        typeId,
        photo,
      ];
}