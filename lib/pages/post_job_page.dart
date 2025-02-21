import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/js_listing_page.dart';
import 'package:job_bridge/pages/menu_page_comp.dart';
import 'package:job_bridge/pages/recruiters_page.dart';
import 'prof_comp_page.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostJobPage extends StatefulWidget {
  final String compId;
  const PostJobPage({Key? key, required this.compId}) : super(key: key);

  @override
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescController = TextEditingController();
  
  String? _selectedCategory = 'Not Specified';
  String? _selectedContract = 'Not Specified';
  String? _selectedRemuneration = 'Hide Remuneration';
  bool _isWillingToRelocate = false;
  String? _companyName;
  String? _companyLocation;
  String? _companyEmail;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();
  }

  // Fetch company data based on compId
  Future<void> _fetchCompanyData() async {
    try {
      DocumentSnapshot companySnapshot = await _firestore.collection('company').doc(widget.compId).get();
      if (companySnapshot.exists) {
        setState(() {
          _companyName = companySnapshot['comp_name'];
          _companyLocation = companySnapshot['location'];
          _companyEmail = companySnapshot['email'];
        });
      }
    } catch (e) {
      print('Error fetching company data: $e');
    }
  }

  // Save job data to Firestore
  Future<void> _saveJobToFirestore() async {
    final jobTitle = _jobTitleController.text.trim();
    final jobDescription = _jobDescController.text.trim();

    if (jobTitle.isEmpty || jobDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    final newJob = {
      'job_title': jobTitle,
      'job_description': jobDescription,
      'category': _selectedCategory,
      'contract_type': _selectedContract,
      'remuneration': _selectedRemuneration,
      'willing_to_relocate': _isWillingToRelocate,
      'company_name': _companyName,
      'company_location': _companyLocation,
      'company_email': _companyEmail,
      'posted_by': widget.compId,
      'created_at': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('job_postings').add(newJob);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job posted successfully')),
      );
      Navigator.pop(context); // Navigate back after saving
    } catch (e) {
      print('Error saving job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to post job')),
      );
    }
  }

  // Build TextField
  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }

  // Build Dropdown
  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Post a Job', style: TextStyle(color: Color.fromARGB(255, 5, 52, 92)),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a New Job Post',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
            ),
            const SizedBox(height: 16),
            _buildTextField('Job Title', 'Enter job title', _jobTitleController),
            const SizedBox(height: 16),
            _buildDropdown('Category', ['Not Specified', 'Engineering', 'Marketing', 'Finance'], _selectedCategory, (value) {
              setState(() {
                _selectedCategory = value;
              });
            }),
            const SizedBox(height: 16),
            _buildTextField('Job Description', 'Enter job description', _jobDescController, maxLines: 5),
            const SizedBox(height: 16),
            _buildDropdown('Contract Type', ['Not Specified', 'Full-Time', 'Part-Time'], _selectedContract, (value) {
              setState(() {
                _selectedContract = value;
              });
            }),
            const SizedBox(height: 16),
            ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 52, 92),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
              onPressed: _saveJobToFirestore,
              child: const Text('Post Job', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPageComp(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JsListingPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.thLarge, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecruitersPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfCompPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.userCircle, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}