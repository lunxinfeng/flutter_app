import 'package:flutter/material.dart';
import 'dart:async';

typedef RLKBLoCWidgetBuilder<T> = Widget Function(BuildContext context, T data, BaseBLoC bloc);

class BaseBLoC<T> {
  T _data;
  StreamController<T> _controller;
  BaseBLoC(T data) {
    this._data = data;
    this._controller = StreamController<T>.broadcast();
  }
  Stream<T> get stream => _controller.stream;
  T get data => _data;
  changeData(T data) {
    _data = data;
    _controller.sink.add(_data);
  }

  dispose() {
    _controller.close();
  }
}

class BLoCProvider extends InheritedWidget {
  final BaseBLoC bloc;

  BLoCProvider({Key key, Widget child, BaseBLoC bloc})
      : this.bloc = bloc,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(BLoCProvider oldWidget) {
    return this.bloc.data != oldWidget.bloc.data;
  }

  static BaseBLoC of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BLoCProvider) as BLoCProvider).bloc;
}

class BLoCBuilder<T> extends StatelessWidget {
  const BLoCBuilder({Key key, @required this.builder});
  final RLKBLoCWidgetBuilder<T> builder;
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of(context);
    Widget child = StreamBuilder<T>(
        stream: bloc.stream,
        initialData: bloc.data,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          return this.builder(context, snapshot.data, bloc);
        });
    return child;
  }
}
