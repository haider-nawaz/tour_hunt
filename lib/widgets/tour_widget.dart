import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/add_tours_view.dart';
import 'package:tour_hunt/Views/tour_detail_view.dart';
import 'package:tour_hunt/constants.dart';

import '../Controllers/tour_controller.dart';
import '../Models/tour_model.dart';

class TourWidget extends StatefulWidget {
  final TourModel tourModel;
  final bool? isCompany;
  final int index;
  final bool? isBooked;

  const TourWidget({
    Key? key,
    required this.tourModel,
    this.isCompany = false,
    required this.index,
    required this.isBooked,
  }) : super(key: key);

  @override
  State<TourWidget> createState() => _TourWidgetState();
}

class _TourWidgetState extends State<TourWidget> {
  final isFeedbackGiven = false;
  var feedbacks = <Map<String, String>>[];
  var feedback = "";

  bool isLiked = false;

  void checkIfTourIsLiked() async {
    isLiked = await Get.find<TourController>()
        .checkIfTourIsLiked(widget.tourModel.id!);
    setState(() {});
  }

  var showFeedback = false;

  void checkForAnyFeedback() async {
    feedbacks =
        await Get.find<TourController>().checkForFeedback(widget.tourModel.id!);

    if (feedbacks.isNotEmpty) {
      setState(() {
        showFeedback = true;
      });
    }
  }

  void updateLike() {
    Get.find<TourController>().updateLike(widget.tourModel.id!, isLiked);
  }

  void checkIfFeedbackInFeedbacks() {}

  @override
  void initState() {
    checkIfTourIsLiked();
    checkForAnyFeedback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Add a slight box shadow
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(15),

            //leading: Icon(Icons.location_on), // Icon for location
            title: Row(
              children: [
                const Icon(Icons.location_on), // Icon for location
                Text(
                  widget.tourModel.location ?? "N/A",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    updateLike();
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.corporate_fare,
                        color: Colors.black54,
                      ), // Icon for departure from
                      const SizedBox(width: 8),
                      Text(
                        widget.tourModel.companyName ?? "N/A",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: Colors.black54,
                    ),
                  ),
                  widget.isBooked!
                      ? Text(
                          "Rs: ${widget.tourModel.price}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(convertTimetoDays(
                                widget.tourModel.departureTime.toString())),
                          ],
                        ),
                ],
              ),
            ),
            trailing: widget.isBooked!
                ? ElevatedButton(
                    onPressed: () {
                      if (feedback.isEmpty) {
                        //show a dialog with a textfield to enter feedback and a button to submit
                        Get.defaultDialog(
                          contentPadding: const EdgeInsets.all(40),
                          title: "Feedback",
                          content: TextField(
                            controller:
                                Get.find<TourController>().feedBackController,
                            onChanged: (value) {
                              feedback = value;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your feedback here",
                            ),
                          ),
                          textConfirm: "Submit",
                          textCancel: "Cancel",
                          onConfirm: () {
                            feedback = feedback.trim();

                            setState(() {
                              //add the feedback to the feedbacks list
                              feedbacks.add({
                                "user_email":
                                    FirebaseAuth.instance.currentUser!.email!,
                                "description": feedback,
                              });
                              showFeedback = true;
                            });
                            Get.find<TourController>()
                                .saveFeedbackOnTour(widget.tourModel.id!);
                            Get.back();
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          feedback.isNotEmpty ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Give Feedback",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  )
                : Column(
                    // mainAxisSize: MainAxisSize.min,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 5),
                          Text("${widget.tourModel.duration} days"),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "PKR: ${widget.tourModel.price}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          //Text(tourModel.duration ?? "N/A"),
                        ],
                      ),
                    ],
                  ), // Icon for more details
            onTap: () {
              Get.to(
                () => TourDetailView(tourModel: widget.tourModel),
                //transition: Transition.rightToLeft,
                curve: Curves.easeIn,
              );
            },
          ),
          if (widget.isCompany == true) ...[
            Container(
              height: 80,
              color: Colors.transparent.withOpacity(.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.tourModel.status == 'archive')
                    Chip(
                      avatar: const Icon(Icons.info, color: Colors.orange),
                      label: Text(
                        widget.tourModel.status.toString(),
                        style: TextStyle(
                          color: widget.tourModel.status == "archive"
                              ? Colors.orange
                              : widget.tourModel.status == "unarchive"
                                  ? Colors.green
                                  : Colors.purple,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: widget.tourModel.status == "archive"
                          ? Colors.orange.withOpacity(.1)
                          : widget.tourModel.status == "unarchive"
                              ? Colors.green.withOpacity(.1)
                              : Colors.purple.withOpacity(.1),
                      side: BorderSide.none,
                      //give border radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      Get.find<TourController>().prepareEdit(widget.index);
                      Get.to(
                        AddTourView(
                          edit: true,
                          index: widget.index,
                          tourId: widget.tourModel.id,
                        ),
                        curve: Curves.easeIn,
                      )!
                          .then((value) => {
                                Get.find<TourController>().clearfields(),
                                Get.find<TourController>().getTours(),
                              });
                    },
                    child: Chip(
                      label: const Text(
                        "Edit Tour",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.blue.withOpacity(.1),
                      side: BorderSide.none,
                      avatar: const Icon(Icons.edit, color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //show a confirmation dialog
                      Get.defaultDialog(
                        contentPadding: const EdgeInsets.all(20),
                        // titlePadding: EdgeInsets.all(5),
                        title: "Delete Tour",
                        middleText:
                            "Are you sure you want to delete this tour plan?",
                        textConfirm: "Yes",
                        textCancel: "No",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.find<TourController>()
                              .deleteTour(widget.tourModel.id!, widget.index);
                          Get.back();
                        },
                      );
                    },
                    child: Chip(
                      label: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.red.withOpacity(.1),
                      side: BorderSide.none,
                      avatar: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.isBooked == true)
            if (showFeedback)
              Container(
                //height: 80,
                width: double.infinity,
                color: Colors.transparent.withOpacity(.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      // a listview of feedbacks
                      ListView.builder(
                    shrinkWrap: true,
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        // leading: const Icon(Icons.feedback),
                        title: Text(feedbacks[index]['user_email'] ?? "N/A"),
                        subtitle:
                            Text(feedbacks[index]['description'] ?? "N/A"),
                      );
                    },
                  ),
                ),
              )
        ],
      ),
    );
  }

  Column subWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time), // Icon for departure time
            const SizedBox(width: 8),
            Text(widget.tourModel.departureTime ?? "N/A"),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.category), // Icon for category
            const SizedBox(width: 8),
            Text(widget.tourModel.category ?? "N/A"),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.monetization_on), // Icon for price
            const SizedBox(width: 8),
            Text(widget.tourModel.price != null
                ? "\$${widget.tourModel.price}"
                : "N/A"),
          ],
        ),
      ],
    );
  }
}
