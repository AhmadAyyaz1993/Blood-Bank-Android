import 'package:equatable/equatable.dart';

class BloodRequestEntity extends Equatable {
  String patientName;
  String hospitalName;
  String country;
  String? city;
  String bloodGroup;
  String phoneNumber;
  String? countryCode;
  String? p_number;
  String? email;
  String cnic;
  String bloodRequiredOn;
  int? bloodQuantityRequired;


  BloodRequestEntity({ required this.patientName,
    required this.hospitalName,
    required this.country,
    this.city,
    required this.bloodGroup,
    required this.phoneNumber,
    this.countryCode,
    this.p_number,
    required this.cnic,
    required this.bloodRequiredOn,
    this.email,
    this.bloodQuantityRequired});


  // Converts the Firestore document data (Map) into a SignUpEntity instance
  factory BloodRequestEntity.fromMap(Map<String, dynamic> map) {
    return BloodRequestEntity(
      patientName: map['patientName'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      country: map['country'] ?? '',
      city: map['city'],
      bloodGroup: map['bloodGroup'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'],
      p_number: map['p_number'],
      cnic: map['cnic'] ?? '',
      bloodRequiredOn: map['bloodRequiredOn'] ?? '',
      email: map['email'],
      bloodQuantityRequired: map['bloodQuantityRequired'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'hospitalName': hospitalName,
      'country': country,
      'city': city,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'p_number': p_number,
      'cnic': cnic,
      'bloodRequiredOn': bloodRequiredOn,
      'email': email,
      'bloodQuantityRequired': bloodQuantityRequired,
    };
  }


  @override
  List<Object?> get props => [ patientName, hospitalName, country,city, bloodGroup, phoneNumber, p_number,countryCode,cnic,bloodRequiredOn,email,bloodQuantityRequired];
}