import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRating extends StatefulWidget {
  final String userId;

  const AddRating({Key? key, required this.userId}) : super(key: key);

  @override
  _AddRatingState createState() => _AddRatingState();
}

class _AddRatingState extends State<AddRating> {
  String? selectedJobTitle;
  String? companyName;
  double rating = 3.0; // Default rating
  List<String> jobTitles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobTitles();
  }

  // Fetch job titles from Firestore
  Future<void> fetchJobTitles() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('job_postings')
          .get();
      List<String> titles = [];
      snapshot.docs.forEach((doc) {
        titles.add(doc['title']);
      });
      setState(() {
        jobTitles = titles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching job titles: $e");
    }
  }

  // Fetch company name based on selected job title
  Future<void> fetchCompanyName() async {
    if (selectedJobTitle != null) {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('job_postings')
            .where('title', isEqualTo: selectedJobTitle)
            .get();
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            companyName = snapshot.docs.first['company_name'];
          });
        }
      } catch (e) {
        print("Error fetching company name: $e");
      }
    }
  }

  // Submit the rating
  Future<void> submitRating() async {
    if (selectedJobTitle != null && companyName != null) {
      try {
        await FirebaseFirestore.instance.collection('ratings').add({
          'user_id': widget.userId,
          'title': selectedJobTitle,
          'company_name': companyName,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Navigator.of(context).pop(); // Close the dialog
      } catch (e) {
        print("Error submitting rating: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Rating"),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for job title selection
                    DropdownButton<String>(
                      hint: const Text("Select Job Title"),
                      value: selectedJobTitle,
                      onChanged: (value) {
                        setState(() {
                          selectedJobTitle = value;
                        });
                        fetchCompanyName(); // Fetch company name based on job title
                      },
                      items: jobTitles.map((title) {
                        return DropdownMenuItem(
                          value: title,
                          child: Text(title),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
            
                  // Display company name (autofilled)
                  if (companyName != null) ...[
                    Text("Company: $companyName"),
                    const SizedBox(height: 16),
                  ],
            
                  // Rating Bar
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (ratingValue) {
                      setState(() {
                        rating = ratingValue;
                      });
                    },
                  ),
                ],
              ),
          ),
      actions: [
        // Submit Button
        TextButton(
          onPressed: submitRating,
          child: const Text("Submit"),
        ),
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
