import 'customer_chat_screen.dart';

import 'customer.dart'; // Import the Customer class
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add.dart';
import 'calendar_screen.dart';
import 'database_helper.dart';
import 'edit.dart';
import 'theme_manager.dart';
import 'package:provider/provider.dart';
// Import the calendar screen

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentTime = '';
  String _currentDate = '';
  List<Customer> customers = [];
  bool _showCustomers = true;
  void _toggleCustomersVisibility() {
    setState(() {
      _showCustomers = !_showCustomers;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDateTime());
    _refreshCustomers(); // This is the correct function to call here
  }

  void _refreshCustomers() async {
    List<Customer> customerList =
        await DatabaseHelper.instance.queryAllCustomers();
    setState(() {
      customers = customerList; // Assign the fetched data to the customers list
    });
  }

  void _showEditCustomerDialog(BuildContext context, Customer customer) async {
    final updatedCustomer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerScreen(customer: customer),
      ),
    );

    if (updatedCustomer != null) {
      setState(() {
        // Find the index of the customer in the list
        int index = customers.indexOf(customer);

        // Update the customer in the list
        customers[index] = updatedCustomer as Customer;
      });
    }
  }

  void _updateDateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
      _currentDate = DateFormat('EEE, d MMM').format(DateTime.now());
    });
  }

  void _onCalendarIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalendarScreen(),
      ),
    );
  }

  void _onAddCustomerPressed() async {
    final newCustomer = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
    );

    if (newCustomer != null) {
      setState(() {
        customers.add(newCustomer as Customer);
      });
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete  ${customer.name}?"),
          actions: [
            TextButton(
              onPressed: () async {
                // Delete from database
                await DatabaseHelper.instance.deleteCustomer(customer.id!);

                setState(() {
                  customers.remove(customer);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  customers.remove(customer);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // ... (rest of your code) ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button press (e.g., Navigator.pop(context))
          },
        ),
        title: const Text(
          "Vardhman Mobile Repair",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.circle_notifications_outlined,
                color: Colors.white),
            onPressed: () {
              // Handle notification button press
            },
          ),

          IconButton(
            icon:
                const Icon(Icons.calendar_month_outlined, color: Colors.white),
            onPressed: _onCalendarIconPressed,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Handle more options button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4_outlined),
            onPressed: () {
              Provider.of<ThemeManager>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF212121),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "0", // Replace with actual notification count
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Icon(
                          Icons.account_circle,
                          size: 40,
                          color: Colors.blue[700],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Icon(
                          Icons.square,
                          size: 40,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "1st",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _toggleCustomersVisibility,
                      child: const Text(
                        "Show all",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: () async {
                        // Wait for the result from AddCustomerScreen
                        final newCustomer = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddCustomerScreen()),
                        );

                        // Add the new customer to the list if it's not null
                        if (newCustomer != null) {
                          setState(() {
                            customers.add(newCustomer as Customer);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            // Added missing closing parenthesis
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerChatScreen(
                          customer: customers[index],
                        ),
                      ),
                    );
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person),
                  ),
                  title: Text(
                    customers[index].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    customers[index].phone,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String item) {
                      if (item == 'edit') {
                        // Handle edit action
                        _showEditCustomerDialog(context, customers[index]);
                      } else if (item == 'delete') {
                        // Handle delete action
                        _showDeleteConfirmationDialog(
                            context, customers[index]);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                );
              },
            ),
          ), // Moved the closing bracket to the correct position
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
