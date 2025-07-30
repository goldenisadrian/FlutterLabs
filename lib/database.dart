import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'item.dart';
import 'dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Item])
abstract class AppDatabase extends FloorDatabase {
  ItemDao get itemDao;
}