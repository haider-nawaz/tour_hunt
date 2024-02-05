import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_hunt/Controllers/auth_controller.dart';
import 'package:tour_hunt/Models/tour_model.dart';
import 'package:tour_hunt/widgets/tour_widget.dart';

import '../Controllers/tour_controller.dart';

class ToursView extends StatelessWidget {
  final List<TourModel> tours;
  final bool isCompany;
  final VoidCallback? delTour;

  const ToursView(
      {super.key, required this.tours, required this.isCompany, this.delTour});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      body: Column(
        children: [
          //const SizedBox(height: 15),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: tours.length,
                itemBuilder: (context, index) {
                  final tour = tours[index];
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TourWidget(
                      tourModel: tour,
                      isCompany: isCompany,
                      index: index,
                      isBooked: false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
