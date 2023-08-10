import 'package:flutter/widgets.dart';
import 'package:gpmobile/src/pages/mensagens/model/StatusMensaModel.dart';
import 'package:gpmobile/src/pages/quiz/listar_quiz/users_model.dart';

import 'ListQuizModel.dart';
import 'home_state.dart';

class HomeController {
  final stateNotifier = ValueNotifier<HomeState>(HomeState.empty);
  set state(HomeState state) => stateNotifier.value = state;
  HomeState get state => stateNotifier.value;

  UserModel user;
  List<StatusModel> quizzes;

  // final repository = HomeRepository();

  void getUser() async {
    state = HomeState.loading;
    // user = await repository.getUser();

    state = HomeState.success;
  }

  Future<void> getQuizzes() async {
    state = HomeState.loading;
    // quizzes = await repository.getQuizzes();
    state = HomeState.success;
  }
}
