import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/add_tours_view.dart';
import 'package:tour_hunt/Views/tours_view.dart';
import 'package:tour_hunt/auth/signup_view.dart';

import '../../Controllers/tour_controller.dart';
import '../../auth/signin_view.dart';
import '../../nav_controller.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  late final TourController tourController;
  @override
  void initState() {
    tourController = Get.put(TourController());
    tourController.getToursByCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.blue),
          title: Text(
            navController.currentIndex.value == 0
                ? "Your Tour Plans"
                : "Create Tour Plan",
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
                color: Colors.purple,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.corporate_fare,
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
                title: const Text('Your Tour Plans'),
                onTap: () {
                  Get.back();
                  navController.changeIndex(0);
                },
              ),
              ListTile(
                selected: navController.currentIndex.value == 1,
                leading: const Icon(Icons.add),
                title: const Text('Create New Tour Plan'),
                onTap: () {
                  Get.back();
                  navController.changeIndex(1);
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
        body: Obx(() => _switchView(tourController)),
      ),
    );
  }
}

Widget _switchView(TourController tourController) {
  final navController = Get.find<NavController>();
  switch (navController.currentIndex.value) {
    case 0:
      return ToursView(
        tours: tourController.tours,
        isCompany: true,
        //delTour: () => tourController.deleteTour(tourId),
      );
    case 1:
      return const AddTourView(
        edit: false,
      );
    // case 2:
    //   return const NewPerscriptions();
    default:
      return const Text("");
  }
}
