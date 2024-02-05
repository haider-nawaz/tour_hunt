import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Models/tour_model.dart';

import '../Controllers/tour_controller.dart';
import '../widgets/tour_widget.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tourController = Get.put(TourController());
    tourController.getBookings();
    return Scaffold(
      body: Column(
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
    );
  }
}
