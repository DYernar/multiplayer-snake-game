import 'package:brain_wars/features/model/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class UninitializedState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}
