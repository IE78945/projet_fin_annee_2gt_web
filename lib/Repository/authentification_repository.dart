
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_fin_annee_2gt_web/screens/main/main_screen.dart';

import '../screens/onboding/onboding_screen.dart';


class AuthentificationRepository extends GetxController {
  static AuthentificationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  static bool isFirstTimeOpeningApp = true;

  @override
  void onReady() {
      firebaseUser = Rx<User?>(_auth.currentUser);
      firebaseUser.bindStream(_auth.userChanges());
      ever(firebaseUser, _setInitialScreen);
  }

   _setInitialScreen(User? user) {
    if(isFirstTimeOpeningApp){
      isFirstTimeOpeningApp = false;
     user == null ? Get.offAll(() => const OnboardingScreen()) : Get.offAll(() => MainScreen());

    }
  }

  Future<bool> CreateUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        "success",
        "Your account has been created",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      );
      return true;
    }on FirebaseAuthException catch(e){
      String error="";
      switch(e.code){
        case 'weak-password': error ='Please enter a stronger password';break;
        case 'invalid-email': error ='Email is not valid or badly formatted';break;
        case 'email-already-in-use': error ='An account already exists for that email';break;
        case 'operation-not-allowed': error ='Operation is not allowed. Please contact support.';break;
        case 'user-disabled': error ='This user has been disabled. Please contact support for help.';break;
        default:print('An unknown error occurred');
      }
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      return false;
    }catch(_){
      print('An unknown error occurred');
      return false;
    }
  }

  Future<bool> LoginUserWithEmailAndPassword(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        "success",
        "Logged in successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      );
      return true;
    }on FirebaseAuthException catch(e){
      Get.snackbar(
        "Error",
        e.message.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      return false;
    }catch(_){
      return false;}
  }

  Future<bool> ForgotPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "success",
        "Check your email to restore your password",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.green,
      );
      return true;
    }on FirebaseAuthException catch(e){
      Get.snackbar(
        "Error",
        e.message.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withOpacity(0.7),
        colorText: Colors.red,
      );
      return false;
    }catch(_){return false;}
  }

   Future<void> logout() async {
     await _auth.signOut();
     Get.snackbar(
       "success",
       "Logged out successfully",
       snackPosition: SnackPosition.TOP,
       backgroundColor: Colors.white.withOpacity(0.7),
       colorText: Colors.green,
     );
   }
 }