import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/utils/colors_utils.dart'; // Import SignInScreen

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  bool _isEditing = false;
  File? _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profileDoc =
          FirebaseFirestore.instance.collection('profile').doc(user.uid);
      final docSnapshot = await profileDoc.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _profileImageUrl = data['profileImageUrl'] ?? '';
          print('Fetched profile image URL: $_profileImageUrl');
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profileDoc =
          FirebaseFirestore.instance.collection('profile').doc(user.uid);
      await profileDoc.set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'profileImageUrl': _profileImageUrl,
      });
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && image != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'profile_images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = await storageRef.putFile(image);

        if (uploadTask.state == TaskState.success) {
          final downloadUrl = await storageRef.getDownloadURL();

          final profileDoc =
              FirebaseFirestore.instance.collection('profile').doc(user.uid);
          await profileDoc.update({'profileImageUrl': downloadUrl});

          setState(() {
            _profileImageUrl = downloadUrl;
          });

          print('File uploaded and URL saved successfully.');
        } else {
          print('Upload failed. Task state: ${uploadTask.state}');
        }
      }
    } catch (e) {
      print('Error uploading profile image: $e');
    }
  }

  Future<void> _pickImage() async {
    if (_isEditing) {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        await _uploadProfileImage(_profileImage!);
      }
    }
  }

  Future<void> _logout() async {
    try {
      // Show a confirmation dialog
      bool? confirmLogout = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false (no logout)
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true (logout)
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      // If the user confirmed, log them out
      if (confirmLogout == true) {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        backgroundColor: hexStringToColor("2986cc"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_profileImageUrl != null &&
                                _profileImageUrl!.isNotEmpty)
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      print('Error loading profile image.');
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _isEditing ? _pickImage : null,
                      color: Colors.blue,
                      iconSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 7, 130, 230).withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: const TextStyle(color: Colors.black),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 16),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 7, 130, 230).withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: const TextStyle(color: Colors.black),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 16),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 7, 130, 230).withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: const TextStyle(color: Colors.black),
              readOnly: !_isEditing,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      _updateUserProfile();
                      _isEditing = false;
                    } else {
                      _isEditing = true;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexStringToColor("5b5b5b"),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Edit Profile',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: hexStringToColor("ffffff"),
    );
  }
}
