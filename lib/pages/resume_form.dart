import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class ResumeFormPage extends StatefulWidget {
  final String userId;
  const ResumeFormPage({super.key, required this.userId});

  @override
  _ResumeFormPageState createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _linkedinURLController = TextEditingController();

  final TextEditingController _summaryController = TextEditingController();

  final TextEditingController _eduLevelController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _uniNameController = TextEditingController();
  final TextEditingController _uniLocationController = TextEditingController();
  final TextEditingController _startEduController = TextEditingController();
  final TextEditingController _endEduController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _compNameController = TextEditingController();
  final TextEditingController _compLocationController = TextEditingController();
  final TextEditingController _startWorkingController = TextEditingController();
  final TextEditingController _endWorkingController = TextEditingController();
  final TextEditingController _jobDescController = TextEditingController();

  final TextEditingController _techSkillController = TextEditingController();
  final TextEditingController _softSkillController = TextEditingController();
  final TextEditingController _skillProficiencyController = TextEditingController();

  final TextEditingController _certNameController = TextEditingController();
  final TextEditingController _certOrgNameController = TextEditingController();
  final TextEditingController _dateCompletionController = TextEditingController();

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();
  final TextEditingController _techUsedController = TextEditingController();
  final TextEditingController _startProjectController = TextEditingController();
  final TextEditingController _endProjectController = TextEditingController();

  final TextEditingController _awardNameController = TextEditingController();
  final TextEditingController _awardOrgNameController = TextEditingController();
  final TextEditingController _awardReceivedController = TextEditingController();
  final TextEditingController _awardDescController = TextEditingController();

  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _langProficiencyController  = TextEditingController();

  final TextEditingController _refNameController = TextEditingController();
  final TextEditingController _refRelationshipController = TextEditingController();
  final TextEditingController _refOrgNameController = TextEditingController();
  final TextEditingController _refEmailController = TextEditingController();
  final TextEditingController _refPhoneController = TextEditingController();

  // List of cities and states in Malaysia
  final List<String> malaysiaCitiesStates = [
    'Kuala Lumpur, Kuala Lumpur', 'Shah Alam, Selangor', 'Petaling Jaya, Selangor', 'Batu Caves, Selangor',
    'Subang Jaya, Selangor', 'Klang, Selangor', 'Kajang, Selangor', 'Ampang, Selangor', 'Gombak, Selangor',
    'Cyberjaya, Selangor', 'Sepang, Selangor', 'George Town, Penang', 'Butterworth, Penang', 'Bayan Lepas, Penang',
    'Bukit Mertajam, Penang', 'Ipoh, Perak', 'Taiping, Perak', 'Teluk Intan, Perak', 'Lumut, Perak', 'Manjung, Perak',
    'Kampar, Perak', 'Kuala Kangsar, Perak', 'Johor Bahru, Johor', 'Batu Pahat, Johor', 'Kluang, Johor', 'Muar, Johor',
    'Kulai, Johor', 'Pontian, Johor', 'Segamat, Johor', 'Kota Tinggi, Johor', 'Mersing, Johor', 'Tangkak, Johor',
    'Kuantan, Pahang', 'Temerloh, Pahang', 'Bentong, Pahang', 'Pekan, Pahang', 'Raub, Pahang', 'Jerantut, Pahang',
    'Cameron Highlands, Pahang', 'Kota Bharu, Kelantan', 'Pasir Mas, Kelantan', 'Tanah Merah, Kelantan', 'Machang, Kelantan',
    'Kuala Krai, Kelantan', 'Tumpat, Kelantan', 'Gua Musang, Kelantan', 'Kuching, Sarawak', 'Miri, Sarawak', 'Sibu, Sarawak',
    'Bintulu, Sarawak','Sri Aman, Sarawak', 'Kapit, Sarawak', 'Kota Kinabalu, Sabah', 'Sandakan, Sabah', 'Tawau, Sabah',
    'Lahad Datu, Sabah', 'Keningau, Sabah', 'Ranau, Sabah', 'Semporna, Sabah', 'Melaka City, Melaka', 'Alor Gajah, Melaka',
    'Jasin, Melaka', 'Alor Setar, Kedah', 'Sungai Petani, Kedah', 'Kulim, Kedah', 'Langkawi, Kedah', 'Baling, Kedah',
    'Jitra, Kedah', 'Gurun, Kedah', 'Seremban, Negeri Sembilan', 'Port Dickson, Negeri Sembilan', 'Nilai, Negeri Sembilan',
    'Bahau, Negeri Sembilan', 'Kuala Terengganu, Terengganu', 'Dungun, Terengganu', 'Kemaman, Terengganu', 'Marang, Terengganu',
    'Besut, Terengganu', 'Setiu, Terengganu', 'Kangar, Perlis', 'Kuala Perlis, Perlis', 'Arau, Perlis', 'Putrajaya, Federal Territory',
    'Labuan, Federal Territory',
  ];

  final List<String> _educationType = ['Not Specified', 'Diploma', 'Degree', 'Master', 'PhD'];
  final List<String> _skillProf = <String>['Not Specified', 'Basic', 'Intermediate', 'Proficient'];
  final List<String> _langProf = <String>['Not Specified', 'Basic', 'Intermediate', 'Proficient'];
  final List<String> _studyField = <String>[];
  /*final List<Widget> _pages = [
    MenuPage(userId: userId),
    JobPage(),
    NotificationPage(userId: userId),
    ProfilePage(userId: widget.userId),
  ];*/

  int _selectedIndex = 2;  // Set default to NotificationPage
  String? _selectedEduType = 'Not Specified';  
  String? _selectedSkillProf = 'Not Specified';
  String? _selectedLangProf = 'Not Specified';
  String? _selectedStudyField = "Not Specified";
  final bool _isWillingToRelocate = false;
  final bool _isEditingCountry = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobPage(userId: widget.userId)),
        );
        break;
      case 2:
        // No action needed, already on the NotificationPage
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
  }

  void _saveContactInfo() {
    // Personal Details
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String linkedinURL = _linkedinURLController.text;

    // Career Summmary
    String summary = _summaryController.text;

    // Educational Background
    String eduLevel= _eduLevelController.text;
    String fieldOfStudy = _fieldOfStudyController.text;
    String uniName = _uniNameController.text;
    String uniLocation = _uniLocationController.text;
    String startEdu = _startEduController.text;
    String endEdu = _endEduController.text;
    String gpa = _gpaController.text;
    
    // Work Experience
    String jobTitle = _jobTitleController.text;
    String compName = _compNameController.text;
    String compLocation = _compLocationController.text;
    String startWorking = _startWorkingController.text;
    String endWorking = _endWorkingController.text;
    String jobDesc = _jobDescController.text;

    // Skills
    String techSkill = _techSkillController.text;
    String softSkill = _softSkillController.text;
    String skillProficiency = _skillProficiencyController.text;
    
    // Certification & courses
    String certName = _certNameController.text;
    String certOrgName = _certOrgNameController.text;
    String dateCompletion = _dateCompletionController.text;

    // Projects
    String projectName = _projectNameController.text;
    String projectDesc = _projectDescController.text;
    String techUsed = _techUsedController.text;
    String startProject = _startProjectController.text;
    String endProject = _endProjectController.text;

    // Award & achievements
    String awardName = _awardNameController.text;
    String awardOrgName = _awardOrgNameController.text;
    String awardReceived = _awardReceivedController.text;
    String awardDesc = _awardDescController.text;

    // Languages
    String languages = _languagesController.text;
    String langProficiency = _langProficiencyController.text;

    // References Details
    String refName = _refNameController.text;
    String refRelationship = _refRelationshipController.text;
    String refOrgName = _refOrgNameController.text;
    String refEmail = _refEmailController.text;
    String refPhone = _refPhoneController.text;

    // Add your saving logic here (e.g., saving to a database or Firebase)
    print(
      'Saved: $fullName, $email, $phone, $address, $linkedinURL, $summary, $eduLevel,'
      '$fieldOfStudy, $uniName, $uniLocation, $startEdu,$endEdu, $gpa, $jobTitle,'
      '$compName, $compLocation, $startWorking, $endWorking, $jobDesc, $techSkill,'
      '$softSkill, $skillProficiency, $certName, $certOrgName, $dateCompletion,'
      '$projectName, $projectDesc, $techUsed, $startProject, $endProject, $awardName,'
      '$awardOrgName, $awardReceived, $awardDesc, $languages, $langProficiency, $refName,'
      '$refRelationship, $refOrgName, $refEmail, $refPhone'
      );
    
    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All informations saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 236, 233),
        //title: const Text('Contact Information'),
        elevation: 0,
        //centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black), // Menu button
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),

    body: Scrollbar(
      thumbVisibility: true,
      thickness: 6.0,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resume",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 54, 45),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please fill in your details.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 54, 45),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 214, 211),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    buildPersonalDetailsSection(),
                    const SizedBox(height: 20),
                    buildCareerObjectiveSection(),
                    const SizedBox(height: 20),
                    buildEducationalBackgroundSection(),
                    const SizedBox(height: 20),
                    buildWorkExperienceSection(),
                    const SizedBox(height: 20),
                    buildSkillSection(),
                    const SizedBox(height: 20),
                    buildCertSection(),
                    const SizedBox(height: 20),
                    buildProjectSection(),
                    const SizedBox(height: 20),
                    buildAwardSection(),
                    const SizedBox(height: 20),
                    buildLanguageSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.thLarge, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.userCircle, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select $label',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }

  Widget buildPersonalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Full Name", "Enter your full name as per IC", _fullNameController),
        const SizedBox(height: 15),
        _buildTextField("Email", "", _emailController),
        const SizedBox(height: 15),
        _buildTextField("Phone", "example: 01X-XXXXXXXX", _phoneController),
        const SizedBox(height: 15),
        _buildTextField("Address", "", _addressController),
        const SizedBox(height: 15),
        _buildTextField("LinkedIn Profile", "", _linkedinURLController , maxLines: 3),
      ],
    );
  }

  Widget buildEducationalBackgroundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Educational Background',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildDropdown("Education Type", _educationType, _selectedEduType, (value) {
          setState(() {
            _selectedEduType = value;
            });
        }),
        const SizedBox(height: 15),
        _buildTextField("Degree Programme", "example: Bachelors in Computer Science...", _eduLevelController , maxLines: 3),  
        const SizedBox(height: 15),
        _buildDropdown("Field of Study", _studyField, _selectedStudyField, (value) {
          setState(() {
            _selectedStudyField = value;
            });
        }),
        const SizedBox(height: 15),
        _buildTextField("Instituition Name", "", _uniNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDateField("Start Date", _startEduController),
        const SizedBox(height: 15),
        _buildDateField("End Date", _endEduController),
        const SizedBox(height: 15),
        _buildTextField("CGPA", "", _gpaController , maxLines: 3),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildCareerObjectiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Career Objective', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height:15),
        _buildTextField("Summary", "A short paragraph summarizing professional goals and strengths", _summaryController , maxLines: 3),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildWorkExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Job Title", "", _jobTitleController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Company Name", "", _compNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Location", "pilih", _compLocationController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDateField("Start Date", _startWorkingController),
        const SizedBox(height: 15),
        _buildDateField("End Date", _endWorkingController),
        const SizedBox(height: 15),
        _buildTextField("Job Description", "", _jobDescController, maxLines: 3),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildSkillSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Technical Skills", "", _techSkillController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Soft Skills", "", _softSkillController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDropdown("Proficiency Level", _skillProf, _selectedSkillProf, (value) {
          setState(() {
            _selectedSkillProf = value;
            });
        }),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildCertSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Certification & Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Certification Name", "", _certNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Organization Name", "", _certOrgNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDateField("Date of Completion", _dateCompletionController),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildProjectSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Project Name", "", _projectNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Project Description", "", _projectDescController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Technologies Used", "", _techUsedController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDateField("Start Date", _startProjectController),
        const SizedBox(height: 15),
        _buildDateField("End Date", _endProjectController),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildAwardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Award & Achievement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Title of Award/Achievement", "", _awardNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Organization Name", "", _awardOrgNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDateField("Date Received", _awardReceivedController),
        const SizedBox(height: 15),
        _buildTextField("Award Description", "", _awardDescController , maxLines: 3),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Languages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Languages Known", "", _languagesController , maxLines: 3),
        const SizedBox(height: 15),
        _buildDropdown("Proficiency Level", _langProf, _selectedLangProf, (value) {
          setState(() {
            _selectedLangProf = value;
            });
        }),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildReferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('References', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildTextField("Full Name", "", _refNameController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Relationship", "Example: Manager, Professor", _refRelationshipController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Organization/Company Name", "", _refOrgNameController , maxLines: 3),
        const SizedBox(height: 15),
        const Text('Contact Information'),
        const SizedBox(height: 10),
        _buildTextField("Email", "", _refEmailController , maxLines: 3),
        const SizedBox(height: 15),
        _buildTextField("Phone", "", _refPhoneController , maxLines: 3),
      ],
    );
  }
}


