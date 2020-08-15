import 'dart:convert';

import 'package:brain_wars/features/snake_game/bloc/game_event.dart';
import 'package:brain_wars/features/snake_game/bloc/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const wsUrl = "ws://d2a9a94bf418.ngrok.io/ws";

class SnakeGameBloc extends Bloc<SnakeGameEvent, SnakeGameState> {
  WebSocketChannel channel;
  SnakeGameBloc() : super(null);
  List<dynamic> enemyPos;
  List<dynamic> playerPos;
  List<dynamic> food;

  @override
  Stream<SnakeGameState> mapEventToState(SnakeGameEvent event) async* {
    print(event);
    if (event is ConnectToSocketEvent) {
      yield WaitingUserState();
      _connect();
    }

    if (event is NotEnoughUsersEvent) {
      yield WaitingUserState();
    }

    if (event is GameStartEvent) {
      yield GameStartedState(enemyPos, playerPos, food);
    }

    if (event is UpdatePositions) {
      yield GameStartedState(enemyPos, playerPos, food);
    }
    if (event is CurrentPositionEvent) {
      channel.sink.add(
        jsonEncode(
          {"turn": event.turn},
        ),
      );

      yield GameStartedState(enemyPos, playerPos, food);
    }

    if (event is UpdateDirectionEvent) {
      print(event.direction);
      _changeDirection(event.direction);
    }

    if (event is GameOverEvent) {
      print("GamaOver");
      yield GameOverState(enemyPos, playerPos);
    }
  }

  _changeDirection(String direction) {
    channel.sink.add(
      jsonEncode(
        {'direction': direction},
      ),
    );
  }

  _listen() {
    channel.stream.listen((event) {
      var response = jsonDecode(event);
      print(response);
      if (response['status'] == 0) {
        this.add(NotEnoughUsersEvent());
      } else {
        if (response['name'] == "player") {
          playerPos = response['position'];
        } else {
          enemyPos = response['position'];
        }
        food = response['food'];
        if (response['status'] == 1) {
          this.add(UpdatePositions());
        } else {
          this.add(GameOverEvent());
        }
      }

      print(response);
    });
  }

  _connect() {
    channel = IOWebSocketChannel.connect(wsUrl);
    _listen();
    channel.sink.add(
      jsonEncode(
        {"direction": 'down'},
      ),
    );
  }
}
