import 'package:flutter/material.dart';

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
                  onPressed: () {
                    setState(() {
                    words.add( _itemName.value.text + " Quantity: " + _itemQuantity.value.text);
                    _itemName.text = "";
                    _itemQuantity.text = "";
                    emptyList = false;
                  });
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
                          visible: emptyList,
                          child: Text('There are no items in the list.', style: new TextStyle(fontSize: 24),),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, rowNum) {
                  return GestureDetector(
                  onLongPress : () {
                    showDialog(context: context,
                        builder:
                        (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete entry?'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () { Navigator.pop(context, 'Cancel');},
                                child: const Text('Cancel')
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Delete');
                                  words.removeAt(rowNum);
                                  if (words.isEmpty) {
                                    emptyList = true;
                                  }
                                  setState(() {
                                  });
                                  },
                                child: const Text('Delete')

                            )
                          ],
                        ));
                  setState(() {
                  });
                  },
                  child: Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("${rowNum + 1}: "), Text(words[rowNum])]
                  )
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
