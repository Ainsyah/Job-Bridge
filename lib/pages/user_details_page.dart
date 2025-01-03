import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class UserDetailPage extends StatefulWidget {
  final String userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController skillController = TextEditingController();

  int _selectedIndex = 2;  // Set default to NotificationPage
  bool _isWillingToRelocate = false;
  bool _isEditingCountry = false;
  bool isTechSkill = true;

  final CollectionReference collRef = FirebaseFirestore.instance.collection('users');
  late Future<DocumentSnapshot> userData;
  List<String> techSkills = [];
  List<String> softSkills = [];

  final List<String> states = [
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

  @override
  void initState() {
    super.initState();
    userData = collRef.doc(widget.userId).get();
    fetchSkills();
    fetchUserData();
  }

    // Fetch user data from Firestore and update the text controllers
  Future<void> fetchUserData() async {
    final userDoc = await collRef.doc(widget.userId).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _fullNameController.text = data['fullname'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _addressController.text = data['address'] ?? '';
        _isWillingToRelocate = data['willingToRelocate'] ?? false;
        techSkills = List<String>.from(data['techSkills'] ?? []);
        softSkills = List<String>.from(data['softSkills'] ?? []);
      });
    }
  }

  Future<void> saveUserData() async {
    await collRef.doc(widget.userId).update({
      'fullname': _fullNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'willingToRelocate': _isWillingToRelocate,
      'techSkills': techSkills,
      'softSkills': softSkills,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User information updated successfully')),
    );
  }

    Future<void> fetchSkills() async {
    final userDoc = await collRef.doc(widget.userId).get();
    setState(() {
      techSkills = List<String>.from(userDoc['techSkills'] ?? []);
      softSkills = List<String>.from(userDoc['techSkills'] ?? []);
    });
  }

  void addSkill() {
    final skill = skillController.text.trim();
    if (skill.isNotEmpty) {
      setState(() {
        if (isTechSkill) {
          techSkills.add(skill);
        } else {
          softSkills.add(skill);
        }
      });
      skillController.clear();
    }
  }

  void removeSkill(List<String> skillList, String skill) {
    setState(() {
      skillList.remove(skill);
    });
  }

  Future<void> saveSkills() async {
    await collRef.doc(widget.userId).update({
      'techSkills': techSkills,
      'softSkills': softSkills,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Skills updated successfully')),
    );
  }
  
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
          MaterialPageRoute(builder: (context) => JobPage()),
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
    String phone = _phoneController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String fullname = _fullNameController.text;
    bool relocate = _isWillingToRelocate;

    // Add your saving logic here (e.g., saving to a database or Firebase)
    print('Saved: $fullname $email, $address, $phone, $relocate');
    
    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact Information Saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 236, 233),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit User Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 77, 54, 45)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _addressController.text.isEmpty ? null : _addressController.text,
              items: states.map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _addressController.text = value ?? '';
                });
              },
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: skillController,
              decoration: InputDecoration(
                labelText: 'Add Skill',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addSkill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Skill Type:', style: TextStyle(fontSize: 16),),
                const SizedBox(width: 8),
                DropdownButton<bool>(
                  value: isTechSkill,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Technical')),
                    DropdownMenuItem(value: false, child: Text('Soft')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isTechSkill = value ?? true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Technical Skills:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: techSkills
                  .map((skill) => Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => removeSkill(techSkills, skill),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text('Soft Skills:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: softSkills
                  .map((skill) => Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => removeSkill(softSkills, skill),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isWillingToRelocate,
                  onChanged: (value) {
                    setState(() {
                      _isWillingToRelocate = value!;
                    });
                  },
                ),
                const Text("Willing to Relocate"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContactInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 30),
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
