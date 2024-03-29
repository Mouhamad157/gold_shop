import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/location_service/geocoding_service.dart';
import '../../../../core/texts/words.dart';
import '../../model/user/user_signup_model.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../main/user/view/main_screen_view.dart';
import '../../../../core/location_service/marker_entity.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import '../../../../core/location_service/location_model.dart';
import '../../../../core/storage_handler/storage_handler.dart';
import '../../../../core/location_service/location_entity.dart';

class UserSignupController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GeocodingCoordinatesManager geocodingCoordinatesManager =
      Get.put(GeocodingCoordinatesManager());
  double latitude = 1;
  double longitude = 1;
  String country = 'syria';
  String state = 'state';
  String city = 'city';
  String neighborhood = 'neighborhood';
  String street = 'street';
  String area = 'area';
  LocationEntity location =
      const LocationGoogleModel(lat: 24.470901, lon: 39.612236);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CameraPosition position =
      const CameraPosition(target: LatLng(24.470901, 39.612236), zoom: 10);

  UserSignupModel? model;
  Set<Marker> markers = {};

  void signup() async {
    await DioHelper.register(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            phoneNumber: phoneController.text,
            password: passwordController.text,
            latitude: location.lat,
            longitude: location.lon,
            country: country,
            state: state,
            city: city,
            neighborhood: neighborhood,
            street: street)
        .then((value) async {
      if (value['errors'] != null) {
        Get.log('error');
        Get.snackbar(AppWord.warning, value['message']);
        return value;
      } else {
        model = UserSignupModel.fromJson(json: value['data']);
        await StorageHandler().setToken(model!.token);
        await StorageHandler().setUserId(model!.userId.toString());
        await StorageHandler().setRole('user');
        Get.offAll(const MainScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 700));
        return value;
      }
    });
  }

  void onGoogleMapTapped(LatLng position) {
    location = LocationGoogleModel.fromLatLon(position);
    markers = {
      MarkerEntity.fromMarkerInfo(
        info: MarkerInfo(
          markerId: 'markerId',
          title: 'You Location',
          subTitle: 'You are here',
          location: location,
        ),
      ),
    };
    geocodingCoordinatesManager
        .convertCoordinates(latitude: location.lat, longitude: location.lon)
        .then((value) {
      country = value.city;
      city = value.country;
      state = value.area;
      neighborhood = value.neighborhood;
      street = value.route;
      area = value.city;
      update();
    });
    location.toString();
    update();
  }
}
