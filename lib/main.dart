import 'package:flutter/material.dart';
import 'dart:math' as Math;

enum Years { ten, fifteen, thirty }

class Mortgage {
  final Years years;
  final double amount;
  final double interestRate;

  Mortgage({
    required this.years,
    required this.amount,
    required this.interestRate,
  });

  int get yearsInt {
    switch (years) {
      case Years.ten:
        return 10;
      case Years.fifteen:
        return 15;
      case Years.thirty:
        return 30;
    }
  }

  int get totalMonths {
    return yearsInt * 12;
  }

  String get formattedInterestRate {
    final interestRate = this.interestRate * 100;
    return '${interestRate.toStringAsFixed(2)}%';
  }

  double calculateMonthlyPayment() {
    final amount = this.amount;
    final interestRate = this.interestRate / 12;
    final totalMonths = this.totalMonths;

    final monthlyPayment =
        amount *
        interestRate *
        Math.pow(1 + interestRate, totalMonths) /
        (Math.pow(1 + interestRate, totalMonths) - 1);

    return monthlyPayment;
  }

  double calculateTotalPayment() {
    return (calculateMonthlyPayment() * totalMonths);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Mortgage? _selectedMortgage = Mortgage(
    years: Years.thirty,
    amount: 100000,
    interestRate: 0.035,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mortgage Calculator')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Years:', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  Text(
                    _selectedMortgage?.yearsInt.toString() ?? '0',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Amount:', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  Text(
                    "\$${_selectedMortgage?.amount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Interest Rate:', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  Text(
                    _selectedMortgage?.formattedInterestRate ?? '0.00%',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Monthly Payment:', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  Text(
                    "\$${_selectedMortgage?.calculateMonthlyPayment().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Total Payment:', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 30),
                  Text(
                    "\$${_selectedMortgage?.calculateTotalPayment().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text('Modify Mortgage'),
                onPressed: () async {
                  final selectedMortgage = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MortgageSelectionScreen(),
                    ),
                  );
                  if (selectedMortgage != null) {
                    setState(() {
                      _selectedMortgage = selectedMortgage;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MortgageSelectionScreen extends StatefulWidget {
  @override
  _MortgageSelectionScreenState createState() =>
      _MortgageSelectionScreenState();
}

class _MortgageSelectionScreenState extends State<MortgageSelectionScreen> {
  Years? _selectedYears = Years.ten;
  final TextEditingController _amountController = TextEditingController(
    text: '100000',
  );
  final TextEditingController _interestRateController = TextEditingController(
    text: '0.035',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Mortgage')),
      body: Column(
        children: [
          Text('Select Years'),
          RadioGroup<Years>(
            groupValue: _selectedYears,
            onChanged: (Years? value) {
              setState(() {
                _selectedYears = value;
              });
            },
            child: Column(
              children: [
                RadioListTile<Years>(title: Text('10'), value: Years.ten),
                RadioListTile<Years>(title: Text('15'), value: Years.fifteen),
                RadioListTile<Years>(title: Text('30'), value: Years.thirty),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: _interestRateController,
              decoration: InputDecoration(labelText: 'Interest Rate'),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(
                Mortgage(
                  years: _selectedYears!,
                  amount: double.parse(_amountController.text),
                  interestRate: double.parse(_interestRateController.text),
                ),
              );
            },
            child: Text('Calculate Mortgage'),
          ),
        ],
      ),
    );
  }
}
