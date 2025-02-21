import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_bridge/pages/chat_company.dart';
import 'package:job_bridge/pages/chat_user.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  final String userId;
  final String documentId;
  final String jobId;
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String payPeriod;
  final String category;
  final String formattedWorkType;
  final int normalized_salary;
  final String jobPostingUrl;

  const JobDetailsPage({
    required this.userId,
    required this.documentId,
    required this.jobId,
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.payPeriod,
    required this.category,
    required this.formattedWorkType,
    required this.normalized_salary,
    required this.jobPostingUrl,
    super.key, required String chatId,
  });

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  int likeCount = 0;
  int dislikeCount = 0;
  bool _isMounted = true;
  bool isJobSaved = false;
  String chatId = '';

  @override
  void initState() {
    super.initState();
    _fetchLikeDislikeCounts();
    _checkIfJobIsSaved();
  }

  Future<void> _fetchChatId() async {
    try {
      // Fetch the chatId from Firestore or any other data source
      final chatDoc = await FirebaseFirestore.instance
          .collection('chats') // Assuming 'chats' collection holds chat documents
          .doc(widget.userId) // You can fetch the chatId based on the userId or jobId
          .get();

      if (chatDoc.exists) {
        setState(() {
          chatId = chatDoc['chatId']; // Assuming the document contains a field 'chatId'
        });
      }
    } catch (e) {
      // Handle error (for example, if chatId doesn't exist)
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchLikeDislikeCounts() async {
    try {
      final jobDoc = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.documentId)
          .get();

      if (jobDoc.exists) {
        final data = jobDoc.data()!;
        setState(() {
          likeCount = data['likes'] ?? 0;
          dislikeCount = data['dislikes'] ?? 0;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _incrementLikeCount() async {
    try {
      final jobRef = FirebaseFirestore.instance.collection('jobs').doc(widget.documentId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(jobRef);

        if (snapshot.exists) {
          final currentLikes = snapshot['likes'] ?? 0;
          transaction.update(jobRef, {'likes': currentLikes + 1});
        } else {
          transaction.set(jobRef, {'likes': 1, 'dislikes': 0});
        }
      });

      if (_isMounted) {
        setState(() {
          likeCount += 1;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _incrementDislikeCount() async {
    try {
      final jobRef = FirebaseFirestore.instance.collection('jobs').doc(widget.documentId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(jobRef);

        if (snapshot.exists) {
          final currentDislikes = snapshot['dislikes'] ?? 0;
          transaction.update(jobRef, {'dislikes': currentDislikes + 1});
        } else {
          transaction.set(jobRef, {'likes': 0, 'dislikes': 1});
        }
      });

      if (_isMounted) {
        setState(() {
          dislikeCount += 1;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _saveJob() async {
  try {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId);

    await userDocRef.update({
      'saved_jobs': FieldValue.arrayUnion([widget.documentId]),
    });

    if (_isMounted) {
      setState(() {
        isJobSaved = true;
      });
    }
  } catch (e) {
    // Handle error
  }
}


  Future<void> _checkIfJobIsSaved() async {
    try {
      final savedJobsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId);

    final userDoc = await savedJobsRef.get();
    if (userDoc.exists) {
      final savedJobs = userDoc.data()?['saved_jobs'] as List<dynamic> ?? [];
      if (savedJobs.contains(widget.documentId)) {
        // Job is saved
        if (_isMounted) {
          setState(() {
            isJobSaved = true;
          });
        }
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(
            color: Color.fromARGB(255, 5, 52, 92),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 52, 92),
                ),
              ),
              const SizedBox(height: 10),
              Text('Company: ${widget.companyName}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Location: ${widget.location}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Salary: \$${widget.normalized_salary}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Pay Period: ${widget.payPeriod}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Category: ${widget.category}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Work Type: ${widget.formattedWorkType}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up, color: Colors.green),
                    onPressed: _incrementLikeCount,
                  ),
                  Text('$likeCount', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.thumb_down, color: Colors.red),
                    onPressed: _incrementDislikeCount,
                  ),
                  Text('$dislikeCount', style: const TextStyle(fontSize: 18)),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the ChatUser page when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatCompany(
                            chatId: chatId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Apply Now', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 5, 52, 92),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: isJobSaved ? null : _saveJob,
                    child: Text(
                      isJobSaved ? 'Saved' : 'Save',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isJobSaved
                          ? Colors.grey
                          : const Color.fromARGB(255, 5, 52, 92),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Description:\n${widget.description}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
