# Job Bridge

JobBridge is a **hybrid job recommendation system** built using **Flutter** and **Firebase**.  
It leverages **content-based filtering** and **collaborative filtering** to provide personalized job recommendations based on user skills, preferences, and interactions.

## 🚀 Features

- **AI-Based Job Recommendations**  
  - Uses **TF-IDF** for content-based filtering.  
  - Implements **SVD (Singular Value Decomposition)** for collaborative filtering.  
- **Resume Parsing & Skill Matching**  
  - Users input skills during registration, and the system suggests relevant jobs.  
- **User Feedback System**  
  - Users can rate jobs based on salary, work environment, and other criteria.  
- **Interview Scheduling**  
  - Employers and job seekers can communicate and schedule interviews.  
- **Company Rating Prediction (Future Work)**  
  - Predicts company ratings when reviews are unavailable using job description analysis.  

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)  
- **Backend:** Firebase (Firestore, Authentication, Cloud Functions)  
- **Machine Learning:** Google Colab (Model Training)  
- **Database:** Google Cloud Firestore

