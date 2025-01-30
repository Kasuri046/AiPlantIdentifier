import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/screens/identify_Screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/plant_match_data_model.dart';
import '../model/plantas_detail_data_model.dart';
import '../service/plantas_api_service.dart';

class PlantProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  PlantasMatchData? _plantasMatchModel;
  PlantasDetailData? _plantasDetailData;
  bool _plantasMatchLoading = false;
  bool _isDetailLoading = false;
  bool _cameraPermissionGranted = false;
  CameraController? _cameraController;
  int _currentCameraIndex = 0;

  List<CameraDescription>? cameras;
  XFile? _image;
  int? _selectedIndex;
  String? _seletedplantType;
  int? get selectedIndex => _selectedIndex;
  String? get seletedplantType => _seletedplantType;
  bool _iscontained = false;
  bool? get iscontained => _iscontained;
  bool? get plantasMatchLoading => _plantasMatchLoading;
  bool get isDetailLoading => _isDetailLoading;
  CameraController? get cameraController => _cameraController;
  PlantasMatchData? get plantasMatchModel => _plantasMatchModel;
  PlantasDetailData? get plantasDetailData => _plantasDetailData;
  int get currentCameraIndex => _currentCameraIndex;
  XFile? get image => _image;
  bool get cameraPermissionGranted => _cameraPermissionGranted;

  void selectPlant(int index, String? value) {
    _selectedIndex = index;
    _seletedplantType = value ?? 'auto';
    notifyListeners();
  }

  void updateProgressState(bool value) {
    _iscontained = value;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    _image = null;
    notifyListeners();
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && image.path.isNotEmpty) {
      _image = image;
      log("-----------------${image.path}");
      notifyListeners();
    } else {
      log("No image selected or an error occurred.");
    }
  }

  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _cameraPermissionGranted = true;
      notifyListeners();
      await initializeCamera();
    } else {
      _cameraPermissionGranted = false;
      notifyListeners();
    }
  }

  Future<void> toggleCamera() async {
    if (cameras != null && cameras!.isNotEmpty) {
      await _cameraController?.dispose();
      _currentCameraIndex = (currentCameraIndex + 1) % cameras!.length;
      _cameraController = CameraController(cameras![_currentCameraIndex], ResolutionPreset.high);
      await _cameraController?.initialize();
      notifyListeners();
    }
  }

  captureImage(BuildContext context) async {
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        XFile image = await _cameraController!.takePicture();
        _image = image;
        log("Image captured: ${_image!.path}");
        notifyListeners();
        Provider.of<Adsprovider>(context, listen: false).showHomeInterstitialAd();
        Navigator.pushReplacementNamed(context, IdentifyScreen.routeName);
      } else {
        log("Camera is not initialized");
      }
    } catch (e) {
      log("Error capturing image: $e");
    }
  }

  Future<void> initializeCamera() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        _cameraController = CameraController(
          cameras![_currentCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );

        try {
          await _cameraController!.initialize();
          notifyListeners();
        } catch (e) {
          log("Error initializing camera: $e");
        }
      } else {
        log("No cameras available.");
      }
    } else {
      log("Camera permission denied.");
    }
  }

  Future<PlantasMatchData?> getPlantasMatchData(String? organs) async {
    if (_image == null) {
      debugPrint('No image selected.');
      return null;
    }

    _plantasMatchModel = null;
    _plantasMatchLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> response = await PlantIdentificationService.getPlantasMatchApi(organs, _image!.path);

      if (response.containsKey('success') && response['success'] == true) {
        debugPrint("Api key id ==================${response['id']}");
        _plantasMatchModel = PlantasMatchData.fromJson(response['data']);
        notifyListeners();

        return _plantasMatchModel;
      } else {
        debugPrint('Response body: $response');
        _plantasMatchLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _plantasMatchLoading = false;
      notifyListeners();
      debugPrint('Error sending image to API: $e');
      return null;
    } finally {
      await Future.delayed(const Duration(seconds: 3), () {
        _plantasMatchLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> fetchPlantasDetail({
    String? preferredReferential,
    String? bestMatch,
  }) async {
    _plantasDetailData = null;
    _isDetailLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> response = await PlantIdentificationService.plantasDetaildata(
        preferedReferential: preferredReferential,
        bestMatch: bestMatch,
      );
      // Check if the response was successful
      if (response['success'] == true) {
        _plantasDetailData = PlantasDetailData.fromJson(response['data']);
        notifyListeners();
      } else {
        debugPrint('Error: Failed to fetch plant details');
      }
    } catch (e) {
      debugPrint('Error fetching plant detail data: $e');
      _isDetailLoading = false;
      notifyListeners();
      ();
    } finally {
      await Future.delayed(const Duration(seconds: 4), () {
        _isDetailLoading = false;
        notifyListeners();
        ();
      });
    }
  }

  //Chrome Open
  Future<void> openPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.google.co.uk/');
    try {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) throw 'Could not launch $url';
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  //Email Open
  Future<void> sendEmail() async {
    final String email = Uri.encodeComponent("periperistudio@gmail.com");
    final String subject = Uri.encodeComponent("To Support Team");
    final String body = Uri.encodeComponent("I need help from help center");

    final Uri emailUri = Uri.parse("mailto:$email?subject=$subject&body=$body");

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        log('Could not launch email client');
      }
    } catch (error) {
      log('Error sending email: $error');
    }
  }

  Future<void> sharePlantDetailsOnWikipedia() async {
    final speciesName = plantasDetailData?.species?.name;
    final url = 'https://en.wikipedia.org/wiki/$speciesName';
    if (speciesName == null || speciesName.isEmpty) {
      throw Exception('Missing plant species name to generate Wikipedia URL.');
    }
    final title = 'Learn more about $speciesName on Wikipedia';
    try {
      await Share.share(url, subject: title);
    } catch (e) {
      throw Exception('Error sharing the Wikipedia link: $e');
    }
  }

  SharedPreferences? _prefs;

  double _rating = 0;
  bool _rated = false;
  bool _isInAppReviewDialogVisible = true;
  bool _isReviewDialogVisible = true;

  Future<void> initializeRatedPref() async {
    _prefs = await SharedPreferences.getInstance();
    _rated = _prefs?.getBool('rated') ?? false;
    _rating = _prefs?.getDouble('rating') ?? 0.0;
    notifyListeners();
  }

  double get rating => _rating;
  bool get rated => _rated;
  final String _inAppReviewDialogKey = 'showInappReviewReviewDialog';
  final String _showReviewDialogKey = 'showReviewDialog';
  bool get isInAppReviewDialogVisible => _isInAppReviewDialogVisible;
  bool get isReviewDialogVisible => _isReviewDialogVisible;

  void updateRating(double newRating) async {
    _rating = newRating;
    await _prefs?.setDouble('rating', newRating);
    notifyListeners();
  }

  Future<void> rateApp() async {
    if (_rating > 3 && !_rated) {
      await requestAppReview();
      await _prefs?.setBool('rated', true);
      _rated = true;
      notifyListeners();
    }
  }

  Future<void> initializeInAppReviewDialog() async {
    _isInAppReviewDialogVisible = _prefs?.getBool(_inAppReviewDialogKey) ?? true;
    notifyListeners();
  }

  Future<void> updateInAppReviewDialogStatus(bool value) async {
    _isInAppReviewDialogVisible = value;

    if (_prefs != null) {
      await _prefs!.setBool(_inAppReviewDialogKey, value);
    }

    notifyListeners();
  }

  Future<void> loadReviewDialogVisibility() async {
    _isReviewDialogVisible = _prefs?.getBool(_showReviewDialogKey) ?? true;
    notifyListeners();
  }

  Future<void> updateReviewDialogVisibility(bool value) async {
    _isReviewDialogVisible = value;
    await _prefs?.setBool(_showReviewDialogKey, value);
    notifyListeners();
  }

  Future<void> openAppInPlayStore() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.hiplant.ai.identifyplants.plantscanner.plantidentifier');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> requestAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing();
    }
  }
}
