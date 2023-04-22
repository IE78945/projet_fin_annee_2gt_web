import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';
import 'components/sign_up_dialog.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late RiveAnimationController _signInBtnAnimationController;
  late RiveAnimationController _signUpBtnAnimationController;

  bool isShowSignInDialog = false;
  bool isShowSignUpDialog = false;

  @override
  void initState() {
    _signInBtnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    _signUpBtnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog || isShowSignUpDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Column(
                        children: const [
                          Text(
                            "Optimize Your Network",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Using our app is easy! Simply provide your location and a brief description of the problem you're experiencing, and we'll take care of the rest. ",
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedBtn(
                          text: "Sign In",
                          btnAnimationController: _signInBtnAnimationController,
                          press: () {
                            _signInBtnAnimationController.isActive = true;

                            Future.delayed(
                              const Duration(milliseconds: 800),
                                  () {
                                setState(() {
                                  isShowSignInDialog = true;
                                });
                                showSignInCustomDialog(
                                  context,
                                  onValue: (_) {
                                    setState(() {
                                      isShowSignInDialog = false;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                        AnimatedBtn(
                          text: "Sign Up",
                          btnAnimationController: _signUpBtnAnimationController,
                          press: () {
                            _signUpBtnAnimationController.isActive = true;

                            Future.delayed(
                              const Duration(milliseconds: 800),
                                  () {
                                setState(() {
                                  isShowSignUpDialog = true;
                                });
                                showSignUpCustomDialog(
                                  context,
                                  onValue: (_) {
                                    setState(() {
                                      isShowSignUpDialog = false;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),
                    Text(
                        "Your privacy and security are our top priorities.We will never share your personal information with third parties."),
                    Spacer(),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
