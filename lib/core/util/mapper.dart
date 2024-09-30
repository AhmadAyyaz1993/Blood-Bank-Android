import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/core/strings/failures.dart';


String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    case WeekPassFailure:
      return WEEK_PASS_FAILURE_MESSAGE;
    case ExistedAccountFailure:
      return EXISTED_ACCOUNT_FAILURE_MESSAGE;
    case NoUserFailure:
      return NO_USER_FAILURE_MESSAGE;
    case TooManyRequestsFailure:
      return TOO_MANY_REQUESTS_FAILURE_MESSAGE;
    case WrongPasswordFailure:
      return WRONG_PASSWORD_FAILURE_MESSAGE;
    case UnmatchedPassFailure:
      return UNMATCHED_PASSWORD_FAILURE_MESSAGE;
    case EmailValidatorFailure:
      return INVALID_EMAIL_FAILURE_MESSAGE;
    case PasswordInvalidOrEmptyFailure:
      return INVALID_PASSWORD_FAILURE_MESSAGE;
    case PhoneNumberInvalidOrEmptyFailure:
      return INVALID_PHONENUMBER_FAILURE_MESSAGE;
    case CountryInvalidOrEmptyFailure:
      return INVALID_COUNTRY_FAILURE_MESSAGE;
    case NotLoggedInFailure:
      return '';
    default:
      return "Unexpected Error , Please try again later .";
  }
}

