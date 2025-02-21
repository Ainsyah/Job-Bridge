import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_bridge/components/my_textfield.dart';
import 'package:job_bridge/pages/job_postings.dart';

class SkillsPage extends StatefulWidget {
  final String userId;

  SkillsPage({required this.userId});

  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _uniNameController = TextEditingController();
  final TextEditingController _gradController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final List<String> _skills = [];
  bool _isLoading = false;

  final List<String> _educationType = ['Not Specified', 'Diploma', 'Degree'];
  final List<String> _studyField = [
    'Not Specified',
    'Accounting and Finance',
    'Agriculture, Forestry, Fisheries, and Veterinary',
    'Architecture and Building',
    'Arts and Design',
    'Audio-Visual Techniques and Media Production',
    'Business and Administration',
    'Communication and Broadcasting',
    'Computing',
    'Computer Science & Information Technology',
    'Education',
    'Engineering and Engineering Trades',
    'Environmental Protection and Conservation',
    'Hospitality and Tourism',
    'Humanities',
    'Languages',
    'Law',
    'Manufacturing and Processing',
    'Marketing and Sales',
    'Mathematics and Statistics',
    'Medical and Health Sciences',
    'Natural Sciences',
    'Personal Services',
    'Security Services',
    'Social and Behavioral Sciences',
    'Transport Services',
    'Urban and Regional Planning',
    'Veterinary Medicine',
    'Sports Science',
  ];

  String? _selectedEduType;
  String? _selectedStudyField;

  @override
  void initState() {
   super.initState();
   _selectedEduType = _educationType.first; 
   _selectedStudyField = _studyField.first;
  }

  @override
  void dispose() {
    _programmeController.dispose();
    _uniNameController.dispose();
    _gradController.dispose();
    _gpaController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
      await usersRef.doc(widget.userId).set({
        'academicQualification': {
          'educationType': _selectedEduType,
          'programme': _programmeController.text.trim(),
          'fieldOfStudy': _selectedStudyField,
          'university': _uniNameController.text.trim(),
          'grad': _gradController.text.trim(),
          'gpa': _gpaController.text.trim(),
        },
        'skills': _skills,
      }, SetOptions(merge: true));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => JobPostingsPage(userId: widget.userId),
        ),
      );
    } catch (e) {
      debugPrint('Error saving details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addSkill() {
    String skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 52, 92),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 5, 52, 92),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fill in your details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  buildEducationalBackgroundSection(),
                  const SizedBox(height: 20),

                  const Text('Skills', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _skillController,
                    decoration: InputDecoration(
                      hintText: 'Enter a skill',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: _addSkill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: _skills.map((skill) => Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeSkill(skill),
                      backgroundColor: Colors.lightBlueAccent,
                    )).toList(),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 5, 52, 92),
                      backgroundColor: const Color.fromARGB(255, 206, 220, 232),
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _saveDetails,
                    child: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildEducationalBackgroundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Educational Background', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 15),
        _buildDropdown("Education Type", _educationType, _selectedEduType, (value) {
          setState(() => _selectedEduType = value);
        }),
        const SizedBox(height: 15),
        _buildTextField("Study Programme", "example: Bachelors in Computer Science...", _programmeController),
        const SizedBox(height: 20),
        _buildDropdown("Field of Study", _studyField, _selectedStudyField, (value) {
          setState(() => _selectedStudyField = value);
        }),
        const SizedBox(height: 15),
        _buildTextField("University Name", "", _uniNameController),
        const SizedBox(height: 15),
        _buildTextField("Graduation Year", "", _gradController),
        const SizedBox(height: 15),
        _buildTextField("CGPA", "", _gpaController),
      ],
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.white, // Title text color
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5), // Spacing between title and dropdown
      Container(
        decoration: BoxDecoration(
          color: Colors.white, // Dropdown button background color
          borderRadius: BorderRadius.circular(8), // Rounded corners
          border: Border.all(color: Colors.grey), // Adds a border
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true, // Prevents overflow issues
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none, // Removes default border
            contentPadding: EdgeInsets.symmetric(vertical: 10), // Adjusts height
          ),
          dropdownColor: Colors.white, // Background of dropdown menu
          style: TextStyle(
            inherit: true,
            color: Color.fromARGB(255, 5, 52, 92), // Dropdown text color
            fontWeight: FontWeight.w500,
          ),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  inherit: true,
                  color: Color.fromARGB(255, 5, 52, 92), // Text inside dropdown
                ),
                overflow: TextOverflow.ellipsis, // Prevents text overflow
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}


Widget _buildTextField(String label, String hint, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white, // Label color
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        style: TextStyle(
          inherit: true,
          color: Color.fromARGB(255, 5, 52, 92), // Text color inside input
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true, // Enables background color
          fillColor: Colors.white, // Sets background to white
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600], // Slightly faded hint text
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide: BorderSide(color: Colors.grey), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color.fromARGB(255, 5, 52, 92), width: 2), // Highlighted border
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), // Adjust padding
        ),
      ),
    ],
  );
}

}