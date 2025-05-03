abstract class Body {
  Map<String, dynamic> toMap();
}

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
  final String deviceId;

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
    required this.deviceId,
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
      "device_id": deviceId,
    };
  }
}

class LoginBody {
  final String email;
  final String password;
  final String deviceId;

  LoginBody({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'device_id': deviceId,
    };
  }
}
