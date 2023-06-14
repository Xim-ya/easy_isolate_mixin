import 'package:easy_isolate_mixin/easy_isolate_mixin.dart';

class Service with IsolateHelperMixin {
  Future<List<int>> performExpensiveWork() =>
      loadWithIsolate(() => _expensiveWork());
}

void main() {
  final service = Service();
  service.performExpensiveWork();
}

Future<List<int>> _expensiveWork() async {
  List<int> result = [];
  for (int i = 0; i < 1000000; i++) {
    result.add(i);
  }
  return result;
}
