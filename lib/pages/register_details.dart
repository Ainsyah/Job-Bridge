import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/components/my_textfield.dart';
import 'package:job_bridge/pages/menu_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterDetailsPage extends StatefulWidget {
  final String uid;
  const RegisterDetailsPage({super.key, required this.uid});

  @override
  State<RegisterDetailsPage> createState() => _RegisterDetailsPageState();
}

class _RegisterDetailsPageState extends State<RegisterDetailsPage> {

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

  List<String> educationErrorMessages = [];
  List<String> experienceErrorMessages = [];
  List<String> certificateErrorMessages = [];
  List<String> projectErrorMessages = [];
  List<String> awardsErrorMessages = [];
  List<String> languageErrorMessages = [];
  List<String> referenceErrorMessages = [];

  final ScrollController _scrollController = ScrollController();

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
      }, SetOptions(merge: true));
      
      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      
      // Navigate to MenuPage after successful registration
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => MenuPage(userId: widget.uid),
      //     ),
      // );
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

      @override
      void dispose() {
        // Dispose the controller when the widget is disposed
        _scrollController.dispose();
        super.dispose();
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

      void addField(List<Map<String, TextEditingController>> fields, List<String> errors, Map<String, TextEditingController> newField) {
        setState(() {
         fields.add(newField);
          errors.add('');
        });
      }

      void removeField(List<Map<String, TextEditingController>> fields, List<String> errors, int index) {
        setState(() {
          fields.removeAt(index);
          errors.removeAt(index);
        });
      }

      void validateAndSaveField(List<Map<String, TextEditingController>> fields, int index, String collection, List<String> errors) {
        final field = fields[index];
        bool isValid = true;
        field.forEach((key, controller) {
          if (controller.text.isEmpty) {
            isValid = false;
            setState(() {
              errors[index] = "Please fill all fields for ${collection.capitalize()} ${index + 1}";
            });
          }
        });
        if (isValid) {
          saveField(fields, index, collection, errors);
        }
      }

      Future<void> saveField(List<Map<String, TextEditingController>> fields, int index, String collection, List<String> errors) async {
        try {
          final field = fields[index];
          Map<String, String> fieldData = {};
          field.forEach((key, controller) {
            fieldData[key] = controller.text;
          });
        await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .set({
            collection: FieldValue.arrayUnion([fieldData]),
          }, SetOptions(merge: true));
          setState(() {
            errors[index] = 'Saved successfully!';
          });
        } catch (e) {
          setState(() {
            errors[index] = 'Failed to save: $e';
          });
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
          appBar: AppBar(title: const Text('Register Details')),
          body: Scrollbar(
              thumbVisibility: true,
              thickness: 10.0,
              radius: const Radius.circular(8),
              child: SingleChildScrollView(
                child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              buildSection(
                                'Education Background',
                                educationFields,
                                'education',
                                ['eduLevel', 'field', 'uniName', 'uniLocation', 'startEdu', 'endEdu', 'gpa'],
                                educationErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'Work Experience',
                                experienceFields,
                                'experience',
                                ['jobTitle', 'compName', 'compLoc', 'startWorking', 'endWorking', 'desc'],
                                experienceErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'Certificates',
                                certificateFields,
                                'certificate',
                                ['certName', 'certOrgName', 'date'],
                                certificateErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'Projects',
                                projectFields,
                                'project',
                                ['projName', 'projDesc', 'techUsed', 'startProj', 'endProj'],
                                projectErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'Awards',
                                awardsFields,
                                'awards',
                                ['awardName', 'awardOrgName', 'awardDesc', 'awardDate'],
                                awardsErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'Languages',
                                langFields,
                                'language',
                                ['language', 'langProf'],
                                languageErrorMessages,
                              ),
                              SizedBox(height: 20),
                              buildSection(
                                'References',
                                referenceFields,
                                'reference',
                                ['refName', 'refRel', 'refOrgName', 'refEmail', 'refPhone'],
                                referenceErrorMessages,
                              ),
                              SizedBox(height: 30),
                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     fixedSize: const Size(300, 50),
                              //     foregroundColor: Colors.white,
                              //     backgroundColor: Color.fromARGB(255, 71, 62, 59),
                              //     textStyle: TextStyle(fontSize: 20),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //   ),
                              //   onPressed: () {
                              //     // Navigate to the MenuPage
                              //     Navigator.push(
                              //       context,
                              //       //MaterialPageRoute(builder: (context) => MenuPage(userId: widget.uid)),
                              //     );
                              //   },
                              //   child: const Text('Sign Up'),
                              // ),
                            ],
                          ),
                      ),
              ),
          ),
        );
      }
      
      Widget buildSection(String title, List<Map<String, TextEditingController>> fields, String collection, List<String> fieldKeys, List<String> errors) {
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        ...List.generate(fields.length, (index) {
          final field = fields[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const Divider(thickness: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('$title ${index + 1}', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => removeField(fields, errors, index),
                ),
              ],
            ),
            const SizedBox(height: 10),
              ...fieldKeys.map((key) => Column(
                children: [
                  MyTextfield(
                    controller: field[key]!,
                    hintText: key.capitalize(),
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                ],
              )),
              if (errors[index].isNotEmpty)               
              SizedBox(height: 10),
                Text(
                  errors[index],
                  style: const TextStyle(color: Colors.red),
                ),
              //const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => validateAndSaveField(fields, index, collection, errors),
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        }),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => addField(fields, errors, Map.fromIterable(fieldKeys, key: (k) => k, value: (v) => TextEditingController())),
          child: Text('Add Another $title'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 71, 62, 59),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
