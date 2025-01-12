import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class PostJobPage extends StatefulWidget {
  final String userId;
  const PostJobPage({super.key, required this.userId});

  @override
  _PostJobPageState createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  // Controllers
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobDescController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // State variables
  final int _selectedIndex = 2; // Default to NotificationPage
  String? _selectedCountry = 'Malaysia';
  String? _selectedContract = 'Not Specified';
  String? _selectedRemuneration = 'Hide Remuneration';
  String? _selectedCategory = 'Not Specified';
  String? _selectedLocation;
  String? _selectedCity;
  bool _isWillingToRelocate = false;

  // Dropdown data
  final List<String> _contractTypes = ['Not Specified', 'Full-Time', 'Part-Time'];
  final List<String> _remunerations = ['Hide Remuneration', 'Monthly', 'Weekly'];

  final List<String> _category = [
    'Not Specified', 'Administrative & Office Support', 'Business Development & Strategy', 
    'Cloud Computing', 'Creative & Design', 'Customer Service & Support', 'Cybersecurity', 
    'Data Science & Analytics', 'Education & Training', 'Engineering', 'Entrepreneurship & Business Ownership', 
    'Finance & Accounting', 'General Management & Administration', 'Healthcare & Medical', 'Human Resources & Recruitment', 
    'Insurance', 'Internships & Entry-Level', 'IT Support & Administration', 'Legal', 
    'Manufacturing & Skilled Trades', 'Marketing & Advertising', 'Network Engineering', 
    'Operations & Logistics', 'Operations Management', 'Product Management', 'Real Estate & Property Management', 
    'Sales & Business Development', 'Software Development', 'Transportation & Delivery', 'Wellness & Lifestyle'
  ];

  final Map<String, Map<String, List<String>>> _locationData = {
  'Australia': {
    'New South Wales': ['Sydney', 'Newcastle', 'Wollongong', 'Central Coast'],
    'Queensland': ['Brisbane', 'Gold Coast', 'Cairns', 'Townsville'],
    'South Australia': ['Adelaide', 'Mount Gambier', 'Whyalla', 'Port Augusta'],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo'],
    'Western Australia': ['Perth', 'Fremantle', 'Albany', 'Bunbury'],
  },
  'Brazil': {
    'Minas Gerais': ['Belo Horizonte', 'Uberlândia', 'Juiz de Fora', 'Contagem'],
    'Rio de Janeiro': ['Rio de Janeiro City', 'Niterói', 'Petropolis', 'Nova Friburgo'],
    'São Paulo': ['São Paulo City', 'Campinas', 'Santos', 'Sorocaba'],
  },
  'Canada': {
    'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge', 'St. Albert'],
    'British Columbia': ['Vancouver', 'Victoria', 'Surrey', 'Burnaby', 'Richmond'],
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Brampton', 'Hamilton'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau', 'Sherbrooke'],
  },
  'China': {
    'Beijing': ['Chaoyang', 'Haidian', 'Dongcheng', 'Xicheng'],
    'Guangdong': ['Guangzhou', 'Shenzhen', 'Foshan', 'Dongguan'],
    'Shanghai': ['Pudong', 'Minhang', 'Huangpu', 'Xuhui'],
    'Sichuan': ['Chengdu', 'Mianyang', 'Nanchong', 'Luzhou'],
  },
  'France': {
    'Auvergne-Rhône-Alpes': ['Lyon', 'Grenoble', 'Saint-Étienne', 'Clermont-Ferrand'],
    'Ile-de-France': ['Paris', 'Versailles', 'Boulogne-Billancourt', 'Montreuil'],
    'Provence-Alpes-Côte d’Azur': ['Marseille', 'Nice', 'Toulon', 'Cannes'],
  },
  'Germany': {
    'Bavaria': ['Munich', 'Nuremberg', 'Augsburg', 'Regensburg'],
    'Berlin': ['Berlin City'],
    'Hesse': ['Frankfurt', 'Wiesbaden', 'Darmstadt', 'Kassel'],
    'North Rhine-Westphalia': ['Cologne', 'Düsseldorf', 'Dortmund', 'Essen'],
  },
  'India': {
    'Delhi': ['New Delhi', 'South Delhi', 'West Delhi', 'North Delhi'],
    'Karnataka': ['Bangalore', 'Mysore', 'Mangalore', 'Hubli'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Salem'],
  },
  'Japan': {
    'Hokkaido': ['Sapporo', 'Hakodate', 'Otaru', 'Asahikawa'],
    'Kyoto': ['Kyoto City', 'Uji', 'Kameoka', 'Nagaokakyo'],
    'Osaka': ['Osaka City', 'Sakai', 'Higashi-Osaka', 'Takatsuki'],
    'Tokyo': ['Shinjuku', 'Shibuya', 'Roppongi', 'Ginza'],
  },
  'Malaysia': {
    'Johor': ['Johor Bahru', 'Muar', 'Batu Pahat', 'Kluang', 'Pontian'],
    'Kuala Lumpur': ['KL City', 'Bangsar', 'Cheras', 'Setapak', 'Mont Kiara'],
    'Penang': ['George Town', 'Bayan Lepas', 'Butterworth', 'Balik Pulau'],
    'Sabah': ['Kota Kinabalu', 'Sandakan', 'Tawau', 'Lahad Datu', 'Ranau'],
    'Selangor': ['Klang', 'Shah Alam', 'Petaling Jaya', 'Subang Jaya', 'Ampang'],
  },
  'South Africa': {
    'Gauteng': ['Johannesburg', 'Pretoria', 'Midrand', 'Soweto'],
    'KwaZulu-Natal': ['Durban', 'Pietermaritzburg', 'Richards Bay', 'Empangeni'],
    'Western Cape': ['Cape Town', 'Stellenbosch', 'George', 'Paarl'],
  },
  'South Korea': {
    'Busan': ['Haeundae', 'Seo-gu', 'Nam-gu', 'Geumjeong'],
    'Incheon': ['Yeonsu', 'Namdong', 'Bupyeong', 'Gyeyang'],
    'Jeju': ['Jeju City', 'Seogwipo'],
    'Seoul': ['Gangnam', 'Jongno', 'Mapo', 'Songpa'],
  },
  'United Kingdom': {
    'England': ['London', 'Manchester', 'Birmingham', 'Liverpool', 'Leeds'],
    'Northern Ireland': ['Belfast', 'Derry', 'Lisburn', 'Newry', 'Bangor'],
    'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee', 'Inverness'],
    'Wales': ['Cardiff', 'Swansea', 'Newport', 'Bangor', 'Wrexham'],
  },
  'USA': {
    'California': ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'Fresno'],
    'Florida': ['Miami', 'Orlando', 'Tampa', 'Jacksonville', 'Tallahassee'],
    'Illinois': ['Chicago', 'Aurora', 'Naperville', 'Springfield'],
    'New York': ['New York City', 'Buffalo', 'Albany', 'Rochester', 'Syracuse'],
    'Texas': ['Houston', 'Austin', 'Dallas', 'San Antonio', 'El Paso'],
  },
};


  // Get combined locations
  List<String> _getCombinedLocations() {
  final countryData = _locationData[_selectedCountry];
  if (countryData == null) return [];
  
  // Ensure unique and valid options
  return countryData.entries
      .expand((stateEntry) => stateEntry.value.map((city) => '${stateEntry.key}, $city'))
      .toSet()
      .toList();
  }

  // Save action
  void _saveJobInfo() {
    print('Saved: ${_jobTitleController.text}, ${_companyNameController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job Information Saved Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2ECE9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2ECE9),
        title: const Text('Job Post'),
        elevation: 0,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Post A Job",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D362D),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Job Title", "Enter job title", _jobTitleController),
              const SizedBox(height: 15),
              _buildTextField("Company or Business Name", "Enter company name", _companyNameController),
              const SizedBox(height: 15),
              _buildDropdown(
                "Country",
                _locationData.keys.toList(),
                _selectedCountry,
                (value) {
                  setState(() {
                    _selectedCountry = value;
                    _selectedLocation = null; // Reset state and city when country changes
                    //_selectedCity = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedCountry != null)
              _buildDropdown(
                "Location",
                _getCombinedLocations(),
                _getCombinedLocations().contains(_selectedLocation) ? _selectedLocation : null, // Validate selected value
                (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              _buildDropdown("Category", _category, _selectedCategory, (value) {
                setState(() {
                  _selectedCategory = value;
                });
              }),
              const SizedBox(height: 15),
              _buildCheckbox(
                "Willing to relocate?",
                _isWillingToRelocate,
                (value) {
                  setState(() {
                    _isWillingToRelocate = value!;
                  });
                },
              ),
              const SizedBox(height: 15),
              _buildTextField("Job Description", "Enter job description", _jobDescController, maxLines: 3),
              const SizedBox(height: 15),
              _buildDropdown("Contract Type", _contractTypes, _selectedContract, (value) {
                setState(() {
                  _selectedContract = value;
                });
              }),
              const SizedBox(height: 15),
              _buildDropdown("Remuneration", _remunerations, _selectedRemuneration, (value) {
                setState(() {
                  _selectedRemuneration = value;
                });
              }),
              const SizedBox(height: 15),
              _buildTextField("Email", "Enter email", _emailController),
              const SizedBox(height: 20),
              // Save Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: _saveJobInfo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown, // Background color
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
              const SizedBox(height: 20),
            ],
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
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: Colors.brown),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
