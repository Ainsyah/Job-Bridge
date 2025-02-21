import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUser extends StatefulWidget {
  final String chatId;
  final String compId;

  const ChatUser({super.key, required this.chatId, required this.compId});

  @override
  _ChatUserState createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _messageController = TextEditingController();

  // Get messages from the 'messages' collection
  Stream<List<DocumentSnapshot>> getMessages() {
    return _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp') // Order by timestamp (oldest first)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<Map<String, String?>> getUserInfo(String userId) async {
    try {
      var userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        String name = userSnapshot.data()?['name'] ?? 'User';
        return {'name': name};
      } else {
        return {'name': 'User'};
      }
    } catch (e) {
      return {'name': 'User'};
    }
  }

  // Get the other user's info (job seeker or company) based on chat participants
  Future<Map<String, String?>> _getUserInfo() async {
    var chatSnapshot = await _firestore.collection('chats').doc(widget.chatId).get();
    var chatData = chatSnapshot.data();
    if (chatData != null && chatData.containsKey('users')) {
      var users = List<String>.from(chatData['users']);
      var userId = users.firstWhere((id) => id != widget.compId, orElse: () => '');
      return await getUserInfo(userId);
    }
    return {'name': 'User', 'profilepic': null};
  }

  // Send a message to Firebase
  Future<void> sendMessage(String messageText) async {
    try {
      String senderId = widget.compId; // Assume the company is sending the message
      String receiverId = 'jobSeekerId'; // Replace with actual job seeker ID
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Message sent successfully!");
      _messageController.clear(); // Clear the message input field after sending
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height to reduce gap
        child: FutureBuilder<Map<String, String?>>(
          future: _getUserInfo(), // Get user info
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppBar(title: const Text('Loading...'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return AppBar(title: const Text('No User Info'));
            }

            var userData = snapshot.data!;
            String userName = userData['name'] ?? 'User';

            return AppBar(
              backgroundColor: Color.fromARGB(255, 5, 52, 92),
              automaticallyImplyLeading: true, // Show the back button
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Go back when back button is pressed
                },
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!;

                if (messages.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    var messageContent =
                        messageData['messageText'] ?? 'No message content';
                    var senderId = messageData['senderId'] ?? 'Unknown sender';

                    bool isSeller = senderId == widget.compId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment: isSeller
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color:
                                isSeller ? Color.fromARGB(255, 5, 52, 92) : Colors.blue[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            messageContent,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSeller ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value); // Send message when the user submits
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text); // Send the message on button click
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
