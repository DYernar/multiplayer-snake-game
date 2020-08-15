import 'package:equatable/equatable.dart';

abstract class SnakeGameEvent extends Equatable {}

class ConnectToSocketEvent extends SnakeGameEvent {
  @override
  List<Object> get props => [];
}

class CurrentPositionEvent extends SnakeGameEvent {
  final String turn;

  CurrentPositionEvent(this.turn);

  @override
  List<Object> get props => [turn];
}

class NotEnoughUsersEvent extends SnakeGameEvent {
  @override
  List<Object> get props => [];
}

class GameStartEvent extends SnakeGameEvent {
  final List<List<int>> enemypos;

  GameStartEvent(this.enemypos);
  @override
  List<Object> get props => [enemypos];
}

class UpdatePositions extends SnakeGameEvent {
  @override
  List<Object> get props => [];
}

class UpdateDirectionEvent extends SnakeGameEvent {
  final String direction;

  UpdateDirectionEvent(this.direction);
  @override
  List<Object> get props => [direction];
}

class GameOverEvent extends SnakeGameEvent {
  @override
  List<Object> get props => [];
}
