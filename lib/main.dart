import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

// Container helps modify anything's visual
// clt+alt+L for auto format
//clt+space for suggestion
//Inout values are string by default
// Here we separated the parts as widgets that will need rebuilding every time

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //Brings up a bottom sheet to add tasks , the BuildContext ctx is for modalbottomSheet function
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.black12,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
//    Transaction(id: 't1', title: 'Chips', amount: 25, date: DateTime.now()),
//    Transaction(id: 't2', title: 'Sprite', amount: 35, date: DateTime.now())
  ];

  // Filters out beyond past week
  List<Transaction> get _recentTransaction {
    //where method exists in every list , allows to run a function on every item on the list ,
    // if the function returns true the item is kept
    return _userTransaction.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

//private properties are stored as pointers , so we can't replace them by assigning new values , but we can add to them and
// pass them on

  void _addNewTr(String title, int amount, DateTime chosenDate) {
    final newTr = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransaction.add(newTr);
    });
  }

  void _deleteTr(String id) {
    setState(() {
      // this method is inbuilt for all List items
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  //Brings up BottomSheet for user input
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return NewTransaction(_addNewTr);
        }
//      builder: (_) {
//        return GestureDetector(onTap: (){},child:NewTransaction(_addNewTr),behavior: HitTestBehavior.opaque,); //passing as a pointer
//      },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //right to left , in column
          children: <Widget>[
            Chart(_recentTransaction),
            //sending deleteTr function to transactionList via constructor, as a pointer to use it on OnPressed
            TransactionList(_userTransaction, _deleteTr),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
