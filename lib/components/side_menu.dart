import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/responsive.dart';

import '../constants.dart';
import 'side_menu_item.dart';
import 'tags.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatefulWidget {
  SideMenu({
    this.clickedMenuItemIndex,
    Key? key,
  }) : super(key: key);

  int? clickedMenuItemIndex;

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
                    "assets/images/Logo Outlook.png",
                    width: 46,
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
                      },
                      title: "Inbox",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: isItemSelected(0),
                    );
                  }
                  else return SideMenuItem(
                    press: () {
                      _onMenuItemPress(0);
                    },
                    title: "Inbox",
                    iconSrc: "assets/Icons/Inbox.svg",
                    isActive: isItemSelected(0),
                  );
                },

              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(1);
                },
                title: "Sent",
                iconSrc: "assets/Icons/Send.svg",
                isActive: isItemSelected(1),

              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(2);
                },
                title: "Technical",
                iconSrc: "assets/Icons/File.svg",
                isActive: isItemSelected(2),
              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(3);
                },
                title: "Commercial",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: isItemSelected(3),
                showBorder: false,
              ),

              SizedBox(height: kDefaultPadding * 2),
              // Tags
              Tags(),
            ],
          ),
        ),
      ),
    );
  }
}
