// Copyright (C) 2020 covid19cuba
// Use of this source code is governed by a GNU GPL 3 license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:covid19cuba/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/preference_service.dart';

import 'package:covid19cuba/src/app.dart';
import 'package:covid19cuba/src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  await PrefService.init();

  await NotificationManager.initialize();

  await NotificationManager.cancelAll();

  var update = await checkUpdate();

  await setUpTasks();

  runApp(App(update));

  await setUpBackgroundTasks();
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }
}

Future<bool> checkUpdate() async {
  try {
    var state = await StateModel.check();
    if (state != null) {
      return state[0] && state[2];
    }
  } catch (e) {
    log(e.toString());
  }
  return false;
}
