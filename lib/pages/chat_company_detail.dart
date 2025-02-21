import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/pages/chat_company.dart';
import 'package:job_bridge/pages/chat_user.dart';

class ChatCompanyDetail extends StatefulWidget {
  final String userId;

  const ChatCompanyDetail({super.key, required this.userId});

  @override
  _ChatCompanyDetailState createState() => _ChatCompanyDetailState();
}

class _ChatCompanyDetailState extends State<ChatCompanyDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to get all chats that involve the seller
  Stream<List<DocumentSnapshot>> getSellerChats() {
    return _firestore
        .collection('chats')
        .where('users',
            arrayContains: widget
                .userId) // Filter chats where the seller is a participant
        .snapshots()
        .map((snapshot) =>
            snapshot.docs); // Convert Firestore snapshot to list of documents
  }

  // Function to get the user's name and profile picture based on the userId
  Future<Map<String, String?>> getUserInfo(String compId) async {
    try {
      // Fetch the user document from the 'users' collection based on the userId
      var userSnapshot = await _firestore.collection('users').doc(compId).get();

      if (userSnapshot.exists) {
        String name = userSnapshot.data()?['comp_name'] ?? 'User'; // User's name
        return {
          'name': name,
        }; // Return the name and profilePic
      } else {
        return {
          'name': 'User',
        }; // Default values if user not found
      }
    } catch (e) {
      return {
        'name': 'User',
      }; // Return default if an error occurs
    }
  }

  // Function to get the latest message from the chat
  Future<String> getLastMessage(String chatId) async {
    var chatSnapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (chatSnapshot.docs.isEmpty) {
      return "No messages yet"; // Return placeholder text if no messages
    }

    var lastMessageData =
        chatSnapshot.docs.first.data() as Map<String, dynamic>;
    return lastMessageData['content'] ??
        "No message content"; // Return the message content
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(187, 183, 229, 100),
        title: const Text('Your Chats'),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: getSellerChats(), // Stream of seller chats
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          var chats = snapshot.data!;

          if (chats.isEmpty) {
            return const Center(
                child: Text("You have no chats.")); // No chats available
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index].data() as Map<String, dynamic>;
              var chatId = chats[index].id;

              // Get the userId by filtering out the seller's ID
              var userId = (chatData['users'] as List).firstWhere(
                (id) => id != widget.userId,
                orElse: () =>
                    '', // Default to empty string if no other user found
              );

              // Get the user's name and profile picture asynchronously
              return FutureBuilder<Map<String, String?>>(
                future: getUserInfo(userId), // Fetch user info based on userId
                builder: (context, userInfoSnapshot) {
                  if (userInfoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  var userName = userInfoSnapshot.data?['fullname'] ??
                      "User"; // Fetched user name

                  // Get the last message asynchronously
                  return FutureBuilder<String>(
                    future: getLastMessage(chatId), // Fetch the last message
                    builder: (context, lastMessageSnapshot) {
                      if (lastMessageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(title: Text("Loading..."));
                      }

                      var lastMessage = lastMessageSnapshot.data ??
                          "No message"; // Fetched last message or default

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.person),
                        ),// Display user's profile picture (or default icon if not available)
                        title: Text(userName), // Display user's name
                        subtitle: Text(lastMessage), // Display the last message (or placeholder text)
                        onTap: () {
                          // Navigate to the chat details page for the selected chat
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatCompany(
                                chatId: chatId, // Pass the chat ID to the detail page
                                userId: widget.userId, // Pass the seller ID
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}