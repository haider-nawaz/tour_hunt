import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Controllers/tour_controller.dart';
import 'package:tour_hunt/Models/tour_model.dart';
import 'package:tour_hunt/widgets/tour_widget.dart';

class LikedToursView extends StatefulWidget {
  const LikedToursView({super.key});

  @override
  State<LikedToursView> createState() => _LikedToursViewState();
}

class _LikedToursViewState extends State<LikedToursView> {
  late final TourController tourController;

  @override
  void initState() {
    tourController = Get.put(TourController());
    tourController.getLikedTours();
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
                      itemCount: tourController.likedTours.length,
                      itemBuilder: (context, index) {
                        final tour = tourController.likedTours[index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TourWidget(
                            tourModel: tour,
                            index: index,
                            isBooked: false,
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
