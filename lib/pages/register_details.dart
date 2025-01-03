import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/components/my_textfield.dart';
import 'package:job_bridge/pages/menu_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterDetailsPage extends StatefulWidget {
  final String uid;
  const RegisterDetailsPage({super.key, required this.uid});

  @override
  State<RegisterDetailsPage> createState() => _RegisterDetailsPageState();
}

class _RegisterDetailsPageState extends State<RegisterDetailsPage> {

  bool showEducationFields = false;
  bool showExperienceFields = false;
  bool showAwardFields = false;
  bool showProjectFields = false;
  bool showCertificateFields = false;
  bool showLanguageFields = false;
  bool showReferenceFields = false;
  bool isTechSkill = true;
  List<String> techSkills = [];
  List<String> softSkills = [];
  final TextEditingController skillController = TextEditingController();
  Map<String, String> techSkillProficiencies = {};
  Map<String, String> softSkillProficiencies = {};
  List<Map<String, TextEditingController>> educationFields = [];
  List<Map<String, TextEditingController>> experienceFields = [];
  List<Map<String, TextEditingController>> awardsFields = [];
  List<Map<String, TextEditingController>> projectFields = [];
  List<Map<String, TextEditingController>> certificateFields = [];
  List<Map<String, TextEditingController>> langFields = [];
  List<Map<String, TextEditingController>> referenceFields = [];


  // Text editing controllers
  final summaryController = TextEditingController();

  final eduLevelController = TextEditingController();
  final fieldOfStudyController = TextEditingController();
  final uniNameController = TextEditingController();
  final uniLocationController = TextEditingController();
  final startEduController = TextEditingController();
  final endEduController = TextEditingController();
  final gpaController = TextEditingController();

  final jobTitleController = TextEditingController();
  final compNameController = TextEditingController();
  final compLocationController = TextEditingController();
  final startWorkingController = TextEditingController();
  final endWorkingController = TextEditingController();
  final jobDescController = TextEditingController();

  final techSkillController = TextEditingController();
  final softSkillController = TextEditingController();
  final skillProficiencyController = TextEditingController();

  final certNameController = TextEditingController();
  final certOrgNameController = TextEditingController();
  final dateCompletionController = TextEditingController();

  final projectNameController = TextEditingController();
  final projectDescController = TextEditingController();
  final techUsedController = TextEditingController();
  final startProjectController = TextEditingController();
  final endProjectController = TextEditingController();

  final awardNameController = TextEditingController();
  final awardOrgNameController = TextEditingController();
  final awardReceivedController = TextEditingController();
  final awardDescController = TextEditingController();

  final languagesController = TextEditingController();
  final langProficiencyController  = TextEditingController();

  final refNameController = TextEditingController();
  final refRelationshipController = TextEditingController();
  final refOrgNameController = TextEditingController();
  final refEmailController = TextEditingController();
  final refPhoneController = TextEditingController();
  

