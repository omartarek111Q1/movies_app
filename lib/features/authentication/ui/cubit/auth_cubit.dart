import 'dart:async';



import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../network/auth_errors/failuer_text.dart';
import '../../../../network/auth_errors/failure.dart';

import '../../domain/entity/sign_in_entity.dart';
import '../../domain/entity/sign_up_entity.dart';
import '../../domain/usecases/check_verification_use_case.dart';
import '../../domain/usecases/first_page_use_case.dart';
import '../../domain/usecases/google_auth_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../domain/usecases/verify_email_use_case.dart';

// حذفنا part 'auth_event.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final FirstPageUseCase firstPage;
  final CheckVerificationUseCase checkVerificationUseCase;
  final LogoutUseCase logOutUseCase;
  final GoogleAuthUseCase googleAuthUseCase;

  Completer<void> completer = Completer<void>();

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.firstPage,
    required this.verifyEmailUseCase,
    required this.checkVerificationUseCase,
    required this.logOutUseCase,
    required this.googleAuthUseCase,
  }) : super(AuthInitial());

  // الدوال التي استبدلت الأحداث (Events)

  void checkLoggingIn() {
    final theFirstPage = firstPage();
    if (theFirstPage.isLoggedIn) {
      emit(SignedInPageState());
    } else if (theFirstPage.isVerifyingEmail) {
      emit(VerifyEmailPageState());
    }
  }

  Future<void> signIn(SignInEntity signInEntity) async {
    emit(LoadingState());
    final failureOrUserCredential = await signInUseCase(signInEntity);
    _emitEither(failureOrUserCredential, SignedInState());
  }

  Future<void> signUp(SignUpEntity signUpEntity) async {
    emit(LoadingState());
    final failureOrUserCredential = await signUpUseCase(signUpEntity);
    _emitEither(failureOrUserCredential, SignedUpState());
  }

  Future<void> sendEmailVerification() async {
    final failureOrSentEmail = await verifyEmailUseCase();
    _emitEither(failureOrSentEmail, EmailIsSentState());
  }

  Future<void> checkEmailVerification() async {
    if (!completer.isCompleted) {
      completer.complete();
      completer = Completer<void>();
    }
    final failureOrEmailVerified = await checkVerificationUseCase(completer);
    _emitEither(failureOrEmailVerified, EmailIsVerifiedState());
  }

  Future<void> logOut() async {
    final failureOrLogOut = await logOutUseCase();
    _emitEither(failureOrLogOut, LoggedOutState());
  }

  Future<void> signInWithGoogle() async {
    emit(LoadingState());
    final result = await googleAuthUseCase();
    _emitEither(result, GoogleSignInState());
  }


  void _emitEither(Either either, AuthState state) {
    either.fold(
          (failure) => emit(ErrorAuthState(message: _mapFailureToMessage(failure))),
          (_) => emit(state),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case WeakPassFailure:
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
      case NotLoggedInFailure:
        return '';
      default:
        return "Unexpected Error, Please try again later.";
    }
  }
}