import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserModel _user;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;
  late String userURL;
  Future<Map<String, dynamic>> _loadUserData() async {
    final User user = _auth.currentUser!;
    final UserModel? userData = await _firestoreService.getUserData(user.uid);

    _user = userData ??
        UserModel(
          id: '',
          name: 'Loading...',
          imgURL:
              'https://firebasestorage.googleapis.com/v0/b/campbelldecor-c2d1f.appspot.com/o/Users%2Fuser.png?alt=media&token=af8768f7-68e4-4961-892f-400eee8bae5d',
          email: '',
          address: '',
          phoneNo: '',
        );
    userURL = _user.imgURL;
    if (userData != null) {
      _user = userData;
      return {
        'name': _user.name,
        'email': _user.email,
        'phone': _user.phoneNo,
        'address': _user.address
      };
    } else {
      return {
        'name': "name",
        'email': "email",
        'phone': "phoneNo",
        'address': "address"
      };
    }
  }

  Future<void> _updateUserData() async {
    final String newName = _nameController.text.trim();
    final String newAddress = _addressController.text.trim();
    final String newPhoneNo = _phoneNoController.text.trim();
    final UserModel updatedUser = UserModel(
        id: _user.id,
        name: newName,
        imgURL: _user.imgURL,
        email: _user.email,
        address: newAddress,
        phoneNo: newPhoneNo);

    await _firestoreService.updateUserData(_user.id, updatedUser);

    await _loadUserData();

    setState(() {
      _isEditing = false;
    });

    _showFeedbackMessage('Changes saved successfully!');
  }

  void _showFeedbackMessage(String message) {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(8.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      content: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      )),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (_isEditing) {
              } else {
                _updateUserData();
                _showFeedbackMessage('Changes saved successfully!');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _isEditing
                  ? Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter your name',
                              prefixIcon: const Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _phoneNoController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter your name',
                              prefixIcon: const Icon(Icons.phone),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'Enter your name',
                              prefixIcon: const Icon(Icons.house),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    )
                  : FutureBuilder(
                      future: _loadUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          Fluttertoast.showToast(
                              msg: '${snapshot.data!['email']}',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.white,
                              textColor: Colors.black);
                          _nameController.text = snapshot.data!['name'];
                          _emailController.text = snapshot.data!['email'];
                          _phoneNoController.text = snapshot.data!['phone'];
                          _addressController.text = snapshot.data!['address'];

                          return SingleChildScrollView(
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                margin: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20.0),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.blueGrey,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: userURL != null
                                                    ? Image.network(
                                                        userURL,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/campbelldecor-c2d1f.appspot.com/o/Users%2Fuser.png?alt=media&token=af8768f7-68e4-4961-892f-400eee8bae5d',
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            Profile(userURL),
                                            Positioned(
                                              bottom: -10,
                                              right: -10,
                                              child: IconButton(
                                                icon: Icon(
                                                    Icons.camera_alt_outlined),
                                                onPressed: () {
                                                  userImagePicker(context)
                                                      .then((_) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileScreen()));
                                                    _showFeedbackMessage(
                                                        'Profile image updated successfully!');
                                                  }).catchError((error) {
                                                    print(
                                                        'Error updating profile image: $error');
                                                    _showFeedbackMessage(
                                                        'Failed to update profile image');
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15.0),

                                        // CircleAvatar(
                                        //   radius: 60.0,
                                        //   backgroundImage:
                                        //       AssetImage('assets/images/user.png'),
                                        // ),
                                        const Text(
                                          'Name:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          _user.name,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 10.0),
                                        const Text(
                                          'Email:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          _user.email,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 20.0),
                                        const Text(
                                          'Mobile No:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          _user.phoneNo,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 20.0),
                                        const Text(
                                          'Address:',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 0, 25, 0),
                                          child: Text(
                                            _user.address,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
              SizedBox(height: 20),
              _isEditing
                  ? Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Text color
                          elevation: 3, // Button elevation
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50.0), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                        ),
                        onPressed: _isEditing ? _updateUserData : null,
                        child: const Text('Save Changes'),
                      ),
                    )
                  : SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

class FirestoreService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromMap(
            documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateUserData(String userId, UserModel updatedUserData) async {
    try {
      await _userCollection.doc(userId).update(updatedUserData.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String imgURL;
  final String email;
  final String address;
  final String phoneNo;

  UserModel(
      {required this.id,
      required this.name,
      required this.imgURL,
      required this.email,
      required this.address,
      required this.phoneNo});

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String imgURL = data['imgURL'];
    final String email = data['email'];
    final String address = data['address'];
    final String phoneNo = data['phoneNo'];

    return UserModel(
        id: documentId,
        name: name,
        imgURL: imgURL,
        email: email,
        address: address,
        phoneNo: phoneNo);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imgURL': imgURL,
      'email': email,
      'address': address,
      'phoneNo': phoneNo,
    };
  }
}
