import 'dart:async';

class GlobalState {
  final Map<dynamic, dynamic> _data = {};

  StreamController _streamController = new StreamController.broadcast();
  Stream get onStateChanged => _streamController.stream;  

  GlobalState._();

  static GlobalState instance = new GlobalState._();

  set(key, value) {
    _data[key] = value;
    _streamController.add(_data);
  }

  get(key) {
    return _data[key];
  }

}