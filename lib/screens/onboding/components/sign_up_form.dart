import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:rive/rive.dart';

import '../../../Repository/authentification_repository.dart';
import '../../main/main_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  late TextEditingController _PasswordController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _UserNameController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  String _password="";
  late String _confirmpassword;


  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;

  late SMITrigger confetti;

  @override
  void initState() {
    super.initState();
  }

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }



  void signUp(BuildContext context) {

    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
          () async {
            if (_formKey.currentState!.validate()) {
            Future<bool> isFirebaseAuthentificationAccountCreated;
            isFirebaseAuthentificationAccountCreated =
                AuthentificationRepository.instance
                    .CreateUserWithEmailAndPassword(
                    _emailController.text.trim(),
                    _PasswordController.text.trim());

            if (await isFirebaseAuthentificationAccountCreated) {

                success.fire();
                Future.delayed(
                  const Duration(seconds: 2),
                      () {
                    setState(() {
                      isShowLoading = false;
                    });
                    confetti.fire();
                    // Navigate & hide confetti
                    Future.delayed(const Duration(seconds: 1), () {
                      // Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                      );
                    });
                  },
                );
              }
            else {
                // show failure animation
                error.fire();
                Future.delayed(
                  const Duration(seconds: 2),
                      () {
                    setState(() {
                      isShowLoading = false;
                    });
                    reset.fire();
                  },
                );
              }
            }
          }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //Email
                const Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                  ),
                ),

                //password
                const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    obscureText: _isObscurePassword,
                    controller: _PasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                        return 'Please enter a valid password';
                      }
                      return null; // Return null if the input is valid
                    },
                    onChanged: (value){
                      setState(() {
                        _password = _PasswordController.text;
                      });

                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: Icon(
                            _isObscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: _isObscurePassword ? Colors.grey : Color(0xFFF77D8E),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                //confirm password
                const Text(
                  "Confirm Password",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: TextFormField(
                    obscureText: _isObscureConfirmPassword,
                    onChanged: (value){
                      setState(() {
                        _password = _PasswordController.text;
                        _confirmpassword = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      } else if (_password != value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: Icon(
                            _isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: _isObscureConfirmPassword ? Colors.grey : Color(0xFFF77D8E),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscureConfirmPassword = !_isObscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                //Button
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  child: ElevatedButton.icon(
                    onPressed: () {
                        signUp(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF77D8E),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color(0xFFFE0037),
                    ),
                    label: const Text("Sign Up"),
                  ),
                ),

              ],
            ),
          ),
        ),
        isShowLoading
            ? CustomPositioned(
          child: RiveAnimation.asset(
            'assets/RiveAssets/check.riv',
            fit: BoxFit.cover,
            onInit: _onCheckRiveInit,
          ),
        )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
          scale: 6,
          child: RiveAnimation.asset(
            "assets/RiveAssets/confetti.riv",
            onInit: _onConfettiRiveInit,
            fit: BoxFit.cover,
          ),
        )
            : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
