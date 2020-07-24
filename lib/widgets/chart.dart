import 'package:demo_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      int totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        //substring 0,1 => only shows the first alphabet of the day
        'amount': totalSum
      }; //this is a map
    }).reversed.toList();
  }

  //this function gives us the spending of entire week
  double get totalSpending {
    //fold transforms a list to another data type via the function we need to pass on
    return groupedTransactionValues.fold(
      0,
      (sum, item) {
        return sum + item['amount'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      //map executes a function on every value inside from where it's been called .
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTransactionValues.map(
              (data) {
                return Flexible(
                  //takes all available scpace
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'],
                    data['amount'],
                    // to avoid 0/0 cases
                    totalSpending == 0
                        ? 0
                        : (data['amount'] as int) / totalSpending,
                  ),
                );
              },
            ).toList()),
      ),
    );
  }
}
