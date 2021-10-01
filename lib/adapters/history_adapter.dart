import 'package:hive/hive.dart';

// command to build the Model
// flutter packages pub run build_runner build --delete-conflicting-outputs
part 'history_adapter.g.dart';

@HiveType(typeId: 1)
class History {
  @HiveField(0)
  String calculation;
  @HiveField(1)
  String date;

  History({required this.calculation, required this.date});
}
