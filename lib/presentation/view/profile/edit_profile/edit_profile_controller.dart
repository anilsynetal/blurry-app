import 'dart:developer';
import 'dart:io';

import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../core/utils/string.dart';
import '../../../../data/repository/api_repository.dart';
import '../../home/home_controller.dart';
import '../controller/profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController().obs;
  // final cityController = TextEditingController().obs;
  final ageController = TextEditingController().obs;
  final punchlineController = TextEditingController().obs;
  final bio = TextEditingController().obs;

  final profileImage = Rx<XFile?>(null);
  Rx<String> profileImageUrl = "".obs;
  final isLoading = false.obs;
  final isImageUploading = false.obs;
  final creditsCount = 12.obs;


  final RxString gender = ''.obs;
  final List<String> genders = const ['Men', 'Women', 'Prefer Not To Say', 'Other'];


  final ApiRepository apiRepository;
  EditProfileController({required this.apiRepository});

  @override
  void onInit() {
    super.onInit();

    _fetchProfileDetails();
  }

  Future<void> _fetchProfileDetails() async {
    try {
      isLoading.value = true;
      final response = await apiRepository.getProfileDetails();

      if (response != null ) {
        final user = response!.data!.user!;

        switch (user.gender?.toLowerCase()) {
          case 'male':
            gender.value = 'Men';
            break;

          case 'female':
            gender.value = 'Women';
            break;

          case 'other':
            gender.value = 'Other';
            break;

          case 'prefer not to say':
            gender.value = 'Prefer Not To Say';
            break;

          default:
            gender.value = 'Prefer Not To Say';
        };
        nameController.value.text = user.name ?? '';

        locationCtrl.value = user.city ?? '';
        ageController.value.text = "${user.age?.toString() ?? ''}";
        punchlineController.value.text = user.punchLine ?? '';
        bio.value.text = user.bio ?? '';
        creditsCount.value = user.walletCredit ?? 0;
        profileImageUrl.value = user.avatar.toString();
        print(" locationCtrl.value ${ locationCtrl.value}");
      } else {

      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage.value = image;
        await _uploadProfileImage(image.path);
      }
    } catch (e) {

    }
  }

  Future<void> takeProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        profileImage.value = image;
        await _uploadProfileImage(image.path);
      }
    } catch (e) {

    }
  }

  Future<void> _uploadProfileImage(String imagePath) async {
    // Check file size 5MB
    File imageFile = File(imagePath);
    int sizeInBytes = imageFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 5) {
      showMessageDialog("Image size must be less than 5 MB", "Warning");
      return;
    }

    try {
      isImageUploading.value = true;
      final response = await apiRepository.updateProfilePicture(imagePath);

      if (response.status == "success") {

        GetStorage().write(userDataKey, response.data!.user!.toJson()??"");
        Get.find<ProfileController>().imageUrl.value = "${imageBaseUrl}${response.data!.user!.avatar}";
        showSuccessMessage('Profile picture updated successfully');
      } else {
        showErrorMessageDialog( response.message ?? 'Failed to update profile picture');
        // Reset image if upload fails
        profileImage.value = null;
      }
    } catch (e) {

      profileImage.value = null;
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> saveChanges(context) async {
    if (_validateForm()) {
      isLoading.value = true;
      try {
        String genderValue;

        switch (gender.value) {
          case 'Men':
            genderValue = 'male';
            break;
          case 'Women':
            genderValue = 'female';
            break;
          case 'Prefer Not To Say':
            genderValue = 'prefer not to say';
            break;
          case 'Other':
            genderValue = 'other';
            break;
          default:
            genderValue = 'prefer not to say';
        }

        final updateBody = {
          'name': nameController.value.text,
          'city': locationCtrl.value,
          'age': int.tryParse(ageController.value.text) ?? 0,
          'punchLine': punchlineController.value.text,
          "bio":bio.value.text,
          "gender":genderValue
        };
        final response = await apiRepository.updateProfile(updateBody);
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().bioHome.value = response.bio ?? "";
        }

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().userPunchline.value = response.punchLine ?? "";
        }
          GetStorage().write(userNameKey, response.name??"");
          GetStorage().write(emailKey, response.email??"");
        log("Update Profile response ${ response.toJson()}");
          GetStorage().write(userDataKey, response.toJson()??"");
          Navigator.pop(context,true);

          // showMessageDialog('Profile updated successfully',"Success");


      } catch (e) {

      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateForm() {
    if (nameController.value.text.isEmpty) {
      showMessageDialog('Name is required', "Warning ⚠️");

      return false;
    }

    if (ageController.value.text.isEmpty) {
      showMessageDialog('Age is required', "Warning ⚠️");


      return false;
    }
    return true;
  }

  @override
  void onClose() {
    
    super.onClose();
  }


  Rx<String> locationCtrl = "".obs;
  RxList<String> cityList = [
    // Major Cities
    'Amsterdam',
    'Rotterdam',
    'The Hague (Den Haag)',
    'Utrecht',
    'Eindhoven',
    'Tilburg',
    'Groningen',
    'Almere',
    'Breda',
    'Nijmegen',
    'Enschede',
    'Apeldoorn',
    'Haarlem',
    'Arnhem',
    'Amersfoort',
    'Zaanstad',
    'Hertogenbosch (Den Bosch)',
    'Zwolle',
    'Leiden',
    'Maastricht',
    'Dordrecht',
    'Leeuwarden',
    'Ede',
    'Emmen',
    'Venlo',
    'Delft',
    'Helmond',
    'Deventer',
    'Alkmaar',
    'Sittard-Geleen',
    'Roosendaal',
    'Hoofddorp',
    'Vlaardingen',
    'Heerlen',
    'Hilversum',
    'Assen',
    'Middelburg',
    'Lelystad',
    'Hengelo',
    'Oss',
    'Gouda',
    'Rijswijk',
    'Zeist',
    'Capelle aan den IJssel',
    'Katwijk',
    'Tiel',
    'Woerden',
    'Other / Outside Netherlands',
  ].obs;
}
