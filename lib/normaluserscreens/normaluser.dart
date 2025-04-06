import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import SystemNavigator
import 'package:sign_ease/normaluserscreens/gameNl.dart';
import 'package:sign_ease/normaluserscreens/normaluserchathead.dart';
import 'package:sign_ease/normaluserscreens/startchatNL.dart';
import 'package:sign_ease/screens/hand.dart';
import 'package:sign_ease/screens/report.dart';
import 'package:sign_ease/screens/profile.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class NormalUser extends StatefulWidget {
  const NormalUser({super.key});

  @override
  State<NormalUser> createState() => _NormalUserState();
}

class _NormalUserState extends State<NormalUser> {
  int _selectedIndex = 1;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return {'username': 'Unknown User', 'email': 'Unknown Email'};
  }

  Future<void> _deleteChat(String chatId) async {
    try {
      // Delete all messages in the chat
      final messagesRef = FirebaseFirestore.instance
          .collection('universalMessages')
          .doc(chatId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      // Delete the chat room itself
      await FirebaseFirestore.instance
          .collection('universalChats')
          .doc(chatId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat and messages deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete chat: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const Profile(),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('universalChats')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data?.docs.where((chatDoc) {
            final participants = chatDoc['participants'] as List<dynamic>;
            return participants.any((id) => id != currentUserId);
          }).toList();

          if (chats == null || chats.isEmpty) {
            return const Center(
              child: Text('No chats yet. Start a new chat!'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final List<dynamic> participants = chatData['participants'];
              final otherUserId = participants.firstWhere(
                (id) => id != currentUserId,
                orElse: () => null,
              );

              if (otherUserId == null) return Container();

              return FutureBuilder<Map<String, dynamic>>(
                future: _getUserDetails(otherUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/demo.jpg'),
                      ),
                      title: Text('Loading...'),
                    );
                  }

                  final userDetails = snapshot.data!;
                  final userName = userDetails['username'];
                  final userEmail = userDetails['email'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NormalUserChatHead(
                            userId: otherUserId,
                            userEmail: userEmail,
                            userName: userName,
                            userEmails: [userEmail],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: const AssetImage('assets/demo.jpg'),
                        ),
                        title: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 7, 130, 230),
                          ),
                        ),
                        subtitle: Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 7, 130, 230),
                          ),
                        ),
                        tileColor: const Color.fromARGB(255, 220, 230, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Chat'),
                                  content: const Text(
                                      'Are you sure you want to delete this chat?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete == true) {
                              _deleteChat(chatDoc.id);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      const Game(),
      const Hand(),
      const Report(),
    ];

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before exiting the app
        final confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you really want to exit?'),
              actions: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    // Close the app completely when 'Yes' is pressed
                    SystemNavigator.pop(); // This will completely exit the app
                  },
                ),
              ],
            );
          },
        );
        return confirmExit ?? false;
      },
      child: Scaffold(
        appBar: _selectedIndex == 1
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: hexStringToColor("2986cc"),
                title: const Text('Chats'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartChatNL(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    tooltip: 'Start New Chat',
                  ),
                ],
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pan_tool),
              label: 'Signs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
