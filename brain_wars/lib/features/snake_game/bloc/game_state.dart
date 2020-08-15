import 'package:equatable/equatable.dart';

abstract class SnakeGameState extends Equatable {}

class WaitingUserState extends SnakeGameState {
  @override
  List<Object> get props => [];
}

class GameStartedState extends SnakeGameState {
  final List<dynamic> enemyPos;
  final List<dynamic> playerPos;
  final List<dynamic> food;

  GameStartedState(this.enemyPos, this.playerPos, this.food);

  @override
  List<Object> get props => [enemyPos, playerPos, food];
}

class GameOverState extends SnakeGameState {
  final List<dynamic> enemyPos;
  final List<dynamic> playerPos;

  GameOverState(this.enemyPos, this.playerPos);

  @override
  List<Object> get props => [enemyPos, playerPos];
}
