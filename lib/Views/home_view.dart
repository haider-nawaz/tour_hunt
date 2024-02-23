import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/add_tours_view.dart';
import 'package:tour_hunt/Views/liked_tours_view.dart';
import 'package:tour_hunt/Views/tours_view.dart';
import 'package:tour_hunt/auth/signup_view.dart';

import '../../auth/signin_view.dart';
import '../Controllers/tour_controller.dart';
import '../nav_controller.dart';
import 'bookings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TourController tourController;

  @override
  void initState() {
    tourController = Get.put(TourController());
    tourController.getTours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavController());

    return Obx(
      () => Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Get.to(() => const AddTourView());
          //   },
          //   child: const Icon(Icons.add),
          // ),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.blue),
            title: Text(
              navController.currentIndex.value == 0
                  ? "Browse Tours"
                  : navController.currentIndex.value == 1
                      ? "Your Bookings"
                      : "Liked Tours",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
          ),
          drawer: Drawer(
            surfaceTintColor: Colors.transparent,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                // SizedBox(
                //   height: 70,
                //   child: Image.asset("assets/pharma-logo.png"),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  selected: navController.currentIndex.value == 0,
                  leading: const Icon(Icons.tour),
                  title: const Text('Browse Tours'),
                  onTap: () {
                    Get.back();
                    navController.changeIndex(0);
                  },
                ),
                ListTile(
                  selected: navController.currentIndex.value == 1,
                  leading: const Icon(Icons.stars),
                  title: const Text('Your Bookings'),
                  onTap: () {
                    Get.back();
                    navController.changeIndex(1);
                  },
                ),
                ListTile(
                  selected: navController.currentIndex.value == 2,
                  leading: const Icon(CupertinoIcons.heart_fill),
                  title: const Text('Liked Tours'),
                  onTap: () {
                    Get.back();
                    navController.changeIndex(2);
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    //show a dialog to confirm logout
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No")),
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      //remove the auth controller from memory
                                      Get.deleteAll();
                                      Get.offAll(() => const SignupView());
                                    });
                                  },
                                  child: const Text("Yes"))
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
          body: Obx(() => _switchView(tourController))),
    );
  }
}

Widget _switchView(TourController tourController) {
  final navController = Get.find<NavController>();
  switch (navController.currentIndex.value) {
    case 0:
      return ToursView(
        tours: tourController.tours,
        isCompany: false,
      );
    case 1:
      return const BookingsView();
    case 2:
      return const LikedToursView();
    default:
      return const Text("");
  }
}
