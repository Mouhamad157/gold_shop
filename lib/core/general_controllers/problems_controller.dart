import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gold_shop/core/network/dio_helper.dart';
import 'package:gold_shop/core/texts/words.dart';

class ProblemsController extends GetxController {
  List<Map<String, dynamic>> problems = [];
  TextEditingController descriptionController = TextEditingController();
  Map<String, dynamic> selectedProblemType = {'name': 'select type'};
bool isLoading = false;
  void getProblemsTypes() async {
    await DioHelper.getProblemTypes().then((value) {
      value['data'].forEach((type) {
        problems.add(type);
      });
    });
    Get.log('Problems added successfully');
  }

  void sendProblem({
    required int productId,
  }) async {
    isLoading = true;
    update();
    await DioHelper.problemStore(
      description: descriptionController.text,
      type: selectedProblemType['id'].toString(),
      productId: productId,
    ).then((value) {
      Get.log(value.toString());
      if (value) {
        Get.back();
        descriptionController.clear();
        selectedProblemType = {'name': 'select type'};
        isLoading = false;
        update();
        Get.snackbar(AppWord.done, '');
      } else {
        isLoading = false;
        update();
        Get.snackbar(AppWord.warning, 'check your connection');
      }
    });
  }

  @override
  void onInit() {
    getProblemsTypes();
    super.onInit();
  }
}

