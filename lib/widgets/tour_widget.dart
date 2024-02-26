import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Models/feedback.dart';
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
  var feedback = "";

  var feedbacks = <FeedBack>[];
  double rating = 0.0;

  bool isFeedbackAlreadyGiven = true;

  bool isLiked = false;

  //check if the current user has already given feedback
  void checkIfFeedbackGiven() async {
    isFeedbackAlreadyGiven = await Get.find<TourController>()
        .checkIfFeedbackGiven(widget.tourModel.id!);
    setState(() {
      isFeedbackAlreadyGiven = isFeedbackAlreadyGiven;
    });

    print("Feedback already given: $isFeedbackAlreadyGiven");
  }

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
    //getTourRating();
    checkIfFeedbackGiven();
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
                    color: isLiked ? Colors.red : Colors.red,
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
                ? Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      isFeedbackAlreadyGiven
                          ? const SizedBox()
                          : giveFeedbackBtn(),
                    ],
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
            if (showFeedback) ...[
              Column(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(15),
                  //   width: double.infinity,
                  //   color: Colors.transparent.withOpacity(.2),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text(
                  //         "Rate this tour",
                  //         style: TextStyle(fontSize: 16, color: Colors.black87),
                  //       ),

                  //     ],
                  //   ),
                  // ),
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
                            title: Row(
                              children: [
                                Text(feedbacks[index].email ?? "N/A"),
                                const SizedBox(width: 10),
                                AnimatedRatingStars(
                                  initialRating: feedbacks[index].rating ?? 0.0,
                                  minRating: 0.0,
                                  maxRating: 5.0,
                                  filledColor: Colors.amber,
                                  emptyColor: Colors.white,
                                  filledIcon: Icons.star,
                                  halfFilledIcon: Icons.star_half,
                                  emptyIcon: Icons.star_border,
                                  onChanged: (double rating) {
                                    // Handle the rating change here
                                    // print('Rating: $rating');
                                    // updateRating(rating);
                                  },
                                  displayRatingValue: true,
                                  interactiveTooltips: true,
                                  customFilledIcon: Icons.star,
                                  customHalfFilledIcon: Icons.star_half,
                                  customEmptyIcon: Icons.star_border,
                                  starSize: 20.0,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  animationCurve: Curves.easeInOut,
                                  readOnly: true,
                                ),
                              ],
                            ),
                            subtitle: Text(feedbacks[index].message ?? "N/A"),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }

  ElevatedButton giveFeedbackBtn() {
    return ElevatedButton(
      onPressed: () {
        if (feedback.isEmpty) {
          //show a dialog with a textfield to enter feedback and a button to submit
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(40),
            title: "Feedback",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Rate this tour:"),
                const SizedBox(height: 10),
                AnimatedRatingStars(
                  initialRating: rating,
                  minRating: 0.0,
                  maxRating: 5.0,
                  filledColor: Colors.amber,
                  emptyColor: Colors.black,
                  filledIcon: Icons.star,
                  halfFilledIcon: Icons.star_half,
                  emptyIcon: Icons.star_border,
                  onChanged: (double rate) {
                    rating = rate;
                  },
                  displayRatingValue: true,
                  interactiveTooltips: true,
                  customFilledIcon: Icons.star,
                  customHalfFilledIcon: Icons.star_half,
                  customEmptyIcon: Icons.star_border,
                  starSize: 20.0,
                  animationDuration: const Duration(milliseconds: 300),
                  animationCurve: Curves.easeInOut,
                  readOnly: false,
                ),
                const SizedBox(height: 20),
                const Text("Give a feedback on this tour:"),
                const SizedBox(height: 10),
                TextField(
                  controller: Get.find<TourController>().feedBackController,
                  onChanged: (value) {
                    feedback = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter your feedback here",
                  ),
                ),
              ],
            ),
            textConfirm: "Submit",
            textCancel: "Cancel",
            onConfirm: () async {
              feedback = feedback.trim();

              final feed = FeedBack(
                email: FirebaseAuth.instance.currentUser!.email!,
                message: feedback,
                rating: rating,
                tourId: widget.tourModel.id!,
              );

              setState(() {
                //add the feedback to the feedbacks list
                feedbacks.add(
                  FeedBack(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    message: feedback,
                    rating: rating,
                    tourId: widget.tourModel.id!,
                  ),
                );

                showFeedback = true;
              });
              await Get.find<TourController>().saveFeedbackOnTour(feed);
              Get.back();
              setState(() {
                isFeedbackAlreadyGiven = true;
              });
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isFeedbackAlreadyGiven ? Colors.grey : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        "Give Feedback",
        style: TextStyle(
          fontSize: 14,
          color: isFeedbackAlreadyGiven ? Colors.black : Colors.white,
        ),
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
