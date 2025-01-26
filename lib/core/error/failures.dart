import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class EmailValidatorFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class PatientNameValidatorFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class HospitalNameValidatorFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class PersonalIdentityValidatorFailure extends Failure {
  @override
  List<Object?> get props => [];
}


class PasswordInvalidOrEmptyFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NameInvalidOrEmptyFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class BloodGroupInvalidOrEmptyFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CountryInvalidOrEmptyFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class PhoneNumberInvalidOrEmptyFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class WeekPassFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class ExistedAccountFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoUserFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class WrongPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class UnmatchedPassFailure extends Failure{
  @override
  List<Object?> get props => throw UnimplementedError();
}
class NotLoggedInFailure extends Failure{
  @override
  List<Object?> get props => throw UnimplementedError();
}
class EmailVerifiedFailure extends Failure{
  @override
  List<Object?> get props => throw UnimplementedError();
}
class TooManyRequestsFailure extends Failure{
  @override
  List<Object?> get props => throw UnimplementedError();
}