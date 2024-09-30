import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  String name;
  String email;
  String country;
  String? city;
  String bloodGroup;
  String phoneNumber;
  String? countryCode;
  String? p_number;
  String password;
  String repeatedPassword;


  SignUpEntity({ required this.name,
    required this.email,
    required this.country,
    this.city,
    required this.bloodGroup,
    required this.phoneNumber,
    this.countryCode,
    this.p_number,
    required this.password,
    required this.repeatedPassword});


  // Converts the Firestore document data (Map) into a SignUpEntity instance
  factory SignUpEntity.fromMap(Map<String, dynamic> map) {
    return SignUpEntity(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      country: map['country'] ?? '',
      city: map['city'],
      bloodGroup: map['bloodGroup'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'],
      p_number: map['p_number'],
      password: map['password'] ?? '',
      repeatedPassword: map['repeatedPassword'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'country': country,
      'city': city,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'p_number': p_number,
      'password': password,
      'repeatedPassword': repeatedPassword,
    };
  }


  @override
  List<Object?> get props => [ name, email, country,city, bloodGroup, phoneNumber, password, repeatedPassword];
}