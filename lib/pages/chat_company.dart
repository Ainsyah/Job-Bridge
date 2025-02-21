import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatCompany extends StatefulWidget {
  final String chatId;
  final String userId;

  const ChatCompany({super.key, required this.chatId, required this.userId});

  @override
  _ChatCompanyState createState() => _ChatCompanyState();
}

class _ChatCompanyState extends State<ChatCompany> {
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

  // Get user info (name and profile picture) from the 'users' collection
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

  // Get user info for the company chat
  Future<Map<String, String?>> _getUserInfo() async {
    // Fetch chat document to get the user ID
    var chatSnapshot =
        await _firestore.collection('chats').doc(widget.chatId).get();
    var chatData = chatSnapshot.data();
    if (chatData != null && chatData.containsKey('users')) {
      // Extract userId from the 'users' array
      var users = List<String>.from(chatData['users']);
      var otherUserId =
          users.firstWhere((id) => id != widget.userId, orElse: () => '');
      return await getUserInfo(otherUserId); // Get info for the other user
    }
    return {'name': 'User', 'profilepic': null}; // Default if no userId found
  }

  // Send a message to Firebase
  Future<void> sendMessage(String content) async {
    if (content.trim().isNotEmpty) {
      var message = {
        'senderId': widget.userId,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add(message);
      _messageController.clear(); // Clear input after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height to reduce gap
        child: FutureBuilder<Map<String, String?>>(
          future: _getUserInfo(), // Get user info for chat
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
              backgroundColor: const Color.fromARGB(255, 5, 52, 92),
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
                        messageData['content'] ?? 'No message content';
                    var senderId = messageData['senderId'] ?? 'Unknown sender';

                    bool isUser = senderId == widget.userId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color.fromARGB(255, 5, 52, 92)
                                : Colors.blue[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            messageContent,
                            style: TextStyle(
                              fontSize: 16,
                              color: isUser ? Colors.white : Colors.black87,
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
                      sendMessage(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_messageController.text);
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
