import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Calculate cosine similarity between two feature vectors
double calculateCosineSimilarity(List<double> userSkills, List<double> jobFeatures) {
  double dotProduct = 0.0;
  double userSkillsNorm = 0.0;
  double jobFeaturesNorm = 0.0;

  for (int i = 0; i < userSkills.length; i++) {
    dotProduct += userSkills[i] * jobFeatures[i];
    userSkillsNorm += userSkills[i] * userSkills[i];
    jobFeaturesNorm += jobFeatures[i] * jobFeatures[i];
  }

  if (userSkillsNorm == 0 || jobFeaturesNorm == 0) return 0.0; // Handle empty vectors

  return dotProduct / (sqrt(userSkillsNorm) * sqrt(jobFeaturesNorm));
}

// Calculate skill match percentage with dynamic weighting
double calculateSkillMatch(List<String> userSkills, String cleanedDescription) {
  final jobDescriptionWords = cleanedDescription
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(RegExp(r'\s+'));

  final Set<String> descriptionWordSet = jobDescriptionWords.toSet();
  int matchCount = userSkills
      .where((skill) => descriptionWordSet.contains(skill.toLowerCase()))
      .length;

  return matchCount / userSkills.length * 100; // Normalize by user skills length
}

// Hybrid recommendation score with normalization
double hybridRecommendationScore(double contentScore, double collaborativeScore, double alpha) {
  double normalizedContentScore = contentScore.clamp(0.0, 1.0);
  double normalizedCollaborativeScore = collaborativeScore.clamp(0.0, 1.0);
  return alpha * normalizedContentScore + (1 - alpha) * normalizedCollaborativeScore;
}

// Normalize feature vectors
List<double> normalizeFeatures(List<double> features) {
  double maxVal = features.reduce(max);
  if (maxVal == 0) return features; // Avoid division by zero
  return features.map((val) => val / maxVal).toList();
}

// Fetch all job features asynchronously in batches
Future<List<QueryDocumentSnapshot>> fetchAllJobs() async {
  QuerySnapshot allJobsSnapshot = await FirebaseFirestore.instance.collection('job_postings').get();
  return allJobsSnapshot.docs;
}

// Predict job recommendations
Future<void> predictJobRecommendations(String userId) async {
  try {
    // Load TensorFlow Lite model
    final storageRef = FirebaseStorage.instance.ref().child('model/recommendation_model.tflite');
    final tempFile = File('${(await getTemporaryDirectory()).path}/recommendation_model.tflite');
    if (!await tempFile.exists()) {
      await storageRef.writeToFile(tempFile);
    }

    final interpreter = Interpreter.fromFile(tempFile);

    // Fetch user data
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception('User not found');

    List<double> userSkills = List<double>.from(userDoc['skills'] ?? []);
    List<String> userSkillsAsText = userSkills.map((e) => e.toString()).toList();
    List<String> savedJobIds = List<String>.from(userDoc['saved_jobs'] ?? []);

    // Fetch saved job features
    List<List<double>> savedJobFeatures = [];
    for (String jobId in savedJobIds) {
      DocumentSnapshot jobDoc = await FirebaseFirestore.instance.collection('job_postings').doc(jobId).get();
      if (jobDoc.exists) {
        savedJobFeatures.add(List<double>.from(jobDoc['description'] ?? []));
      }
    }

    // Fetch all jobs in batches
    List<QueryDocumentSnapshot> allJobs = await fetchAllJobs();

    List<Map<String, dynamic>> recommendations = [];
    for (var jobDoc in allJobs) {
      String jobId = jobDoc.id;
      List<double> jobFeatures = List<double>.from(jobDoc['description'] ?? []);
      String cleanedDescription = jobDoc['cleaned_description'] ?? '';

      // Calculate skill match percentage
      double skillMatchPercentage = calculateSkillMatch(userSkillsAsText, cleanedDescription);

      // Skip jobs outside a reasonable match range
      if (skillMatchPercentage < 50 || skillMatchPercentage > 70) continue;

      // Normalize job features and calculate content score
      jobFeatures = normalizeFeatures(jobFeatures);
      double contentScore = calculateCosineSimilarity(userSkills, jobFeatures);

      // Calculate collaborative score
      double collaborativeScore = 0.0;
      if (savedJobFeatures.isNotEmpty) {
        for (var savedFeatures in savedJobFeatures) {
          collaborativeScore += calculateCosineSimilarity(savedFeatures, jobFeatures);
        }
        collaborativeScore /= savedJobFeatures.length;
      }

      // Calculate final hybrid score
      double alpha = savedJobIds.isEmpty ? 1.0 : 0.7;
      double finalScore = hybridRecommendationScore(contentScore, collaborativeScore, alpha);

      // Add to recommendations
      recommendations.add({'jobId': jobId, 'score': finalScore});
    }

    // Sort recommendations by score in descending order
    recommendations.sort((a, b) => b['score'].compareTo(a['score']));

    // Save top N recommendations to Firestore
    const int topN = 10;
    List<String> topRecommendedJobIds = recommendations
        .take(topN)
        .map((recommendation) => recommendation['jobId'] as String)
        .toList();

    await FirebaseFirestore.instance.collection('user_recommendations').doc(userId).set({
      'recommended_jobs': topRecommendedJobIds,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    interpreter.close();
  } catch (e) {
    print('Error predicting job recommendations: $e');
  }
}
