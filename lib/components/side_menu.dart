import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../Repository/authentification_repository.dart';
import '../constants.dart';
import '../screens/onboding/onboding_screen.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {
  int? clickedMenuItemIndex;
  final Function(String) onSortBySelected;

  SideMenu({
    Key? key,
    this.clickedMenuItemIndex,
    required this.onSortBySelected,
  }) : super(key: key);



  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  late int _activeIndex ;
  final _chatRepo = Get.put(ChatRepository());

  void _onMenuItemPress(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  bool isItemSelected(int index){
    if (_activeIndex == index) return true;
    else return false;
  }
  bool isArrowTagClicked = true;

  void ShowTags() {
    setState(() {
      if (!isArrowTagClicked)
        isArrowTagClicked = true;
      else
        isArrowTagClicked = false;
    });
  }

  @override
  void initState() {
    if (widget.clickedMenuItemIndex == null) {
      _activeIndex = 0;
    }
    else {
      _activeIndex = widget.clickedMenuItemIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/Reclami.png",
                    width: 150,
                  ),
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              FutureBuilder(
                future: _chatRepo.getUnreadMessagesNumber(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done){
                    if (snapshot.hasData){
                      if(snapshot.data == 0 ) {
                        return SideMenuItem(
                          press: () {
                            _onMenuItemPress(0);
                            widget.onSortBySelected('All');
                          },
                          title: "Inbox",
                          iconSrc: "assets/Icons/Inbox.svg",
                          isActive: isItemSelected(0),
                        );
                      }
                      else {
                        return SideMenuItem(
                          press: () {
                            _onMenuItemPress(0);
                            widget.onSortBySelected('All');
                          },
                          title: "Inbox",
                          iconSrc: "assets/Icons/Inbox.svg",
                          isActive: isItemSelected(0),
                          itemCount: snapshot.data,
                        );
                      }

                    }
                    else return SideMenuItem(
                      press: () {
                        _onMenuItemPress(0);
                        widget.onSortBySelected('All');
                      },
                      title: "Inbox",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: isItemSelected(0),
                    );
                  }
                  else return SideMenuItem(
                    press: () {
                      _onMenuItemPress(0);
                      widget.onSortBySelected('All');
                    },
                    title: "Inbox",
                    iconSrc: "assets/Icons/Inbox.svg",
                    isActive: isItemSelected(0),
                  );
                },

              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(2);
                  widget.onSortBySelected('Technical Request');
                  //widget.onTagSelected(-1);
                },
                title: "Technical",
                iconSrc: "assets/Icons/File.svg",
                isActive: isItemSelected(2),
              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(3);
                  widget.onSortBySelected('Commercial Request');
                  //widget.onTagSelected(-1);
                },
                title: "Commercial",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: isItemSelected(3),
                showBorder: false,
              ),

              SizedBox(height: kDefaultPadding * 2),


              // Tags
              Column(
                children: [
                Row(
                  children: [
                  MaterialButton(
                    padding: EdgeInsets.all(10),
                    minWidth: 40,
                    onPressed: () { ShowTags(); },
                    child: WebsafeSvg.asset("assets/Icons/Angle down.svg", width: 16),
                  ),

    SizedBox(width: kDefaultPadding / 4),
    WebsafeSvg.asset("assets/Icons/Markup.svg", width: 20),
    SizedBox(width: kDefaultPadding / 2),
    Text(
    "Tags",
    style: Theme.of(context)
        .textTheme
        .button
        ?.copyWith(color: kGrayColor),
    ),
    Spacer(),
    ],
    ),
    SizedBox(height: kDefaultPadding / 2),
    Visibility(
    visible: isArrowTagClicked,
    child: Column(
    children: [
    buildTag(context, color: TagColor2G , title: "GSM"),
    buildTag(context, color: TagColor3G, title: "WCDMA"),
    buildTag(context, color: TagColor4G, title: "LTE"),
    ],
    ),
    )


    ],
    ),
              SizedBox(height: kDefaultPadding * 2),
              SideMenuItem(
                press: () {
                  setState(() {
                    AuthentificationRepository.instance.logout();
                    Get.snackbar(
                      "success",
                      "Logged out successfully",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.white.withOpacity(0.7),
                      colorText: Colors.green,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  });
                },
                title: "Sign out",
                iconSrc: "assets/Icons/Trash.svg",
                showBorder: false,
              ),

            ],
          ),
        ),
      ),
    );
  }


  InkWell buildTag(BuildContext context,
      {required Color color, required String title}) {
    return InkWell(
      onTap: () {
        switch(title) {
          case "GSM": {
            widget.onSortBySelected('2G (GSM)');
            _onMenuItemPress(-1);
          }
          break;

          case "WCDMA": {
            widget.onSortBySelected('3G (CDMA)');
            _onMenuItemPress(-1);
          }
          break;

          case "LTE": {
            widget.onSortBySelected('4G (LTE)');
            _onMenuItemPress(-1);
          }
          break;

        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kDefaultPadding * 1.5, 10, 0, 10),
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              child: WebsafeSvg.asset(
                "assets/Icons/Markup filled.svg",
                height: 18,
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: kGrayColor),
            ),
          ],
        ),
      ),
    );
  }
}
