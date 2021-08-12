part of 'webview_screen_bloc.dart';

class WebviewScreenState  {
  final bool isLoading;

  WebviewScreenState({this.isLoading=true});

  WebviewScreenState copyWith({
    bool isLoading
  }) {
    return WebviewScreenState(
      isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  String toString() {
    print('WebviewScreenState : {isLoading : ${isLoading}');
  }
}