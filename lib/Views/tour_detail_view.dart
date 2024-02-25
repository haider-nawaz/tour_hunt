import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Controllers/tour_controller.dart';
import 'package:tour_hunt/Models/tour_model.dart';
import 'package:tour_hunt/constants.dart';

class TourDetailView extends StatelessWidget {
  final TourModel tourModel;

  const TourDetailView({Key? key, required this.tourModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(tourModel.location ?? "Tour Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Text("Destination",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue),
                                  textAlign: TextAlign.start),
                              const SizedBox(height: 0),
                              Text(
                                tourModel.location ?? "Location not specified",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Chip(
                            backgroundColor: Colors.green,
                            label: Text(
                                tourModel.price != null
                                    ? "PKR ${tourModel.price}"
                                    : "Price not specified",
                                style: const TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                          // Chip(
                          //   backgroundColor: Colors.orange,
                          //   label: Text(
                          //     tourModel.category.toString().capitalizeFirst ??
                          //         "Category not specified",
                          //     style: const TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 12,
                          //     ),
                          //   ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Departure",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                              Text(
                                "${convertTimetoDays(tourModel.departureTime.toString())} at ${tourModel.departureTimeNew.toString()} - ${tourModel.departureFrom ?? ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Arrival",
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                          Text(
                            "${convertTimetoDays(
                              tourModel.arrival.toString(),
                            )} at ${tourModel.arrivalTime.toString()}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Category",
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                          Text(
                            tourModel.category.toString().capitalizeFirst ??
                                "Category not specified",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Tour Duration",
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                          Text(
                            "${tourModel.duration} days" ??
                                "Duration not specified",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text("Description",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          tourModel.description ?? "Description not specified"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle booking action
                  Get.find<TourController>().bookTour(tourModel);
                },
                child: const Text("Book Tour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
