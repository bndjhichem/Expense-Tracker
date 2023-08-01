import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:google_fonts/google_fonts.dart';

final List<Expense> _registeredExpenses = [
  Expense(
    title: 'Course',
    amount: 19.99,
    date: DateTime.now(),
    category: Category.shopping,
  ),
  Expense(
    title: 'Invoice',
    amount: 15.69,
    date: DateTime.now(),
    category: Category.home,
  ),
  Expense(
    title: 'Ticket',
    amount: 04.99,
    date: DateTime.now(),
    category: Category.transport,
  ),
  Expense(
    title: 'TV subscribe',
    amount: 10.45,
    date: DateTime.now(),
    category: Category.payment,
  ),
  Expense(
    title: 'Lunch',
    amount: 30.13,
    date: DateTime.now(),
    category: Category.food,
  ),
];

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: NewExpense(onAddExpense: _addExpense),
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      total = total + expense.amount;
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      total = total - expense.amount;
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    
    super.initState();
    setState(() {
      _registeredExpenses.forEach((element) {
        total = total + element.amount;
      });
    });
  }

// solution 1
  double total = 0;

// solution 2
  double get totalnew {
    double a = 0;
    _registeredExpenses.forEach((element) {
      a = a + element.amount;
    });
    return a;
  }

// solution 3
  double totalnew2() {
    double a = 0;
    _registeredExpenses.forEach((element) {
      a = a + element.amount;
    });
    return a;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseTracker'),
        centerTitle: true,
        titleTextStyle: GoogleFonts.openSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add_circle_rounded),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Center(
                child: Text(
              'Total ' + total.toStringAsFixed(2) + " \$",
              style: GoogleFonts.roboto(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            )),
          ),
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
