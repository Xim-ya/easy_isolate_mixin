import 'dart:isolate';
import 'package:flutter/services.dart';

// Class to contain the data needed to create an Isolate
class IsolateEntryPayload {
  const IsolateEntryPayload({
    required this.function,
    required this.sendPort,
    required this.rootIsolateToken,
  });

  final Future<dynamic> Function() function; // Function to be executed in Isolate
  final SendPort sendPort; // SendPort to send data to the main Isolate
  final RootIsolateToken rootIsolateToken; // Token for communication between Isolates
}