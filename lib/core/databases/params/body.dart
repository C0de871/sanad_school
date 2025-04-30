class RegisterBody {
  final String firstName;
  final String fatherName;
  final String lastName;
  final String phone;
  final String city;
  final String email;
  final String password;
  final String school;
  final String typeId;

  RegisterBody({
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.email,
    required this.password,
    required this.school,
    required this.typeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
      'phone': phone,
      'city': city,
      'email': email,
      'password': password,
      'school': school,
      "type_id": typeId,
    };
  }
}

class LoginBody {
  final String email;
  final String password;

  LoginBody({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
