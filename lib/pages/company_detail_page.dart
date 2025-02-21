import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/menu_page_comp.dart';
import 'package:job_bridge/pages/post_job_page.dart';
import 'package:job_bridge/pages/recruiters_page.dart';
import 'package:job_bridge/pages/saved_jobs.dart';
import 'job_postings.dart';
import 'js_listing_page.dart';
import 'menu_page.dart';
import 'prof_comp_page.dart';
import 'prof_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class CompanyDetailPage extends StatefulWidget {
  final String compId;
  const CompanyDetailPage({super.key, required this.compId});

  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  final TextEditingController _compNameController = TextEditingController();
  final TextEditingController _compDescController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController skillController = TextEditingController();

  int _selectedIndex = 2;  // Set default to NotificationPage
  bool _isEditingCountry = false;

  final CollectionReference collRef = FirebaseFirestore.instance.collection('company');
  late Future<DocumentSnapshot> userData;

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
    userData = collRef.doc(widget.compId).get();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userDoc = await collRef.doc(widget.compId).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _compNameController.text = data['comp_name'] ?? '';
        _compDescController.text = data['comp_desc'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    }
  }

  Future<void> saveUserData() async {
    await collRef.doc(widget.compId).update({
      'comp_name': _compNameController.text,
      'comp_desc': _compDescController.text,
      'email': _emailController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User information updated successfully')),
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
          MaterialPageRoute(builder: (context) => MenuPageComp(compId: widget.compId)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JsListingPage(compId: widget.compId)),
        );
        break;
      case 2:
        break;  // No action needed, already on the NotificationPage
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfCompPage(compId: widget.compId)),
        );
        break;
    }
  }

  void _saveContactInfo() {
    String phone = _phoneController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String compName = _compNameController.text;
    String compDesc = _compDescController.text;
    print('Saved: $compName $email, $address, $phone, $compDesc');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact Information Saved')),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.menu, color: Colors.black),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
      //     },
      //   ),
      // ],
    ),
    body: StreamBuilder<DocumentSnapshot>(
      stream: collRef.doc(widget.compId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Company data not found.'));
        }

        // Update text fields with real-time data
        final data = snapshot.data!.data() as Map<String, dynamic>;
        _compNameController.text = data['comp_name'] ?? '';
        _compDescController.text = data['comp_desc'] ?? '';
        _emailController.text = data['email'] ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Company Information",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _compNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _compDescController,
                decoration: const InputDecoration(labelText: 'Company Description'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUserData, // Save changes to Firestore
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 5, 52, 92),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 30),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPageComp(compId: widget.compId)));
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JsListingPage(compId: widget.compId)));
              },
              child: const Icon(FontAwesomeIcons.list, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostJobPage(compId: widget.compId)));
              },
              child: const Icon(FontAwesomeIcons.briefcase, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfCompPage(compId: widget.compId)));
              },
              child: const Icon(FontAwesomeIcons.user, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
