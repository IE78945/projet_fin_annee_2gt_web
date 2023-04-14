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
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  final _chatRepo = Get.put(ChatRepository());

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
                      return SideMenuItem(
                        press: () {},
                        title: "Inbox",
                        iconSrc: "assets/Icons/Inbox.svg",
                        isActive: true,
                        itemCount: snapshot.data,
                      );
                    }
                    else return SideMenuItem(
                      press: () {},
                      title: "Inbox",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: true,
                    );
                  }
                  else return SideMenuItem(
                    press: () {},
                    title: "Inbox",
                    iconSrc: "assets/Icons/Inbox.svg",
                    isActive: true,
                  );
                },

              ),
              SideMenuItem(
                press: () {},
                title: "Sent",
                iconSrc: "assets/Icons/Send.svg",
                isActive: false,

              ),
              SideMenuItem(
                press: () {},
                title: "Technical",
                iconSrc: "assets/Icons/File.svg",
                isActive: false,
              ),
              SideMenuItem(
                press: () {},
                title: "Commercial",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: false,
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
