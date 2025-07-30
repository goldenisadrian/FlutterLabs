import 'package:floor/floor.dart';

@Entity(tableName: 'items') // consistent lowercase plural table name
class Item {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final int quantity;

  Item(this.id, this.name, this.quantity);
}