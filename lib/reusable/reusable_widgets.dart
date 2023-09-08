import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/chat/user_chat_screen.dart';
import 'package:campbelldecor/screens/payment_screens/paymentscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ratingModel.dart';
import '../screens/bookings_screens/cart_screen.dart';
import '../screens/events_screen/eventscreen.dart';
import '../screens/dash_board/homescreen.dart';
import '../screens/searchbar/searchbar_widget.dart';

Container logoWidget(String imageName) {
  return Container(
    width: 200, // Set the desired width
    height: 200,
    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
    child: Image.asset(imageName),
  );
}

/*----------------------- Image for Container List view ----------------------------------*/
ClipRRect IconImageWidget(String imageName, double height, double width) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: height,
      height: width,

      // color: Colors.transparent,
    ),
  );
}

TextField textField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container reusableButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular((30))),
          )),
      child: Text(
        isLogin ? 'LOG IN ' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Container reuseButton(BuildContext context, String text, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular((30))),
          )),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

/*----------------------- Data show as Container List ---------------------------------*/
Widget reuseContainerList(
    String imgName, double height, double width, String name, DateTime date) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: SingleChildScrollView(
      child: Container(
        height: 120,
        width: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // color: Color.fromARGB(50, 200, 20, 25),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconImageWidget(imgName, height, width),
            ),
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      DateFormat.yMd().format(date),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/*----------------------- Data show as Container List ---------------------------------*/
Widget reusePaymentContainer(
    String id, double price, BuildContext context, Function onTap) {
  double bondmoney = (price / 100) * 10;
  double total = price + bondmoney;

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 300, 20, 0),
        child: Container(
          height: 120,
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(50, 200, 20, 205),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        "Price Amount : Rs.${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        "Bond Money : Rs.${bondmoney.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        "Total Amount : Rs.${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                      price: total,
                                      id: id,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}

// Future<void> getRating() async {
//   FirestoreService firestoreService = FirestoreService();
//   List<String> fieldNames = ['packageName', 'rating_count', 'avg_rating'];
//   List<Package> packages =
//       await firestoreService.retriveFromCollection('packages', fieldNames);
//   print(packages.length);
//   print(packages[0].name);
// }

// Column res(Function onTap) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       ElevatedButton(
//           onPressed: () {
//             onTap;
//           },
//           style: ElevatedButton.styleFrom(
//               primary: Colors.red,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15))),
//           child: const Padding(
//             padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
//             child: Text(
//               "Pay",
//               style: TextStyle(color: Colors.white),
//             ),
//           )),
//     ],
//   );
// }

Widget bottom_Bar(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.white,
      primaryColor: Colors.purple, // Selected icon color
      textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall:
                const TextStyle(color: Colors.grey), // Unselected icon color
          ),
    ),
    child: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text_fill),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart_badge_plus),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
        ],
        // currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            BottomNavigation(context, HomeScreen());
          } else if (index == 1) {
            BottomNavigation(context, UserChatScreen());
          } else if (index == 2) {
            BottomNavigation(context, EventsScreen());
          } else if (index == 3) {
            BottomNavigation(context, AddToCartScreen());
          } else if (index == 4) {
            BottomNavigation(context, SearchScreen());
          } else {
            // _navigateToSearch(context);
          }
        }),
  );
}
