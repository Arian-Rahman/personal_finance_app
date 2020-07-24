//this widget will be rebuilt every time there is a transaction ,
// will take the load off of the main file

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// *** in flutter , when we don't use () on a function call , it's passed as a pointer

class NewTransaction extends StatefulWidget {
  final Function
      addTr; // to access it from state class down below, use => widget.*name

  NewTransaction(
      this.addTr); //this needs to be accepted in widget not is state object (down below part)
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController == null) {
      return;
    }

    final title = _titleController.text;
    final amount = int.parse(_amountController.text);

    if (_selectedDate == null || title == null || amount == null) {
      return;
    }

    //accessing function passed onto the widget class, inside state class
    widget.addTr(  //this lies in main.dart
      title,
      amount,
      _selectedDate,
    );
    // context is always available in every class by default
    Navigator.of(context)
        .pop(); //pops off the top screen , which is the modal screen in this case
  }

  //this returns a future class , so we can use features from that data type
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: _titleController, // Method 2 for user input
              onSubmitted: (_) => _submitData(),
//                     Method 1 of getting input
//                      onChanged: (value){
//                      titleInput=value ;
//                      },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              controller: _amountController, //method 2 for user input
              keyboardType: TextInputType.number,
              onSubmitted: (_) =>
                  _submitData(), //OnSubmitted is a listener,  passing an anonymous function with dummy string '_'
//                    Method 1 of getting input
//                    onChanged: (value)=>amountInput=value, // Shorthand since only one value
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _selectedDate == null
                        ? 'No date picked'
                        : 'Selected Date: ${DateFormat.yMEd().format(_selectedDate)}',
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _presentDatePicker();
                    },
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text("Add Transaction"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed:
                  _submitData, // here , though it's a function , not using (), it's passed as a pointer
            )
          ],
        ),
      ),
    );
  }
}
