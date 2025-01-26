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
  String cnic;


  BloodRequestEntity({ required this.patientName,
    required this.hospitalName,
    required this.country,
    this.city,
    required this.bloodGroup,
    required this.phoneNumber,
    this.countryCode,
    this.p_number,
    required this.cnic});


  // Converts the Firestore document data (Map) into a SignUpEntity instance
  factory BloodRequestEntity.fromMap(Map<String, dynamic> map) {
    return BloodRequestEntity(
      patientName: map['name'] ?? '',
      hospitalName: map['email'] ?? '',
      country: map['country'] ?? '',
      city: map['city'],
      bloodGroup: map['bloodGroup'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'],
      p_number: map['p_number'],
      cnic: map['cnic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': patientName,
      'email': hospitalName,
      'country': country,
      'city': city,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'p_number': p_number,
      'cnic': cnic,
    };
  }


  @override
  List<Object?> get props => [ patientName, hospitalName, country,city, bloodGroup, phoneNumber, p_number,countryCode,cnic];
}