  // Sign user up method
  void signUserUp() async {
    // Check if email or password is empty
    if (summaryController.text.isEmpty ||
      eduLevelController.text.isEmpty ||
      fieldOfStudyController.text.isEmpty ||
      uniNameController.text.isEmpty ||
      uniLocationController.text.isEmpty ||
      startEduController.text.isEmpty ||
      endEduController.text.isEmpty ||
      gpaController.text.isEmpty ||
      jobTitleController.text.isEmpty ||
      jobDescController.text.isEmpty ||
      compLocationController.text.isEmpty ||
      compNameController.text.isEmpty ||
      startWorkingController.text.isEmpty ||
      endWorkingController.text.isEmpty ||
      techSkillController.text.isEmpty ||
      softSkillController.text.isEmpty ||
      skillProficiencyController.text.isEmpty) {
    showErrorMessage('Please fill in all fields');
    return;
  }

    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing on tap
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    // Create a Firestore reference
    CollectionReference ref =
        FirebaseFirestore.instance.collection('users');
        

    // Save user data to Firestore
    try {
      await ref.doc(widget.uid).set({
        'summary': summaryController.text,
        'eduLevel': eduLevelController.text,
        'field': fieldOfStudyController.text,
        'uniName': uniNameController.text,
        'uniLoc': uniLocationController.text,
        'startEdu': startEduController.text,
        'endEdu': endEduController.text,
        'gpa': gpaController.text,
        'jobtitle': jobTitleController.text,
        'compName': compNameController.text,
        'compLoc': compLocationController.text,
        'startWorking': startWorkingController.text,
        'endWorking': endWorkingController.text,
        'desc': jobDescController.text,
        'techSkills': techSkillController.text,
        'softSkills': softSkillController.text,
        'skillProf': skillProficiencyController.text,
        'certName': certNameController.text,
        'certOrgName': certOrgNameController.text,
        'date': dateCompletionController.text,
        'projName': projectNameController.text,
        'projDesc': projectDescController.text,
        'techUsed': techUsedController.text,
        'startProj': startProjectController.text,
        'endProj': endProjectController.text,
        'awardName': awardNameController.text,
        'awardOrgName': awardOrgNameController.text,
        'awardDesc': awardDescController.text,
        'awardDate': awardReceivedController.text,
        'language': languagesController.text,
        'langProf': langProficiencyController.text,
        'refName': refNameController.text,
        'refRel': refRelationshipController.text,
        'refOrgName': refOrgNameController.text,
        'refEmail': refEmailController.text,
        'refPhone': refPhoneController.text,
      }, SetOptions(merge: true)); // Correctly place SetOptions
      
      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      
      // Navigate to MenuPage after successful registration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MenuPage(userId: widget.uid),
          ),
      );
      } on FirebaseAuthException catch (e) {
        // Pop the loading circle
        Navigator.of(context).pop(); // Close the loading dialog
        // Show error message
        showErrorMessage(e.message ?? "An error occurred");
        }
      }

      // Error message to the user
      void showErrorMessage(String message) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 71, 62, 59),
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          },
        );
      }

      void addSkill() {
        final skill = skillController.text.trim();
        if (skill.isNotEmpty) {
          setState(() {
            if (isTechSkill) {
              if (!techSkills.contains(skill)){
                techSkills.add(skill);
              }
            } else {
              if (!softSkills.contains(skill)){
                softSkills.add(skill);
              }
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
        try{
          await FirebaseFirestore.instance.doc(widget.uid).update({
            'techSkills': techSkills,
            'softSkills': softSkills,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Skills updated successfully')),
          );
        } catch (e){
          print('Error saving skills: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update skills')),
          );
        }
      }
      
      void addEducationField() {
        setState(() {
          educationFields.add({
            'eduLevel': TextEditingController(),
            'field': TextEditingController(),
            'uniName': TextEditingController(),
            'uniLoc': TextEditingController(),
            'startEdu': TextEditingController(),
            'endEdu': TextEditingController(),
            'gpa': TextEditingController(),
          });
        });
      }

      void addExperienceField() {
        setState(() {
          experienceFields.add({
            'jobTitle': TextEditingController(),
            'compName': TextEditingController(),
            'compLoc': TextEditingController(),
            'uniLocation': TextEditingController(),
            'techskill': TextEditingController(),
            'softskill': TextEditingController(),
            'skillProf': TextEditingController(),
          });
        });
      }

      void addCertificateField() {
        setState(() {
          certificateFields.add({
            'certName': TextEditingController(),
            'certOrgName': TextEditingController(),
            'date': TextEditingController(),
          });
        });
      }

      void addProjectField() {
        setState(() {
          projectFields.add({
            'projName': TextEditingController(),
            'projDesc': TextEditingController(),
            'techUsed': TextEditingController(),
            'startProj': TextEditingController(),
            'endProj': TextEditingController(),
          });
        });
      }

      void addAwardsField() {
        setState(() {
          awardsFields.add({
            'awardName': TextEditingController(),
            'awardOrgName': TextEditingController(),
            'awardDesc': TextEditingController(),
            'awardDate': TextEditingController(),
          });
        });
      }

      void addLanguageField() {
        setState(() {
          langFields.add({
            'language': TextEditingController(),
            'langProf': TextEditingController(),
          });
        });
      }

      void addReferenceField() {
        setState(() {
          referenceFields.add({
            'reName': TextEditingController(),
            'refRel': TextEditingController(),
            'refOrgName': TextEditingController(),
            'refEmail': TextEditingController(),
            'refPhone': TextEditingController(),
          });
        });
      }
      
      @override 
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 242, 236, 233),
          body: SafeArea(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                  
                      // Logo
                      const Icon(
                        Icons.phone_android,
                        size: 50,
                      ),
                  
                      const SizedBox(height: 30),
                  
                      // Let's create an account for you
                      Text(
                        'Please fill in all the required information',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                  
                      const SizedBox(height: 30),
                  
                      Text(
                        'Headline',
                        style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                  
                      // Fullname
                      MyTextfield(
                        controller: summaryController,
                        hintText: 'Summary',
                        obscureText: false,
                      ),
                  
                      const SizedBox(height: 35),

                      const Divider(thickness: 2, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Education Background',
                        style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      CheckboxListTile(
                        title: Text('(Include Education Background)'),
                        value: showEducationFields,
                        onChanged: (bool? value) {
                          setState(() {
                            showEducationFields = value ?? false;
                            if (showEducationFields){
                              educationFields = [
                                {
                                  'eduLevel': TextEditingController(),
                                  'field': TextEditingController(),
                                  'uniName': TextEditingController(),
                                  'uniLocation': TextEditingController(),
                                  'startEdu': TextEditingController(),
                                  'endEdu': TextEditingController(),
                                  'gpa': TextEditingController(),
                                }
                              ];
                            } else {
                              educationFields.clear();
                            }
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      ),
                      SizedBox(height: 10),
                  
                      if (showEducationFields)
                      Column(
                        children: [
                          for (int i = 0; i < educationFields.length; i++) ...[
                            if (i > 0) SizedBox(height: 15),
                            Text('Education ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            MyTextfield(
                              controller: educationFields[i]['eduLevel'],
                              hintText: 'Education Level',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['field'],
                              hintText: 'Field of Study',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['uniName'],
                              hintText: 'University Name',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['uniLocation'],
                              hintText: 'University Location',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['startEdu'],
                              hintText: 'Start Year',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['endEdu'],
                              hintText: 'End Year',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: educationFields[i]['gpa'],
                              hintText: 'CGPA',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                          ],
                          
                          // Add button to add more education fields
                          ElevatedButton(
                            onPressed: addEducationField,
                            child: Text('Add Education', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      const Divider(thickness: 2, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Work Experience',
                        style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                  
                      CheckboxListTile(
                        title: Text('(Include Work Experience)'),
                        value: showExperienceFields,
                        onChanged: (bool? value) {
                          setState(() {
                            showExperienceFields = value ?? false;
                            if (showExperienceFields){
                              educationFields = [
                                {
                                  'jobTitle': TextEditingController(),
                                  'compName': TextEditingController(),
                                  'compLoc': TextEditingController(),
                                  'uniLocation': TextEditingController(),
                                  'techskill': TextEditingController(),
                                  'softskill': TextEditingController(),
                                  'skillProf': TextEditingController(),
                                }
                              ];
                            } else {
                              experienceFields.clear();
                            }
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      ),
                      SizedBox(height: 20),
                  
                      if(showExperienceFields)
                      Column(
                        children: [
                          for (int i = 0; i < experienceFields.length; i++) ...[
                            if (i > 0) SizedBox(height: 15),
                            Text('Work Experience ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            MyTextfield(
                              controller: experienceFields[i]['jobTitle'],
                              hintText: 'Title',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: experienceFields[i]['compName'],
                              hintText: 'Company Name',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: experienceFields[i]['compLoc'],
                              hintText: 'Company Location',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: experienceFields[i]['startWorking'],
                              hintText: 'Start Year',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: experienceFields[i]['endWorking'],
                              hintText: 'End Year',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            MyTextfield(
                              controller: experienceFields[i]['desc'],
                              hintText: 'Job Description',
                              obscureText: false,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Text('Skill Type:', style: TextStyle(fontSize: 16)),
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
                            const Text(
                              'Technical Skills:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16, // Horizontal spacing between widgets
                              runSpacing: 8, // Vertical spacing between rows
                              children: techSkills.map((skill) {
                                return Container(
                                  constraints: const BoxConstraints(maxWidth: 250), // Limit the width of each item
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Chip(
                                        label: Text(skill),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () => removeSkill(techSkills, skill),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: techSkillProficiencies[skill] ?? 'Basic',
                                        decoration: const InputDecoration(
                                          labelText: 'Proficiency',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                        items: const [
                                          DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                                          DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                                          DropdownMenuItem(value: 'Expert', child: Text('Expert')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            techSkillProficiencies[skill] = value ?? 'Basic';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Soft Skills:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16, // Horizontal spacing between widgets
                              runSpacing: 8, // Vertical spacing between rows
                              children: softSkills.map((skill) {
                                return Container(
                                  constraints: const BoxConstraints(maxWidth: 250), // Limit the width of each item
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Chip(
                                        label: Text(skill),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () => removeSkill(softSkills, skill),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: softSkillProficiencies[skill] ?? 'Basic',
                                        decoration: const InputDecoration(
                                          labelText: 'Proficiency',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                                            DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                                            DropdownMenuItem(value: 'Expert', child: Text('Expert')),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              softSkillProficiencies[skill] = value ?? 'Basic';
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                          ],
                          // Add button to add more education fields
                          ElevatedButton(
                            onPressed: addExperienceField,
                            child: Text('Add Work Experience', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                    const SizedBox(height: 30),
                  
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Certificates',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    
                    CheckboxListTile(
                      title: Text('(Include Certificates)'),
                      value: showCertificateFields,
                      onChanged: (bool? value) {
                        setState(() {
                          showCertificateFields = value ?? false;
                            if (showCertificateFields){
                              educationFields = [
                                {
                                  'certName': TextEditingController(),
                                  'certOrgName': TextEditingController(),
                                  'date': TextEditingController(),
                                }
                              ];
                            } else {
                              certificateFields.clear();
                            }
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 20),
                    
                    if (showCertificateFields)
                    Column(
                      children: [
                        for (int i = 0; i < certificateFields.length; i++) ...[
                          if (i > 0) SizedBox(height: 15),
                          Text('Certificate ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          MyTextfield(
                            controller: certificateFields[i]['certName'],
                            hintText: 'Certificate Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: certificateFields[i]['certOrgName'],
                            hintText: 'Certificate Organization Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: certificateFields[i]['date'],
                            hintText: 'Date Completion',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                        // Add button to add more education fields
                        ElevatedButton(
                          onPressed: addCertificateField,
                            child: Text('Add Certificate', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Projects',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  
                    CheckboxListTile(
                      title: Text('(Include Projects)'),
                      value: showProjectFields,
                      onChanged: (bool? value) {
                        setState(() {
                          showProjectFields = value ?? false;
                            if (showProjectFields){
                              projectFields = [
                                {
                                  'projName': TextEditingController(),
                                  'projDesc': TextEditingController(),
                                  'techUsed': TextEditingController(),
                                  'startProj': TextEditingController(),
                                  'endProj': TextEditingController(),
                                }
                              ];
                            } else {
                              projectFields.clear();
                            }
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 20),
                    
                    if (showProjectFields)
                    Column(
                      children: [
                        for (int i = 0; i < projectFields.length; i++) ...[
                          if (i > 0) SizedBox(height: 15),
                          Text('Projects ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          MyTextfield(
                            controller: projectFields[i]['projName'],
                            hintText: 'Project Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: projectFields[i]['projDesc'],
                            hintText: 'Project Description',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: projectFields[i]['techUsed'],
                            hintText: 'Technology used',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: projectFields[i]['startProj'],
                            hintText: 'Start Year',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: projectFields[i]['endProject'],
                            hintText: 'End Year',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                        // Add button to add more education fields
                        ElevatedButton(
                          onPressed: addProjectField,
                            child: Text('Add Project', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Awards',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  
                    CheckboxListTile(
                      title: Text('(Include Awards)'),
                      value: showAwardFields,
                      onChanged: (bool? value) {
                        setState(() {
                          showAwardFields = value ?? false;
                            if (showAwardFields){
                              awardsFields = [
                                {
                                  'awardName': TextEditingController(),
                                  'awardOrgName': TextEditingController(),
                                  'awardDesc': TextEditingController(),
                                  'awardDate': TextEditingController(),
                                }
                              ];
                            } else {
                              awardsFields.clear();
                            }
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 20),
                    
                    if (showAwardFields)
                    Column(
                      children: [
                        for (int i = 0; i < awardsFields.length; i++) ...[
                          if (i > 0) SizedBox(height: 15),
                          Text('Awards ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          MyTextfield(
                            controller: awardsFields[i]['awardName'],
                            hintText: 'Award Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: awardsFields[i]['awardOrgName'],
                            hintText: 'Award Organization Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: awardsFields[i]['awardDesc'],
                            hintText: 'Award Description',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: awardsFields[i]['awardDate'],
                            hintText: 'Award Date',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                        // Add button to add more education fields
                        ElevatedButton(
                          onPressed: addAwardsField,
                            child: Text('Add Award', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Languages',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  
                    CheckboxListTile(
                      title: Text('(Include Languages)'),
                      value: showLanguageFields,
                      onChanged: (bool? value) {
                        setState(() {
                          showLanguageFields = value ?? false;
                            if (showLanguageFields){
                              langFields = [
                                {
                                  'language': TextEditingController(),
                                  'langProf': TextEditingController(),
                                }
                              ];
                            } else {
                              langFields.clear();
                            }
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 20),
                    
                    if (showLanguageFields)
                    Column(
                      children: [
                        for (int i = 0; i < langFields.length; i++) ...[
                          if (i > 0) SizedBox(height: 15),
                          Text('Languages ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          MyTextfield(
                            controller: langFields[i]['language'],
                            hintText: 'Language',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: langFields[i]['langProf'],
                            hintText: 'Language Proficiency',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                        // Add button to add more education fields
                        ElevatedButton(
                          onPressed: addLanguageField,
                            child: Text('Add Language', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'References',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  
                    CheckboxListTile(
                      title: Text('(Include References)'),
                      value: showReferenceFields,
                      onChanged: (bool? value) {
                        setState(() {
                          showReferenceFields = value ?? false;
                            if (showReferenceFields){
                              referenceFields = [
                                {
                                  'reName': TextEditingController(),
                                  'refRel': TextEditingController(),
                                  'refOrgName': TextEditingController(),
                                  'refEmail': TextEditingController(),
                                  'refPhone': TextEditingController(),
                                }
                              ];
                            } else {
                              referenceFields.clear();
                            }
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 20),
                    
                    if (showReferenceFields)
                    Column(
                      children: [
                        for (int i = 0; i < referenceFields.length; i++) ...[
                          if (i > 0) SizedBox(height: 15),
                          Text('References ${i + 1}', style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          MyTextfield(
                            controller: referenceFields[i]['refName'],
                            hintText: 'Reference Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: referenceFields[i]['refRel'],
                            hintText: 'Reference Relationship',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: referenceFields[i]['refOrgName'],
                            hintText: 'Reference Organization Name',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: referenceFields[i]['refEmail'],
                            hintText: 'Reference Email',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                          MyTextfield(
                            controller: referenceFields[i]['refPhone'],
                            hintText: 'Reference Phone',
                            obscureText: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                        // Add button to add more education fields
                        ElevatedButton(
                          onPressed: addReferenceField,
                            child: Text('Add Reference', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  
                    // Sign up button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //fixedSize: const Size(300, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 71, 62, 59),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: signUserUp,
                      child: const Text('Submit'),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
                ),
            ),
          ),
        ),
      );
    }
}
