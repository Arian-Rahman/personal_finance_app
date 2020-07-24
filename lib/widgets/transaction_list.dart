import 'package:flutter/material.dart';
import '../models/transaction.dart'; // going up needs ..
import 'package:demo_app/models/transaction.dart';
import 'package:intl/intl.dart';

//since user_transaction manages the transactions , this can be stateless
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  "No transaction added yet ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset("assets/images/waiting.png",
                      fit: BoxFit.cover),
                ),
              ],
            )
          : ListView.builder(
              // best scrolling function for optimisation
              //this requires 'item builder ' , takes a function that auto gives us context and an index for rendering
              itemBuilder: (ctx, index) {
                //return the widget that we want to build
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(transactions[index].title),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: (){
                        deleteTx(transactions[index].id);
                      },
                    ),
                  ),
                );
              },
              itemCount: transactions.length, //how many to render
              // children: transactions.map((transaction) {  }).toList(), // Transaction History
              //to implement our custom class, we need to transform it into a widget
              //map takes a function and transforms into widget
              // return a widget that represents our transaction
              //Map transforms transformation List into widgets
            ),
    );
  }
}

//
//Card(
//child: Row(
//children: <Widget>[
//Container(
//margin:
//EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//decoration: BoxDecoration(
//border: Border.all(
//color: Theme.of(context).primaryColor, width: 5),
//),
//padding: EdgeInsets.all(10),
//child: Text(
////transaction.amount.toString(),
//'\$${transactions[index].amount}',
////to add $ as a character, escape sequence
//style: TextStyle(
//fontWeight: FontWeight.bold,
//fontSize: 20,
//color: Theme.of(context).primaryColor,
//),
//),
//),
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//transactions[index].title,
//style: TextStyle(
//fontWeight: FontWeight.bold,
//fontSize: 17,
//),
//),
//Text(
//DateFormat("dd-mm-yyyy")
//.format(transactions[index].date),
////this method is from Intl package
//style: TextStyle(
//fontWeight: FontWeight.bold,
//fontSize: 17,
//color: Colors.black38,
//),
//),
//],
//),
//],
//),
//);
