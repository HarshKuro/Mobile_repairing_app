import 'package:flutter/material.dart';

import 'customer.dart';
import 'database_helper.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed of
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  // You can add more validation for phone number format if needed
                  return null;
                },
              ),
              const SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String phone = _phoneController.text;
      Customer newCustomer = Customer(name: name, phone: phone);

      // Insert the new customer and get the generated id
      int newCustomerId = await DatabaseHelper.instance.insertCustomer(newCustomer);

      // Update the newCustomer object with the id
      newCustomer.id = newCustomerId;

      // Optionally, you can show a success message or clear the form fields here

      Navigator.pop(context, newCustomer); // Return the customer object
    }
  },
  child: const Text("Save"),
),
            ],
          ),
        ),
      ),
    );
  }
}