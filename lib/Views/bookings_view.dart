import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Models/tour_model.dart';

import '../Controllers/tour_controller.dart';
import '../widgets/tour_widget.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({
    super.key,
  });

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  late final TourController tourController;
  @override
  void initState() {
    print("BookingsView init state called");
    tourController = Get.put(TourController());
    tourController.getBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => tourController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  //const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tourController.bookedTours.length,
                      itemBuilder: (context, index) {
                        final tour = tourController.bookedTours[index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TourWidget(
                            tourModel: tour,
                            index: index,
                            isBooked: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
