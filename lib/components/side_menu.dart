import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../Repository/authentification_repository.dart';
import '../constants.dart';
import '../models/discussions_model.dart';
import '../models/messages_model.dart';
import '../screens/onboding/onboding_screen.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class SideMenu extends StatefulWidget {
  int? clickedMenuItemIndex;
  final Function(String,bool) onSortBySelected;

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/Reclami1.png",
                      width: 100,
                    ),
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
                            widget.onSortBySelected('All',false);
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
                            widget.onSortBySelected('All',false);
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
                        widget.onSortBySelected('All',false);
                      },
                      title: "Inbox",
                      iconSrc: "assets/Icons/Inbox.svg",
                      isActive: isItemSelected(0),
                    );
                  }
                  else return SideMenuItem(
                    press: () {
                      _onMenuItemPress(0);
                      widget.onSortBySelected('All',false);
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
                  widget.onSortBySelected('Commercial Request',false);
                },
                title: "Commercial",
                iconSrc: "assets/Icons/Comm.svg",
                isActive: isItemSelected(1),
              ),

              SideMenuItem(
                press: () {
                  _onMenuItemPress(2);
                  widget.onSortBySelected('Technical Request',false);
                  ShowTags();
                },
                title: "Technical",
                iconSrc: "assets/Icons/Tech.svg",
                isActive: isItemSelected(2),
                showBorder: true,
              ),

              // Tags
              Column(
                children: [
                  SizedBox(height: kDefaultPadding / 2),
                  Visibility(
                    visible: isItemSelected(2),
                    child: Column(
                      children: [
                        buildTag(context, color: MyBlue , title: "GSM"),
                        buildTag(context, color: MyPurple, title: "WCDMA"),
                        buildTag(context, color: MyPink, title: "LTE"),
                      ],
                    ),
                  ),
                ],
              ),
              SideMenuItem(
                press: () {
                  _onMenuItemPress(3);
                  widget.onSortBySelected("",true);
                },
                title: statistic,
                iconSrc: "assets/Icons/statistics.svg",
                isActive: isItemSelected(3),
              ),

              SideMenuItem(
                press: () {
                  _onMenuItemPress(4);
                  widget.onSortBySelected("",false);
                  generateCsvFromFirestore();
                },
                title: "Download CSV",
                iconSrc: "assets/Icons/Download.svg",
                isActive: isItemSelected(4),
              ),

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
                iconSrc: "assets/Icons/Logout.svg",
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
            widget.onSortBySelected('2G (GSM)',false);
            _onMenuItemPress(2);
          }
          break;

          case "WCDMA": {
            widget.onSortBySelected('3G (CDMA)',false);
            _onMenuItemPress(2);
          }
          break;

          case "LTE": {
            widget.onSortBySelected('4G (LTE)',false);
            _onMenuItemPress(2);
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

  Future<void> generateCsvFromFirestore() async {
    // Fetch data from Firestore
    final querySnapshot = await FirebaseFirestore.instance.collection('Chats').where("Type" , isEqualTo: "Technical Request").get();

    // Create a List<List<dynamic>> to store the CSV data
    final csvData = <List<dynamic>>[];

    // Add column headers to the CSV data
    csvData.add(['Phone No', 'Generation', 'Latitude', 'Longitude']);

    // Iterate over the Firestore documents and add data to the CSV data
    for (final doc in querySnapshot.docs) {
      final discussion = DiscussionModel.fromSnapshot(doc);

      // Fetch all messages based on discussionID
      final messagesSnapshot = await FirebaseFirestore.instance.collection("Chats").doc(discussion.id).collection("Messages").get();

      // Iterate over the messages and extract the location data
      for (final messageDoc in messagesSnapshot.docs) {
        final message = MessageModel.fromSnapshot(messageDoc);
        final latitude = message.location?.latitude ?? '';
        final longitude = message.location?.longitude ?? '';

        // Add a new row with the message and location data
        csvData.add([
          discussion.phoneNo ?? '',
          discussion.generation ?? '',
          latitude,
          longitude,
        ]);
      }
    }

    // Create a CSV transformer
    final csvTransformer = const ListToCsvConverter();

    // Transform the CSV data to a CSV string
    final csvString = csvTransformer.convert(csvData);

    // Create a Blob from the CSV string
    final csvBlob = html.Blob([csvString], 'text/csv;charset=utf-8');

    // Generate a unique filename for the CSV file
    final fileName = 'User_Location_Data.csv';

    // Create a download link for the CSV file
    final csvUrl = html.Url.createObjectUrlFromBlob(csvBlob);
    final link = html.document.createElement('a') as html.AnchorElement;
    link.href = csvUrl;
    link.download = fileName;

    // Programmatically click the download link to initiate the download
    link.click();

    // Clean up the download link
    html.Url.revokeObjectUrl(csvUrl);
  }
}


