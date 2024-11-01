class Message {
  int? id;
  int customerId;
  String message;
  String timestamp;
  bool isSent; // True if sent by the owner, false if received

  Message({
    this.id,
    required this.customerId,
    required this.message,
    required this.timestamp,
    required this.isSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'message': message,
      'timestamp': timestamp,
      'isSent': isSent ? 1 : 0,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      customerId: map['customerId'],
      message: map['message'],
      timestamp: map['timestamp'],
      isSent: map['isSent'] == 1,
    );
  }
}