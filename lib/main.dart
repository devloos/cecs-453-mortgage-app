import 'package:flutter/material.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Calculate Mortgage'),
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
            SizedBox(height: 20),
            Text('Selected Years: ${_selectedMortgage?.years}'),
            Text('Selected Amount: ${_selectedMortgage?.amount}'),
            Text('Selected Interest Rate: ${_selectedMortgage?.interestRate}'),
          ],
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
    text: '0.05',
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
