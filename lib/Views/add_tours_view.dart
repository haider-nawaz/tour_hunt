import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/constants.dart';

import '../Controllers/tour_controller.dart';
import '../widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class AddTourView extends StatefulWidget {
  final bool edit;
  final int? index;
  final String? tourId;
  const AddTourView({super.key, required this.edit, this.index, this.tourId});

  @override
  State<AddTourView> createState() => _AddTourViewState();
}

class _AddTourViewState extends State<AddTourView> {
  late DateTime arrival;
  late DateTime departure;

  @override
  void initState() {
    departure = DateTime.now();
    arrival = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tourController = Get.find<TourController>();
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Form(
              key: tourController.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.edit ? "Edit Tour Details" : "Add a Tour",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.edit
                              ? "Now you can edit the details of your plan."
                              : "Create a tour and add it to the list.",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: tourController.locationController,
                          icon: Icons.location_pin,
                          title: "Location",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(false,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            controller: tourController.departureFromController,
                            icon: Icons.pin_drop,
                            title: "Departure From"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Departure",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                        initialDatePickerMode:
                                            DatePickerMode.year,
                                      ).then((value) {
                                        departure = DateUtils.dateOnly(value!);
                                        print("Departure is $departure");

                                        setState(() {
                                          tourController
                                                  .departureController.text =
                                              DateFormat('yMMMEd')
                                                  .format(value)
                                                  .toString();
                                        });

                                        //show time picker for departure
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          setState(() {
                                            tourController
                                                .departureTimeController
                                                .text = value!.format(context);
                                          });
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                " ${tourController.departureController.text}"),
                                            tourController
                                                    .departureTimeController
                                                    .text
                                                    .isNotEmpty
                                                ? Text(
                                                    tourController
                                                        .departureTimeController
                                                        .text,
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Arrival",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                        initialDatePickerMode:
                                            DatePickerMode.year,
                                      ).then((value) {
                                        arrival = DateUtils.dateOnly(value!);
                                        print("Arrival is $arrival");

                                        //arrival cant be early or equal to departure

                                        final difference = arrival
                                            .difference(departure)
                                            .inDays;

                                        if (difference < 0) {
                                          customSnack(
                                            "Arrival cant be early or equal to departure date",
                                            true,
                                            "Invalid Arrival Date",
                                          );
                                          return;
                                        }

                                        setState(() {
                                          tourController
                                                  .arrivalController.text =
                                              DateFormat('yMMMEd')
                                                  .format(value)
                                                  .toString();
                                        });

                                        //show time picker for arrival
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          setState(() {
                                            tourController.arrivalTimeController
                                                .text = value!.format(context);
                                          });
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tourController
                                                  .arrivalController.text
                                                  .toString(),
                                            ),
                                            tourController.arrivalTimeController
                                                    .text.isNotEmpty
                                                ? Text(
                                                    tourController
                                                        .arrivalTimeController
                                                        .text,
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //if (departure != null && arrival != null)
                        // Text(
                        //     "Tour Duration: ${convertTimetoDaysMonthsYears(departure, arrival)}"),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // const Divider(),
                        const SizedBox(
                          height: 0,
                        ),
                        CustomTextField(
                          false,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: tourController.companyController,
                          icon: Icons.location_city,
                          title: "Company Name",
                          isEnabled: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          true,
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          controller: tourController.descriptionController,
                          icon: Icons.abc,
                          title: "Description",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //a drop down menu for the tour type
                        CustomTextField(
                          true,
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          controller: tourController.hotelController,
                          icon: Icons.abc,
                          title: "Hotel Accomodation",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          true,
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          controller: tourController.transportatinoController,
                          icon: Icons.abc,
                          title: "Transportation",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Tour Type",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Obx(
                              () => DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: tourController.selectedCategory.value,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  tourController.selectedCategory(newValue!);
                                },
                                items: tourController.categories
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          false,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          controller: tourController.priceController,
                          icon: Icons.monetization_on,
                          title: "Price",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => tourController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: () {
                                var departure2 =
                                    "${departure.year}-${departure.month.toString().length == 1 ? '0${departure.month}' : departure.month}-${departure.day.toString().length == 1 ? '0${departure.day}' : departure.day}";
                                var arrival2 =
                                    "${arrival.year}-${arrival.month.toString().length == 1 ? '0${arrival.month}' : arrival.month}-${arrival.day.toString().length == 1 ? '0${arrival.day}' : arrival.day}";

                                print("arrival is $arrival2");
                                print("depareture is $departure2");
                                if (widget.edit) {
                                  tourController.editTour(
                                    convertTimetoDaysMonthsYears(
                                        departure, arrival),
                                    departure2,
                                    arrival2,
                                    widget.tourId!,
                                  );
                                  return;
                                }

                                tourController.addTour(
                                    convertTimetoDaysMonthsYears(
                                        departure, arrival),
                                    departure2,
                                    arrival2);
                              },
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 60,
                                child: Center(
                                  child: Text(
                                    widget.edit ? "Save" : "Add",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
