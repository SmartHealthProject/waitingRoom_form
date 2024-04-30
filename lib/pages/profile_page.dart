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
            ],
          ),
        ),
      ),
    );
  }
}