import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'dao.dart';
import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemQuantity = TextEditingController();

  late AppDatabase database;
  bool dbReady = false;

  List<Item> items = [];
  Item? selectedItem;

  @override
  void initState() {
    super.initState();
    intializeDatabase();
  }

  Future<void> intializeDatabase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    setState(() {
      dbReady = true;
    });
    await _loadItems();
  }

  Future<void> _loadItems() async {
    if (!dbReady) return;
    final allItems = await database.itemDao.findAllItems();
    setState(() {
      items = allItems;
    });
  }

  Future<void> addItem() async {
    if (!dbReady) return;
    final name = _itemName.text.trim();
    final quantity = int.tryParse(_itemQuantity.text.trim()) ?? 0;

    if (name.isEmpty || quantity <= 0) return;

    final newItem = Item(null, name, quantity);
    await database.itemDao.insertItem(newItem);

    _itemName.clear();
    _itemQuantity.clear();

    await _loadItems();
  }

  Future<void> _deleteItem(Item item) async {
    if (!dbReady) return;
    await database.itemDao.deleteItem(item);
    await _loadItems();
  }

  Widget buildDetailView(Item item, bool isWideScreen) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${item.id}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Name: ${item.name}", style: TextStyle(fontSize: 22)),
            SizedBox(height: 8),
            Text("Quantity: ${item.quantity}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _deleteItem(item);
                    setState(() => selectedItem = null);
                    if (!isWideScreen) Navigator.pop(context);
                  },
                  child: Text("Delete"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() => selectedItem = null);
                    if (!isWideScreen) Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Input Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type the item here',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _itemQuantity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Type the quantity here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: addItem, child: Text('Submit Item')),
              ],
            ),
            SizedBox(height: 16),

            // List and Detail Layout
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWideScreen = constraints.maxWidth > 600;

                  Widget list = ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = item;
                          });

                          if (!isWideScreen) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => Scaffold(
                                      appBar: AppBar(
                                        title: Text("Item Details"),
                                      ),
                                      body: buildDetailView(item, false),
                                    ),
                              ),
                            );
                          }
                        },
                        child: ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(item.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                        ),
                      );
                    },
                  );

                  if (isWideScreen) {
                    return Row(
                      children: [
                        Flexible(flex: 2, child: list),
                        VerticalDivider(),
                        Flexible(
                          flex: 3,
                          child:
                              selectedItem != null
                                  ? buildDetailView(selectedItem!, true)
                                  : Center(
                                    child: Text(
                                      'Select an item to view details',
                                    ),
                                  ),
                        ),
                      ],
                    );
                  } else {
                    return list;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
