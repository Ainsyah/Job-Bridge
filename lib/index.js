const admin = require('firebase-admin');
const csv = require('csv-parser');
const { Storage } = require('@google-cloud/storage');

admin.initializeApp({
  credential: admin.credential.cert('C:/Users/ainsy/Downloads/jobbridge-447015-ba5b98f81e82.json'),
  storageBucket: 'jobbridge-dataset.appspot.com', // Correct bucket name
});

// Initialize Google Cloud Storage
const storage = new Storage({
    projectId: 'job-bridge-e885b',
    keyFilename: 'C:/Users/ainsy/Downloads/jobbridge-447015-ba5b98f81e82.json',
  });

// Reference to your bucket in Google Cloud Storage
const bucket = storage.bucket('jobbridge-dataset');

// Access a file from your bucket
const file = bucket.file('updated_job_postings.csv');

file.createReadStream()
  .pipe(csv())
  .on('data', (row) => {
    console.log('Row:', row);  // Process the row data here
  })
  .on('end', () => {
    console.log('CSV file processing completed!');
  })
  .on('error', (error) => {
    console.error('Error processing file:', error);
  });
