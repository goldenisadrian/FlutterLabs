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

List<String> words =  [] ;
var wordsArray = <String>[ ];
bool emptyList = true;
var selectedName;
var selectedId;
var selectedQuan;
/*
Widget detailspage() {
  if (selectedItem != null)
  return Column(
    children: [

    ],
  );
}
*/
Widget listpage(){
  return Column( children:[
    Expanded(child:
    ListView.builder( itemCount:words.length,
        itemBuilder: (context, rowNum) {  return
          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

              ]);
        }
    )
    )
  ]);
}



class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _itemName = TextEditingController(), _itemQuantity = TextEditingController();

  late AppDatabase database;
  bool dbReady = false;

  @override
  void initState() {

    super.initState();
    intializeDatabase();
  }

  Future<void> intializeDatabase() async {
    database = await $FloorAppDatabase
        .databaseBuilder('app_database.db')
        .build();
    setState(() {
      dbReady = true;
    });
    await _loadItems();
  }

  List<Item> items = [];

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


    final newitem = Item(null, name, quantity);
    await database.itemDao.insertItem(newitem);

    _itemName.clear();
    _itemQuantity.clear();

    await _loadItems();
  }

  Future<void> _deleteItem(Item item) async {
    if (!dbReady) return;
    await database.itemDao.deleteItem(item);
    await _loadItems();
  }
  Widget reactiveLayout()  {
    return Row(
        children: [
          listpage(), //Left side
          //detailspage() //Right side
        ]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded (
        child: TextField(
          controller: _itemName,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type the item here'))),
    Expanded (
          child: TextField(
            controller: _itemQuantity,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Type the quantity here'))),
          Expanded (
              child: ElevatedButton(
                  onPressed: () async {
                    await addItem();

                    },
              child: const Text('Submit Items'),
          )
          )
            ],
        ),// END OF ROW ///////////////////////////////////////

            Expanded(
  child: Stack(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: items.isEmpty,
                          child: Text('There are no items in the list.', style: new TextStyle(fontSize: 24),),
                        )
                      ],
                    ),
                  ),

                  ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                  onTap: () {
                    selectedId = item.id;
                    selectedName = item.name;
                    selectedQuan = item.quantity;
                    showDialog(context: context,
                        builder:
                        (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Id: $selectedId Name: $selectedName Quantity: $selectedQuan'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () { Navigator.pop(context, 'Cancel');},
                                child: const Text('Cancel')
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Delete');
                                  _deleteItem(item);
                                  },
                                child: const Text('Delete')

                            )
                          ],
                        ));
                  },
                    child: ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                    ),
                  );
                }
                ),
  ]
            ),
)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
