import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_demo/components/profile_drawer.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }
  Future<String?> getSignedInUserFirstName() async {
    // Get the currently logged-in user
    final user = FirebaseAuth.instance.currentUser;

    // Check if a user is signed in
    if (user != null) {
      // Get the user's email
      final email = user.email;

      try {
        // Fetch the user's document from the "users" collection based on email
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        // Check if any document matches the query
        if (querySnapshot.docs.isNotEmpty) {
          // Get the first document (there should be only one, since email is unique)
          final docSnapshot = querySnapshot.docs.first;

          // Extract the first name from the document data
          final firstName = docSnapshot['first name'];

          return firstName;
        } else {
          return null; // Handle case where user document doesn't exist
        }
      } catch (error) {
        print('Error retrieving user data: $error');
        return null; // Handle error retrieving user data
      }
    } else {
      return null; // Handle case where no user is signed in
    }
  }

  void goToHomePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emergencyNameController = TextEditingController();
  TextEditingController _emergencyRelationshipController = TextEditingController();
  TextEditingController _emergencyPhoneController = TextEditingController();
  TextEditingController _ssnController = TextEditingController();
  TextEditingController _primaryDocNameController = TextEditingController();

  // Additional attributes as Lists and Strings
  String _gender = '';
  String _maritalStatus = '';
  String _smokingStatus = '';
  List<String> _medicalConditions = [];
  List<String> _familyHistory = [];
  List<String> _medications = [];

  Future<Map<String, dynamic>?> getSignedInUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Assuming 'ehr_records' holds the user-specific form data under their UID
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('ehr_records')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          return docSnapshot.data();
        } else {
          print('No data found for this user.');
          return null;
        }
      } catch (error) {
        print('Error retrieving user data: $error');
        return null;
      }
    }
    return null;
  }

  // Fetch user data
  Future<void> _loadUserData() async {
    Map<String, dynamic>? userData = await getSignedInUserData();
    if (userData != null) {
      _firstNameController.text = userData['first name'] ?? '';
      _middleNameController.text = userData['middle name'] ?? '';
      _lastNameController.text = userData['last name'] ?? '';
      _dobController.text = userData['dob'] ?? '';
      _streetController.text = userData['street'] ?? '';
      _cityController.text = userData['city'] ?? '';
      _stateController.text = userData['state'] ?? '';
      _zipCodeController.text = userData['zip code'] ?? '';
      _phoneController.text = userData['phone number'] ?? '';
      _emergencyNameController.text = userData['emergency contact name'] ?? '';
      _emergencyRelationshipController.text = userData['emergency relationship'] ?? '';
      _emergencyPhoneController.text = userData['emergency phone'] ?? '';
      _ssnController.text = userData['ssn'] ?? '';
      _primaryDocNameController.text = userData['primary doctor name'] ?? '';
      _gender = userData['gender'] ?? '';
      _maritalStatus = userData['marital status'] ?? '';
      _smokingStatus = userData['smoking status'] ?? '';
      _medicalConditions = List<String>.from(userData['medical conditions'] ?? []);
      _familyHistory = List<String>.from(userData['family history'] ?? []);
      _medications = List<String>.from(userData['medications'] ?? []);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: getSignedInUserFirstName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while waiting
            } else if (snapshot.hasData) {
              final firstName = snapshot.data!;
              return Text(
                "$firstName's Profile Page",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error retrieving name'); // Handle errors
            } 
            // Optional: Default greeting if no data yet
            return Text('Profile Page'); 
          },
        ),
        backgroundColor: Colors.deepPurple[300],
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        onHomeTap: goToHomePage,
        onSignOut: signOut,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //profile details
              TextFormField(controller: _firstNameController, decoration: InputDecoration(labelText: "First Name")),
              TextFormField(controller: _middleNameController, decoration: InputDecoration(labelText: "Middle Name")),
              TextFormField(controller: _lastNameController, decoration: InputDecoration(labelText: "Last Name")),
              TextFormField(controller: _dobController, decoration: InputDecoration(labelText: "Date of Birth")),
              TextFormField(controller: _streetController, decoration: InputDecoration(labelText: "Street")),
              TextFormField(controller: _cityController, decoration: InputDecoration(labelText: "City")),
              TextFormField(controller: _stateController, decoration: InputDecoration(labelText: "State")),
              TextFormField(controller: _zipCodeController, decoration: InputDecoration(labelText: "Zip Code")),
              TextFormField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone Number")),
              TextFormField(controller: _emergencyNameController, decoration: InputDecoration(labelText: "Emergency Contact Name")),
              TextFormField(controller: _emergencyRelationshipController, decoration: InputDecoration(labelText: "Emergency Relationship")),
              TextFormField(controller: _emergencyPhoneController, decoration: InputDecoration(labelText: "Emergency Phone")),
              TextFormField(controller: _ssnController, decoration: InputDecoration(labelText: "SSN")),
              TextFormField(controller: _primaryDocNameController, decoration: InputDecoration(labelText: "Primary Doctor Name")),
              // Display lists and non-text data (e.g., gender) as text or chips
              Text("Gender: $_gender"),
              Text("Marital Status: $_maritalStatus"),
              Text("Smoking Status: $_smokingStatus"),
              Wrap(children: _medicalConditions.map((condition) => Chip(label: Text(condition))).toList()),
              Wrap(children: _familyHistory.map((condition) => Chip(label: Text(condition))).toList()),
              Wrap(children: _medications.map((med) => Chip(label: Text(med))).toList()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationshipController.dispose();
    _emergencyPhoneController.dispose();
    _ssnController.dispose();
    _primaryDocNameController.dispose();
    super.dispose();
  }
}