import 'package:brain_wars/features/auth/bloc/auth_event.dart';
import 'package:brain_wars/features/auth/bloc/auth_state.dart';
import 'package:brain_wars/features/model/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(null);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedInEvent) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOutEvent) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      yield LoadingState();
      bool isSigned = await _userRepository.isSignedIn();
      if (isSigned) {
        final u = await _userRepository.getUserPref();
        yield AuthenticatedState(u);
      } else {
        yield UnauthenticatedState();
      }
    } catch (_) {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield AuthenticatedState(await _userRepository.getUserPref());
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield UnauthenticatedState();
    _userRepository.signOut();
  }
}
