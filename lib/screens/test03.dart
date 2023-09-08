// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   PickedFile? _image;
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.getImage(source: source);
//
//     setState(() {
//       _image = pickedImage;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final photoURL = user?.photoURL;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.blue,
//                       width: 2.0,
//                     ),
//                   ),
//                   child: ClipOval(
//                     child: photoURL != null
//                         ? Image.network(
//                             photoURL,
//                             width: 150,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           )
//                         : Image.asset(
//                             'assets/default_avatar.png',
//                             width: 150,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           ),
//                   ),
//                 ),
//                 // Camera icon overlayed on the avatar
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: IconButton(
//                     icon: Icon(Icons.camera_alt),
//                     onPressed: () {
//                       _pickImage(ImageSource.camera);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               child: Text('Pick Image'),
//             ),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.camera),
//               child: Text('Take Photo'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Upload the selected image to Firebase Storage and update the user's profile picture in Firebase Authentication.
//                 // You'll need to implement this part.
//               },
//               child: Text('Save Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
