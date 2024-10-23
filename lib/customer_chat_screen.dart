import 'package:flutter/material.dart';

import 'customer.dart';
import 'database_helper.dart';
import 'message.dart';

class CustomerChatScreen extends StatefulWidget {
  final Customer customer;

  const CustomerChatScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  List<Message> messages = [];
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    List<Message> fetchedMessages =
        await DatabaseHelper.instance.getMessagesForCustomer(
      widget.customer.id!,
    );
    setState(() {
      messages = fetchedMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].message),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    String messageText = _messageController.text;
                    if (messageText.isNotEmpty) {
                      Message newMessage = Message(
                        customerId: widget.customer.id!,
                        message: messageText,
                        timestamp: DateTime.now().toString(),
                        isSent: true,
                      );

                      await DatabaseHelper.instance
                          .insertMessage(newMessage);

                      setState(() {
                        messages.add(newMessage);
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}