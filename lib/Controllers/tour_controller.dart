import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Controllers/auth_controller.dart';
import 'package:tour_hunt/Models/tour_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tour_hunt/constants.dart';

class TourController extends GetxController {
  final tours = <TourModel>[].obs;
  final bookedTours = <TourModel>[].obs;
  final likedTours = <TourModel>[].obs;
  final bookingIds = <String>[];
  final likedIds = <String>[];
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final arrivalController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final departureController = TextEditingController();
  final departureFromController = TextEditingController();
  final companyController = TextEditingController();
  final priceController = TextEditingController();
  final feedBackController = TextEditingController();
  final transportatinoController = TextEditingController();
  final hotelController = TextEditingController();
  final arrivalTimeController = TextEditingController();
  final departureTimeController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  //get all tours from datbase ref
  //add them to the tours list

  final categories = ["Adventure", "Cultural", "Nature", "Historical"];
  final selectedCategory = "Adventure".obs;

  void getTours() async {
    print("called get tours");
    isLoading.value = true;

    tours.clear();
    final snapshot = await ref.child('tours').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      // print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        print("staus is ${value['status']}");
        if (Get.find<AuthController>().isTouristLoggedIn.value) {
          if (value['status'] == 'unarchive') {
            tours.add(
              TourModel(
                arrangedByEmail: value['arrangeby'],
                category: value['category'],
                companyName: value['companyname'],
                departureTime: value['departure'],
                arrival: value['arrival'],
                description: value['description'],
                departureFrom: value['departureFrom'],
                duration: value['duration'],
                location: value['location'],
                price: value['price'],
                status: value['status'],
                departureTimeNew: value['departureTime'],
                arrivalTime: value['arrivalTime'],
                hotel: value['hotel'],
                transportation: value['transportation'],
                id: key,
              ),
            );
          }
        } else {
          if (value['arrangeby'] == user!.email) {
            tours.add(
              TourModel(
                arrangedByEmail: value['arrangeby'],
                category: value['category'],
                companyName: value['companyname'],
                departureTime: value['departure'],
                arrival: value['arrival'],
                description: value['description'],
                departureFrom: value['departureFrom'],
                duration: value['duration'],
                location: value['location'],
                price: value['price'],
                status: value['status'],
                departureTimeNew: value['departureTime'],
                arrivalTime: value['arrivalTime'],
                hotel: value['hotel'],
                transportation: value['transportation'],
                id: key,
              ),
            );
          }
        }
      });
      getBookings();
      getLikedTours();

      isLoading.value = false;
    } else {
      print('No data available.');
    }
    isLoading.value = false;
  }

  Future<void> getCompanyName() async {
    //loop through companies and get the company name of the current user
    final snapshot = await ref.child('companies').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      // print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        if (value['email'] == user!.email) {
          companyController.text = value['name'];
          print("company name is ${value['name']}");
        }
      });
    } else {
      print('No data available.');
    }
  }

  void saveFeedbackOnTour(String tourId) async {
    final feedbackRef = ref.child("feedbacks").push();

    final data = {
      "tour_id": tourId,
      "description": feedBackController.text,
      "user_email": user!.email,
    };

    await feedbackRef
        .set(data)
        .then((value) => {
              Get.back(),
              customSnack("Feedback Submitted Successfully", false, "Message"),
            })
        .catchError((onError) => {
              print(onError.toString()),
              customSnack(onError.toString(), true, "Error"),
            });
  }

  //init state
  @override
  void onInit() {
    getCompanyName();
    getBookings();
    arrivalController.text = "Select Arrival";
    departureController.text = "Select Departure";
    super.onInit();
  }

  void clearfields() {
    locationController.clear();
    descriptionController.clear();
    categoryController.clear();
    departureFromController.clear();
    //companyController.clear();
    priceController.clear();
    transportatinoController.clear();
    hotelController.clear();
    arrivalTimeController.clear();
    departureTimeController.clear();
    arrivalController.text = "Select Arrival";
    departureController.text = "Select Departure";
  }

  void addTour(String duration, String departure, String arrival) async {
    if (true) {
      isLoading.value = true;
      final tourRef = ref.child('tours').push();
      final tour = TourModel(
        arrangedByEmail: user!.email!,
        category: selectedCategory.value,
        companyName: companyController.text,
        departureTime: departure,
        description: descriptionController.text,
        departureFrom: departureFromController.text,
        arrival: arrival,
        duration: duration,
        location: locationController.text,
        price: priceController.text,
        status: "new",
        departureTimeNew: departureTimeController.text,
        arrivalTime: arrivalTimeController.text,
        hotel: hotelController.text,
        transportation: transportatinoController.text,
      );
      await tourRef.set(tour.toJson()).then((value) {
        tours.add(tour);
        isLoading.value = false;
        customSnack("Tour Added Successfully", false, "Success");
        clearfields();
        Get.back();
      }).catchError((error) {
        isLoading.value = false;
        customSnack(error.toString(), true, "Error");
      });
    }
  }

  void saveBooking(TourModel tourModel) async {
    final user = FirebaseAuth.instance.currentUser;
    final bookingRef = ref.child("booking").push();

    final now = DateTime.now();
    final dateOnly = "${now.year}-${now.month}-${now.day}";
    print("tour id is ${tourModel.id}");
    final data = {
      "date": dateOnly,
      "user_email": user!.email,
      "tour_id": tourModel.id,
    };

    await bookingRef
        .set(data)
        .then((value) => {
              Get.back(),
              customSnack("Booking Successful", false, "Message"),
            })
        .catchError((onError) => {
              print(onError.toString()),
              customSnack(onError.toString(), true, "Error"),
            });
  }

  void bookTour(TourModel tourModel) async {
    //make payment

    await makePayment(tourModel.price!, tourModel).then((value) async {});
    //create a new entry in the bookings
  }

  void getBookings() async {
    isLoading.value = true;
    //get the current bookings of current user
    //add them to the bookings list

    final snapshot = await ref.child('booking').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        if (value['user_email'] == user!.email) {
          bookingIds.add(value['tour_id']);
        }
      });

      print(bookingIds);
      isLoading.value = false;
    } else {
      print('No data available.');
    }

    print(bookingIds);
    populateBookedTours();
  }

  void getLikedTours() async {
    isLoading.value = true;
    likedIds.clear();
    //get the current bookings of current user
    //add them to the bookings list

    final snapshot = await ref.child('favourites').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        if (value['user_email'] == user!.email) {
          likedIds.add(value['tour_id']);
        }
      });

      print(likedIds);

      isLoading.value = false;
    } else {
      print('No data available.');
    }

    print(bookingIds);
    populateLikedTours();
  }

  void populateBookedTours() {
    print(tours.length);
    bookedTours.clear();
    for (var tour in tours) {
      print("tour id is ${tour.id}");
      if (bookingIds.contains(tour.id)) {
        bookedTours.add(tour);
      }
    }
    print("booked tours are $bookedTours");
  }

  void populateLikedTours() {
    print(tours.length);
    likedTours.clear();
    for (var tour in tours) {
      print("tour id is ${tour.id}");
      if (likedIds.contains(tour.id)) {
        likedTours.add(tour);
      }
    }
    print("liked tours are $likedTours");
  }

  prepareEdit(int index) {
    locationController.text = tours[index].location!;
    arrivalController.text = tours[index].arrival!;
    descriptionController.text = tours[index].description!;
    categoryController.text = tours[index].category!;
    departureController.text = tours[index].departureTime!;
    departureFromController.text = tours[index].departureFrom!;
    companyController.text = tours[index].companyName!;
    priceController.text = tours[index].price!;
    transportatinoController.text = tours[index].transportation!;
    hotelController.text = tours[index].hotel!;
    arrivalTimeController.text = tours[index].arrivalTime!;
    departureTimeController.text = tours[index].departureTimeNew!;
  }

  editTour(
      String duration, String departure, String arrival, String tourId) async {
    //update the tour in the database
    isLoading.value = true;

    final tourRef = ref.child('tours/$tourId');
    final tour = TourModel(
      arrangedByEmail: user!.email!,
      category: categoryController.text,
      companyName: companyController.text,
      departureTime: departure,
      description: descriptionController.text,
      departureFrom: departureFromController.text,
      arrival: arrival,
      duration: duration,
      location: locationController.text,
      price: priceController.text,
      status: "new",
      departureTimeNew: departureTimeController.text,
      arrivalTime: arrivalTimeController.text,
      hotel: hotelController.text,
      transportation: transportatinoController.text,
    );
    await tourRef.set(tour.toJson()).then((value) {
      customSnack("Tour Updated Successfully", false, "Success");
      clearfields();
      Get.back();
      isLoading.value = false;
    }).catchError((error) {
      customSnack(error.toString(), true, "Error");
    });
    isLoading.value = false;
  }

  deleteTour(String tourId, int index) {
    print("tour id is $tourId");
    print("index is $index");
    //delete the tour from the database

    ref.child("tours/$tourId").remove().then((value) {
      tours.removeAt(index);
      customSnack("Tour Deleted Successfully", false, "Success");
    }).catchError((error) {
      customSnack(error.toString(), true, "Error");
    });
  }

  void getToursByCurrentUser() async {
    print("called get tours by ${user!.email}");
    isLoading.value = true;

    tours.clear();
    //get tours which are arranged by the current user
    final snapshot = await ref.child('tours').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      // print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        print("value['arrangeBy'] is ${value['arrangedBy']}");
        if (value['arrangeby'] == user!.email) {
          tours.add(
            TourModel(
              arrangedByEmail: value['arrangeby'],
              category: value['category'],
              companyName: value['companyname'],
              departureTime: value['departure'],
              arrival: value['arrival'],
              description: value['description'],
              departureFrom: value['departureFrom'],
              duration: value['duration'],
              location: value['location'],
              price: value['price'],
              status: value['status'],
              id: key,
              departureTimeNew: value['departureTime'],
              arrivalTime: value['arrivalTime'],
              hotel: value['hotel'],
              transportation: value['transportation'],
            ),
          );
        }
      });

      print("len of tours is ${tours.length}");
      getBookings();

      isLoading.value = false;
    } else {
      print('No data available.');
    }
    isLoading.value = false;
  }

  Future<void> makePayment(String amount, TourModel tourModel) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent(amount, 'PKR');

      //STEP 2: Initialize Payment Sheet
      // await Stripe.instance
      //     .initPaymentSheet(
      //         paymentSheetParameters: SetupPaymentSheetParameters(
      //             paymentIntentClientSecret: paymentIntent![
      //                 'client_secret'], //Gotten from payment intent
      //             style: ThemeMode.light,
      //             merchantDisplayName: 'Ikay'))
      //     .then((value) {
      //   print('Payment Sheet Initialized');
      // });

      //STEP 3: Display Payment sheet
      displayPaymentSheet(tourModel);
    } catch (err) {
      throw Exception("Error: $err");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount).toString(),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      print("Error is: $err");
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    //Convert amount to cents
    return (double.parse(amount) * 100).toInt();
  }

  displayPaymentSheet(TourModel tourModel) async {
    // try {
    //   await Stripe.instance.presentPaymentSheet().then((value) {
    //     print("Payment Sheet Completed");
    //     //Clear paymentIntent variable after successful payment
    //     saveBooking(tourModel);

    //     paymentIntent = null;
    //   }).onError((error, stackTrace) {
    //     throw Exception(error);
    //   });
    // } on StripeException catch (e) {
    //   print('Error is:---> $e');
    // } catch (e) {
    //   print('$e');
    // }
  }

  Future<List<Map<String, String>>> checkForFeedback(String tourId) async {
    final feedbacks = <Map<String, String>>[];
    final snapshot = await ref.child('feedbacks').get();

    if (snapshot.exists) {
      final data = snapshot.value;
      // print(data);
      (data as Map<dynamic, dynamic>).forEach((key, value) {
        if (value['tour_id'] == tourId) {
          feedbacks.add(
            {
              "description": value['description'],
              "user_email": value['user_email'],
            },
          );
        }
      });
    } else {
      print('No data available in feedbacks.');
    }

    print(feedbacks);
    return feedbacks;
  }

  void updateLike(String s, bool isLiked) async {
    if (isLiked) {
      likedIds.add(s);
      print("liked");
      await ref.child('favourites').push().set({
        "tour_id": s,
        "user_email": user!.email,
      }).then((value) {
        // if (isLiked) {
        //   likedIds.add(s);
        // } else {
        //   likedIds.remove(s);
        // }
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      likedIds.remove(s);
      print("unliked");
      await ref.child('favourites').get().then((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.value;
          (data as Map<dynamic, dynamic>).forEach((key, value) {
            if (value['tour_id'] == s && value['user_email'] == user!.email) {
              ref.child('favourites/$key').remove().then((value) {
                // if (isLiked) {
                //   likedIds.add(s);
                // } else {
                //   likedIds.remove(s);
                // }
              }).catchError((onError) {
                print(onError.toString());
              });
            }
          });
        }
      });
    }
  }

  checkIfTourIsLiked(String s) {
    print("Tour likes: ${likedIds.contains(s)}");
    return likedIds.contains(s);
  }

  Future<void> updateRating(String id, double rating) async {
    //update the rating of the tour with given id, if not present then add a new rating
    final snapshot = await ref.child('ratings_feedbacks').get();
    bool isPresent = false;
    String key = "";
    if (snapshot.exists) {
      final data = snapshot.value;
      (data as Map<dynamic, dynamic>).forEach((k, value) {
        if (value['tour_id'] == id && value['user_email'] == user!.email) {
          isPresent = true;
          key = k;
        }
      });
    } else {
      print('No data available.');
    }

    if (isPresent) {
      await ref.child('ratings_feedbacks/$key').update({
        "rating": rating,
      }).then((value) {
        print("Rating Updated Successfully");
        Get.snackbar(
          "Success",
          "Rating Updated Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      await ref.child('ratings_feedbacks').push().set({
        "tour_id": id,
        "rating": rating,
        "user_email": user!.email,
      }).then((value) {
        Get.snackbar(
          "Success",
          "Rating Updated Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print("Rating Added Successfully");
      }).catchError((onError) {
        print(onError.toString());
      });
    }
  }

  Future<double> getTourRating(String tourId) async {
    final snapshot = await ref.child('ratings_feedbacks').get();
    double initalRating = 0;

    try {
      if (snapshot.exists) {
        final data = snapshot.value;
        // print(data);
        (data as Map<dynamic, dynamic>).forEach((key, value) {
          if (value['tour_id'] == tourId) {
            initalRating = double.parse(value['rating'].toString());
          }
        });
      } else {
        print('No data available.');
      }
    } catch (e) {
      print(e);
    }

    return initalRating;
  }
}
