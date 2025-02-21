import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_bridge/pages/chat_company_detail.dart';
import 'package:job_bridge/pages/chat_detail.dart';
import 'package:job_bridge/pages/chat_user.dart';
import 'chat_company.dart';

class JobSeekerReport extends StatelessWidget {
  final String userId;
  final String compId;

  const JobSeekerReport({Key? key, required this.userId, required this.compId}) : super(key: key);

  // Stream to get all chats involving the job seeker
  Stream<List<DocumentSnapshot>> getJobSeekerChats() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users_ids', arrayContains: userId) // Filter chats where userId is present
        .snapshots()
        .map((snapshot) => snapshot.docs); // Convert Firestore snapshot to list of documents
  }

  // Function to get the user's name and profile picture based on userId
  Future<Map<String, String?>> getUserInfo(String userId) async {
    try {
      // Fetch the user document from the 'users' collection
      var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        String name = userSnapshot.data()?['fullname'] ?? 'User'; // User's full name
        return {'name': name}; // Return the name and profilePic
      } else {
        return {'name': 'User'}; // Return default values if user not found
      }
    } catch (e) {
      return {'name': 'User'}; // Return default if an error occurs
    }
  }

  // Function to fetch job seeker's educational background
  Future<Map<String, dynamic>?> getEducationDetails() async {
    try {
      var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data()?['academicQualification']; // Retrieve the academic details
      }
    } catch (e) {
      print('Error fetching education details: $e');
    }
    return null;
  }

  // Function to get the latest message from the chat
  Future<String> getLastMessage(String chatId) async {
    var chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (chatSnapshot.docs.isEmpty) {
      return "No messages yet"; // Return placeholder text if no messages
    }

    var lastMessageData = chatSnapshot.docs.first.data() as Map<String, dynamic>;
    return lastMessageData['content'] ?? "No message content"; // Return the message content
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        "Job Seeker Report",
        style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
      ),
      backgroundColor: Colors.white,
    ),
    body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching job seeker details"));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Job seeker not found"));
        }

        final jobSeeker = snapshot.data!.data() as Map<String, dynamic>;

        // Extract academicQualification map safely
        final academicQualification = jobSeeker['academicQualification'] as Map<String, dynamic>?;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Row
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          jobSeeker['fullname'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final chatSnapshot = await FirebaseFirestore.instance
                              .collection('chats')
                              .where('users_ids', arrayContains: userId)
                              .get();

                          String chatId;

                          if (chatSnapshot.docs.isEmpty) {
                            final newChatRef = await FirebaseFirestore.instance.collection('chats').add({
                              'users_ids': [compId, userId],
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                            chatId = newChatRef.id;
                          } else {
                            chatId = chatSnapshot.docs.first.id;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatUser(
                                compId: compId, chatId: chatId,
                              ),
                            ),
                          );
                          print("Contact ${jobSeeker['fullname']}");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: const Color.fromARGB(255, 5, 52, 92),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        child: const Text(
                          "Contact",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32, thickness: 1, color: Colors.grey),

                  // Email
                  Text(
                    "Email: ${jobSeeker['email'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Skills Section
                  Text(
                    "Skills:",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (jobSeeker['skills'] as List<dynamic>?)
                            ?.map((skill) => Text('- $skill', style: const TextStyle(fontSize: 16)))
                            .toList() ??
                        [const Text('N/A')],
                  ),

                  const SizedBox(height: 16),

                  // Education Section
                  Text(
                    "Educational Background:",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  academicQualification != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🎓 Education Type: ${academicQualification['educationType'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text("📚 Program: ${academicQualification['programme'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text("🔬 Field of Study: ${academicQualification['fieldOfStudy'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text("🏫 University: ${academicQualification['university'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text("🎓 Graduation Year: ${academicQualification['grad'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text("📊 GPA: ${academicQualification['gpa'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        )
                      : const Text("N/A"),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}


}
