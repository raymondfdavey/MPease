import 'dart:async';

import 'bloc.dart';
import 'classes.dart';

class UserBloc extends Bloc {
  final userController = StreamController<List<Lord>>.broadcast();

  @override
  void dispose() {
    userController.close();
  }
}

UserBloc userBloc = UserBloc();
