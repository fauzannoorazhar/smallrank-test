import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'webview_screen_event.dart';
part 'webview_screen_state.dart';

class WebviewScreenBloc extends Bloc<WebviewScreenEvent, WebviewScreenState> {
  WebviewScreenBloc() : super(WebviewScreenState());

  @override
  Stream<WebviewScreenState> mapEventToState(WebviewScreenEvent event) async* {
    if (event is UpdateWebviewScreenEvent) {
      yield state.copyWith(
        isLoading: event.isLoading
      );
    }
  }
}
