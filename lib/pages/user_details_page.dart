import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  final String userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _uniNameController = TextEditingController();
  final TextEditingController _gradController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _skillInputController = TextEditingController();

  List<String> _skills = [];
  String _selectedEduType = "Degree";
  bool _isLoading = true;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await usersCollection.doc(widget.userId).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>? ?? {};
        final academicData =
            data['academicQualification'] as Map<String, dynamic>? ?? {};

        setState(() {
          _fullNameController.text = data['fullname'] ?? '';
          _emailController.text = data['email'] ?? '';
          _programmeController.text = academicData['programme'] ?? '';
          _fieldOfStudyController.text = academicData['fieldOfStudy'] ?? '';
          _uniNameController.text = academicData['university'] ?? '';
          _gradController.text = academicData['grad'] ?? '';
          _gpaController.text = academicData['gpa'] ?? '';
          _selectedEduType = academicData['educationType'] ?? 'Degree';
          _skills = List<String>.from(data['skills'] ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> saveUserData() async {
    try {
      await usersCollection.doc(widget.userId).set({
        'fullname': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'academicQualification': {
          'programme': _programmeController.text.trim(),
          'fieldOfStudy': _fieldOfStudyController.text.trim(),
          'university': _uniNameController.text.trim(),
          'grad': _gradController.text.trim(),
          'gpa': _gpaController.text.trim(),
          'educationType': _selectedEduType,
        },
        'skills': _skills,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User information updated successfully')),
      );
    } catch (e) {
      debugPrint("Error saving user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user information')),
      );
    }
  }

  void addSkill() {
    String skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  void removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _programmeController.dispose();
    _fieldOfStudyController.dispose();
    _uniNameController.dispose();
    _gradController.dispose();
    _gpaController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 5, 52, 92),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit User Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 5, 52, 92),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_fullNameController, 'Full Name'),
                  _buildTextField(_emailController, 'Email'),
                  const SizedBox(height: 20),
                  const Text(
                    "Academic Background",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(_programmeController, 'Programme Name'),
                  _buildTextField(_fieldOfStudyController, 'Field of Study'),
                  _buildTextField(_uniNameController, 'University'),
                  _buildTextField(_gradController, 'Graduation Year'),
                  _buildTextField(_gpaController, 'CGPA'),
                  const SizedBox(height: 20),
                  const Text(
                    "Skills",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(_skillInputController, 'Add Skill'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addSkill,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: _skills
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            onDeleted: () => removeSkill(skill),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
