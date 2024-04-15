import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_demo/components/drawer.dart';
import 'package:form_demo/pages/profile_page.dart';
import 'package:form_demo/read%20data/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {

  //sign out the user
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

  void goToProfilePage(){
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
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
                'Welcome, $firstName!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error retrieving name'); // Handle errors
            } 
            // Optional: Default greeting if no data yet
            return Text('Welcome!'); 
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
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      //body:
    );
  }
}