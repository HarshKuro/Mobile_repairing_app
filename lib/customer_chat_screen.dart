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
                return GestureDetector(
                  onLongPress: () {
                    _showPopupMenu(context, index);
                  },
                  child: ListTile(
                    title: Text(messages[index].message),
                  ),
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

  void _showPopupMenu(BuildContext context, int index) async {
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
        const PopupMenuItem<String>(
          value: 'info',
          child: Text('Information'),
        ),
      ],
    );

    if (result != null) {
      if (result == 'edit') {
        _editMessage(index);
      } else if (result == 'delete') {
      
      } else if (result == 'info') {
        _showMessageInfo(index);
      }
    }
  }

  void _editMessage(int index) async {
    final message = messages[index];
    final newMessageText = await _showEditMessageDialog(context, message);
    if (newMessageText != null && newMessageText.isNotEmpty) {
      setState(() {
        message.message = newMessageText;
        messages[index] = message;
      });
      await DatabaseHelper.instance.updateMessage(message);
    }
  }

  Future<String?> _showEditMessageDialog(
      BuildContext context, Message message) async {
    final TextEditingController textController =
        TextEditingController(text: message.message);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter new message'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () => Navigator.pop(context, textController.text),
            ),
          ],
        );
      },
    );
  }


  void _showMessageInfo(int index) {
    // TODO: Implement show message info logic
    print('Message info: ${messages[index].message}');
  }
}