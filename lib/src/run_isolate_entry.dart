import 'package:easy_isolate_mixin/src/isolate_entry.dart';
import 'package:flutter/services.dart';

// Function to be executed in Isolate
Future<void> isolateEntry(IsolateEntryPayload payload) async {
  final Function function = payload.function;

  try {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      payload.rootIsolateToken,
    );
  } on MissingPluginException catch (e) {
    return Future.error(e.toString());
  }

  // Execute the function passed as payload and send the result to the main Isolate through sendPort
  final result = await function();
  payload.sendPort.send(result);
}