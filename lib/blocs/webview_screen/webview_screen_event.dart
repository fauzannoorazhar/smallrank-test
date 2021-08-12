part of 'webview_screen_bloc.dart';

abstract class WebviewScreenEvent extends Equatable {
  const WebviewScreenEvent();
}

class InitialWebviewScreenEvent extends WebviewScreenEvent {
  InitialWebviewScreenEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateWebviewScreenEvent extends WebviewScreenEvent {
  final bool isLoading;

  UpdateWebviewScreenEvent({this.isLoading});

  @override
  // TODO: implement props
  List<Object> get props => [isLoading];
}
