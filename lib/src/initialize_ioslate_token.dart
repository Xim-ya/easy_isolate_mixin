import 'package:flutter/services.dart';

// Create and initialize Isolate token
abstract class EasyIsolateHelper {
  final RootIsolateToken rootIsolateToken;

  EasyIsolateHelper() : rootIsolateToken = RootIsolateToken.instance! {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  }
}
