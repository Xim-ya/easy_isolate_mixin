import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:easy_isolate_helper/src/isolate_entry.dart';
import 'package:easy_isolate_helper/src/run_isolate_entry.dart';
import 'package:flutter/services.dart';

// Mixin class to handle Isolate
mixin IsolateHelperMixin {
  // Set the maximum number of Isolates that can run at the same time
  static const int _maxIsolates = 5;

  // Track the number of Isolates currently running
  int _currentIsolates = 0;

  // Queue to store pending tasks
  final Queue<Function> _taskQueue = Queue();

  // Create an Isolate and run a function, or if the number of Isolates currently running has reached its maximum, add the task to the queue
  Future<T> loadWithIsolate<T>(Future<T> Function() function) async {
    if (_currentIsolates < _maxIsolates) {
      _currentIsolates++;
      return _executeIsolate(function);
    } else {
      final completer = Completer<T>();
      _taskQueue.add(() async {
        final result = await _executeIsolate(function);
        completer.complete(result);
      });
      return completer.future;
    }
  }

  // Create a new Isolate and run the given function
  Future<T> _executeIsolate<T>(Future<T> Function() function) async {
    final ReceivePort receivePort = ReceivePort();
    final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

    final isolate = await Isolate.spawn(
      isolateEntry,
      IsolateEntryPayload(
        function: function,
        sendPort: receivePort.sendPort,
        rootIsolateToken: rootIsolateToken,
      ),
    );

    // Receive the result of the Isolate, terminate this Isolate, and execute the next task in the queue
    return receivePort.first.then(
      (dynamic data) {
        _currentIsolates--;
        _runNextTask();
        if (data is T) {
          isolate.kill(priority: Isolate.immediate);
          return data;
        } else {
          isolate.kill(priority: Isolate.immediate);
          throw data;
        }
      },
    );
  }

  // Execute the next task in the queue
  void _runNextTask() {
    if (_taskQueue.isNotEmpty) {
      final nextTask = _taskQueue.removeFirst();
      nextTask();
    }
  }
}
