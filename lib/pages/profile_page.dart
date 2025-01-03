import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'login_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'user_details_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 2; // Default to NotificationPage
  final CollectionReference collRef = FirebaseFirestore.instance.collection('users');

  late Future<DocumentSnapshot> userData;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page is loaded
    userData = collRef.doc(widget.userId).get();
  }

  void _onItemTapped(int index) {
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
          MaterialPageRoute(builder: (context) => JobPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(userId: widget.userId)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
  }

   Widget _buildSkillChip(String skill, String proficiency) {
    return Chip(
      label: Text('$skill ($proficiency)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 236, 233),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              try {
                // Sign out the user
                await FirebaseAuth.instance.signOut();
                
                // Navigate to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your actual login page
                );
              } catch (e) {
              // Handle error if sign-out fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error logging out: $e')),
               );
              }
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: collRef.doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there was an error fetching the data
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if data exists
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          String fullname = userData['fullname'] ?? 'No Name';
          String linkedin = userData['linkedin'] ?? 'No LinkedIn Profile';
          String email = userData['email'] ?? 'No Email';
          String phone = userData['phone'] ?? 'No Phone';
          String address = userData['address'] ?? 'No Address';

          String eduLevel = userData['eduLevel'] ?? 'No Degree';
          String fieldOfStudy = userData['field'] ?? 'No Field of study';
          String uniName = userData['uniName'] ?? 'No University Name';
          String uniLocation = userData['uniLoc'] ?? 'No University Location';
          String startEdu = userData['startEdu'] ?? 'No University Start Degree';
          String endEdu= userData['endEdu'] ?? 'No University End Degree';
          String gpa = userData['gpa'] ?? 'No GPA';

          String jobTitle = userData['jobtitle'] ?? 'No Job Title';
          String compName = userData['compName'] ?? 'No Company Name';
          String compLocation= userData['compLoc'] ?? 'No Company Location';
          String startWorking = userData['startWorking'] ?? 'No Start Working Date';
          String endWorking = userData['endWorking'] ?? 'No End Working Date';
          String jobDesc = userData['desc'] ?? 'No Job Description';
          //List<dynamic> techSkills = userData['techSkills'] ?? [];
          //List<dynamic> softSkills = userData['softSkills'] ?? [];
          String skillProficiency = userData['skillProf'] ?? 'No Skill Proficiency';
          final techSkills = Map<String, String>.from(userData['techSkills'] ?? {});
          final softSkills = Map<String, String>.from(userData['softSkills'] ?? {});

          String certName = userData['certName'] ?? 'No Certificate Name';
          String certOrgName = userData['certOrgName'] ?? 'No Certificate Organization Name';
          String dateCompletion = userData['date'] ?? 'No Date Completion';
          String projectName = userData['projName'] ?? 'No Project Name';
          String projectDesc = userData['projDesc'] ?? 'No Project Description';
          String techUsed = userData['techUsed'] ?? 'No Technology Used';
          String startProject = userData['startProj'] ?? 'No Start Project Date';
          String endProject = userData['endProj'] ?? 'No End Project Date';
          String awardName = userData['awardName'] ?? 'No Award Name';
          String awardOrgName = userData['awardOrgName'] ?? 'No Award Organization Name';
          String awardDesc = userData['awardDesc'] ?? 'No Award Description';
          String awardReceived = userData['awardDate'] ?? 'No Award Received';
          String languages = userData['language'] ?? 'No Languages';
          String langProficiency = userData['langProf'] ?? 'No Language Proficiency';

          String refName = userData['refName'] ?? 'No Reference Name';
          String refRelationship= userData['refRel'] ?? 'No Reference Relationship';
          String refOrgName = userData['refOrgName'] ?? 'No Reference Organization Name';
          String refEmail= userData['refEmail'] ?? 'No Reference Email';
          String refPhone = userData['refPhone'] ?? 'No Reference Phone';

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullname,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 77, 54, 45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        FontAwesomeIcons.userAlt, // Person icon
                        size: 56,
                        color: Color.fromARGB(255, 77, 54, 45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
            
                // USER INFORMATION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'User Information',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: widget.userId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    email,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    phone,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    address,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.web, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    linkedin,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
            
                // EDUCATION BACKGROUND
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Education Background',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: widget.userId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    eduLevel,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    fieldOfStudy,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    uniName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    uniLocation,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    startEdu,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    endEdu,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    gpa,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
            
                // WORK EXPERIENCE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Work Experience',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: widget.userId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.email_outlined, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      jobTitle,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      compName,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      compLocation,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      startWorking,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      endWorking,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Flexible(
                                      child: Text(
                                        jobDesc,
                                        style: const TextStyle(fontSize: 16, color: Colors.brown),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      'Technical Skills',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: techSkills.entries
                          .map((entry) => _buildSkillChip(entry.key, entry.value))
                          .toList(),
                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    const Text(
                                      'Soft Skills',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                       Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: softSkills.entries
                          .map((entry) => _buildSkillChip(entry.key, entry.value))
                          .toList(),
                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.brown),
                                    const SizedBox(width: 13),
                                    Text(
                                      skillProficiency,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
            
                // ACHIEVEMENTS & CERT
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Achievements & Certificates',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: widget.userId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    certName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    certOrgName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    dateCompletion,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    projectName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Flexible(
                                    child: Text(
                                      projectDesc,
                                      style: const TextStyle(fontSize: 16, color: Colors.brown),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Flexible(
                                    child: Text(
                                      techUsed,
                                        style: const TextStyle(fontSize: 16, color: Colors.brown),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    startProject,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    endProject,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    awardName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    awardOrgName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Flexible(
                                    child: Text(
                                      awardDesc,
                                        style: const TextStyle(fontSize: 16, color: Colors.brown),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    awardReceived,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    languages,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    langProficiency,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
            
                // REFERENCES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'References',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailPage(userId: widget.userId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    refName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    refRelationship,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    refOrgName,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.web, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    refEmail,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.web, color: Colors.brown),
                                  const SizedBox(width: 13),
                                  Text(
                                    refPhone,
                                    style: const TextStyle(fontSize: 16, color: Colors.brown),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobPage()),
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
}
