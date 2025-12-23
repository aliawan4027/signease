import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:sign_ease/utils/cloudinary_service.dart';
import 'package:sign_ease/utils/firebase_handler.dart';
import 'package:sign_ease/providers/theme_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

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
  dynamic _profileImage;
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    // Load preferences from global provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeProvider>(context, listen: false).loadPreferences();
    });
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

  Future<void> _savePreferences() async {
    // Save preferences using global provider
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.savePreferences();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved successfully!')),
    );
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

  Future<void> _uploadProfileImage(dynamic image) async {
    try {
      final firebaseHandler = FirebaseHandler();
      final user = firebaseHandler.auth.currentUser;
      if (user != null && image != null) {
        // Upload to Cloudinary instead of Firebase Storage
        final cloudinaryUrl = await CloudinaryService.uploadImage(image);

        if (cloudinaryUrl != null) {
          // Update Firestore with Cloudinary URL
          final profileDoc =
              firebaseHandler.firestore.collection('profile').doc(user.uid);
          await profileDoc.set({
            'profileImageUrl': cloudinaryUrl,
          }, SetOptions(merge: true));

          setState(() {
            _profileImageUrl = cloudinaryUrl;
          });

          print('File uploaded to Cloudinary and URL saved successfully.');
        } else {
          print('Failed to upload image to Cloudinary');
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
          if (kIsWeb) {
            _profileImage = pickedFile; // For web, store XFile directly
          } else {
            _profileImage =
                File(pickedFile.path); // For mobile, convert to File
          }
        });
        await _uploadProfileImage(_profileImage);
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
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(themeProvider.isUrduLanguage ? 'پروفائل' : 'Profile'),
          backgroundColor: themeProvider.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
              color: Colors.white,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: themeProvider.containerColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          _profileImage != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundColor: hexStringToColor("2986cc"),
                                  backgroundImage: kIsWeb
                                      ? null
                                      : FileImage(_profileImage!)
                                          as ImageProvider<Object>,
                                  child: kIsWeb
                                      ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                              : (_profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty)
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage(_profileImageUrl!)
                                              as ImageProvider<Object>,
                                      onBackgroundImageError: (_, __) {
                                        print('Error loading profile image.');
                                      },
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor:
                                          hexStringToColor("2986cc"),
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
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
                    Text(
                      themeProvider.isUrduLanguage ? 'نام' : 'Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 7, 130, 230)
                            .withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      style: TextStyle(
                        color: themeProvider.textColor,
                        decoration: TextDecoration.underline,
                        decorationColor: themeProvider.primaryColor,
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      themeProvider.isUrduLanguage ? 'ای میل' : 'Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 7, 130, 230)
                            .withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      style: TextStyle(color: themeProvider.textColor),
                      readOnly: !_isEditing,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      themeProvider.isUrduLanguage
                          ? 'فون نمبر'
                          : 'Phone Number',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 7, 130, 230)
                            .withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      style: TextStyle(color: themeProvider.textColor),
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
                          _isEditing
                              ? (themeProvider.isUrduLanguage
                                  ? 'تبدیلیاںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںں'
                                  : 'Save Changes')
                              : (themeProvider.isUrduLanguage
                                  ? 'ایڈیٹ پروفائل'
                                  : 'Edit Profile'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: themeProvider.containerColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeProvider.isUrduLanguage ? 'ترتیبات' : 'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Theme Selection
                    Text(
                      themeProvider.isUrduLanguage
                          ? 'تھیم سلیکشن'
                          : 'Theme Selection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return GestureDetector(
                              onTap: () => themeProvider.setTheme('blue'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: themeProvider.selectedTheme == 'blue'
                                      ? Colors.blue
                                      : Colors.blue.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: themeProvider.selectedTheme == 'blue'
                                      ? Border.all(color: Colors.blue, width: 2)
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Blue',
                                      style: TextStyle(
                                        color: themeProvider.selectedTheme ==
                                                'blue'
                                            ? themeProvider.textColor
                                            : Colors.blue,
                                        fontWeight:
                                            themeProvider.selectedTheme ==
                                                    'blue'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return GestureDetector(
                              onTap: () => themeProvider.setTheme('green'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: themeProvider.selectedTheme == 'green'
                                      ? Colors.green
                                      : Colors.green.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: themeProvider.selectedTheme == 'green'
                                      ? Border.all(
                                          color: Colors.green, width: 2)
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Green',
                                      style: TextStyle(
                                        color: themeProvider.selectedTheme ==
                                                'green'
                                            ? themeProvider.textColor
                                            : Colors.green,
                                        fontWeight:
                                            themeProvider.selectedTheme ==
                                                    'green'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return GestureDetector(
                              onTap: () => themeProvider.setTheme('pink'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: themeProvider.selectedTheme == 'pink'
                                      ? Colors.pink
                                      : Colors.pink.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: themeProvider.selectedTheme == 'pink'
                                      ? Border.all(color: Colors.pink, width: 2)
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Pink',
                                      style: TextStyle(
                                        color: themeProvider.selectedTheme ==
                                                'pink'
                                            ? themeProvider.textColor
                                            : Colors.pink,
                                        fontWeight:
                                            themeProvider.selectedTheme ==
                                                    'pink'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return GestureDetector(
                              onTap: () => themeProvider.setTheme('purple'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: themeProvider.selectedTheme == 'purple'
                                      ? Colors.purple
                                      : Colors.purple.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      themeProvider.selectedTheme == 'purple'
                                          ? Border.all(
                                              color: Colors.purple, width: 2)
                                          : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.purple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Purple',
                                      style: TextStyle(
                                        color: themeProvider.selectedTheme ==
                                                'purple'
                                            ? themeProvider.textColor
                                            : Colors.purple,
                                        fontWeight:
                                            themeProvider.selectedTheme ==
                                                    'purple'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return GestureDetector(
                              onTap: () => themeProvider.setTheme('yellow'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: themeProvider.selectedTheme == 'yellow'
                                      ? Colors.yellow
                                      : Colors.yellow.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      themeProvider.selectedTheme == 'yellow'
                                          ? Border.all(
                                              color: Colors.yellow, width: 2)
                                          : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Yellow',
                                      style: TextStyle(
                                        color: themeProvider.selectedTheme ==
                                                'yellow'
                                            ? themeProvider.textColor
                                            : Colors.yellow,
                                        fontWeight:
                                            themeProvider.selectedTheme ==
                                                    'yellow'
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Language Selection
                    Text(
                      themeProvider.isUrduLanguage
                          ? 'زبان سلیکشن'
                          : 'Language Selection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'English',
                              style: TextStyle(color: themeProvider.textColor),
                            ),
                            leading: Radio<bool>(
                              value: false,
                              groupValue: themeProvider.isUrduLanguage,
                              onChanged: (value) {
                                themeProvider.setLanguage(value!);
                                setState(() {
                                  _hasChanges = true;
                                });
                              },
                            ),
                            onTap: () {
                              themeProvider.setLanguage(false);
                              setState(() {
                                _hasChanges = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'اردو',
                              style: TextStyle(color: themeProvider.textColor),
                            ),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: themeProvider.isUrduLanguage,
                              onChanged: (value) {
                                themeProvider.setLanguage(value!);
                                setState(() {
                                  _hasChanges = true;
                                });
                              },
                            ),
                            onTap: () {
                              themeProvider.setLanguage(true);
                              setState(() {
                                _hasChanges = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Save Changes Button
                    if (_hasChanges)
                      Center(
                        child: ElevatedButton(
                          onPressed: _savePreferences,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            themeProvider.isUrduLanguage
                                ? 'تبدیلیاںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںںں'
                                : 'Save Changes',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: themeProvider.containerColor,
      );
    });
  }
}
