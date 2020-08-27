import 'package:brain_wars/features/snake_game/bloc/game_bloc.dart';
import 'package:brain_wars/features/snake_game/bloc/game_event.dart';
import 'package:brain_wars/features/snake_game/bloc/game_state.dart';
import 'package:brain_wars/features/snake_game/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  SnakeGameBloc _snakeGameBloc;

  @override
  void initState() {
    super.initState();
    _snakeGameBloc = SnakeGameBloc();
    _snakeGameBloc.add(ConnectToSocketEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _snakeGameBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<SnakeGameBloc, SnakeGameState>(
          builder: (context, state) {
            if (state is WaitingUserState) {
              return LoadingUsers();
            }

            if (state is GameStartedState) {
              return GameGrid(state.playerPos, state.enemyPos, state.food);
            }

            if (state is GameOverState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.lime[100],
                ),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              state.enemyPos.length > state.playerPos.length
                                  ? Text("You lost")
                                  : state.enemyPos.length <
                                          state.playerPos.length
                                      ? Text('You won!')
                                      : Text('Draw!'),
                              Text("Your score: ${state.playerPos.length}"),
                              Text("Enemy score: ${state.enemyPos.length}"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return Container(
              child: Center(
                  child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  BlocProvider.of<SnakeGameBloc>(context).add(
                    CurrentPositionEvent("up"),
                  );
                },
                child: Text(
                  "data",
                  style: TextStyle(color: Colors.white),
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}

class GameGrid extends StatefulWidget {
  final List<dynamic> enemyPos;
  final List<dynamic> playerPos;
  final List<dynamic> food;
  GameGrid(this.playerPos, this.enemyPos, this.food) : super();

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  final int squaresPerRow = 20;
  final int squarePerCol = 40;
  final fontStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  BlocProvider.of<SnakeGameBloc>(context).add(
                    UpdateDirectionEvent('down'),
                  );
                } else if (details.delta.dy < 0) {
                  BlocProvider.of<SnakeGameBloc>(context).add(
                    UpdateDirectionEvent('up'),
                  );
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  BlocProvider.of<SnakeGameBloc>(context).add(
                    UpdateDirectionEvent('right'),
                  );
                } else if (details.delta.dx < 0) {
                  BlocProvider.of<SnakeGameBloc>(context).add(
                    UpdateDirectionEvent('left'),
                  );
                }
              },
              child: AspectRatio(
                aspectRatio: squaresPerRow / (squarePerCol + 2),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: squaresPerRow,
                  ),
                  itemCount: squarePerCol * squaresPerRow,
                  itemBuilder: (context, index) {
                    var color;
                    var x = index % squaresPerRow;
                    var y = (index / squaresPerRow).floor();
                    bool isSnakeBody = false;

                    for (var pos in widget.playerPos) {
                      if (pos[0] == x && pos[1] == y) {
                        isSnakeBody = true;
                        break;
                      }
                    }
                    bool isEnemyBody = false;

                    for (var pos in widget.enemyPos) {
                      if (pos[0] == x && pos[1] == y) {
                        isEnemyBody = true;
                        break;
                      }
                    }
                    if (widget.playerPos.first[0] == x &&
                        widget.playerPos.first[1] == y) {
                      color = Colors.blue;
                    } else if (isSnakeBody) {
                      color = Colors.lightBlue;
                    } else if (widget.food[0] == x && widget.food[1] == y) {
                      color = Colors.green;
                    } else if (widget.enemyPos.first[0] == x &&
                        widget.enemyPos.first[1] == y) {
                      color = Colors.red;
                    } else if (isEnemyBody) {
                      color = Colors.red[300];
                    } else {
                      color = Colors.white;
                    }
                    return Container(
                      margin: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Score: ${widget.playerPos.length - 2}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      ],
    );
  }
}
