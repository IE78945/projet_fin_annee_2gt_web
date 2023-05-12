import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt_web/Repository/authentification_repository.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/components/side_menu.dart';
import 'package:projet_fin_annee_2gt_web/models/discussions_model.dart';
import 'package:projet_fin_annee_2gt_web/responsive.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:path/path.dart' as path;
import '../../../constants.dart';
import '../../../models/messages_model.dart';
import '../../email/email_screen.dart';
import 'dart:html' as html;
import 'discussion_card.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ListOfEmails extends StatefulWidget {
  int? clickedDiscussionIndex;
  String onSortBySelected;
  final Function(String?, String, String) updateEmailScreen;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  ListOfEmails({
    Key? key,
    this.clickedDiscussionIndex,
    required this.onSortBySelected,
    required this.updateEmailScreen,

  }) : super(key: key);


  @override
  _ListOfEmailsState createState() => _ListOfEmailsState();
}

class _ListOfEmailsState extends State<ListOfEmails> {



  late int _activeIndex ;

  final _chatRepo = Get.put(ChatRepository());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  bool isSortNeed = true;



  @override
  void initState() {
    if (widget.clickedDiscussionIndex == null || widget.clickedDiscussionIndex==-1) {
      _activeIndex = -1;
    }
    else {
      _activeIndex = widget.clickedDiscussionIndex!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListOfEmails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onSortBySelected != widget.onSortBySelected) {
      updateActiveIndex();
      CheckIfNeedToShowReclamationList(widget.onSortBySelected);
    }
  }


  void _onCardPressed(int index) {
    setState(() {
      _activeIndex = index;
    });
  }



  void updateActiveIndex() {
    setState(() {
      _activeIndex = widget.clickedDiscussionIndex ?? -1;
    });
  }



  void updateDiscussionSortedBy(String sortBy , bool SectionType) {
    setState(() {
      if (widget.onSortBySelected == sortBy) {
        // If the same sort by option is clicked again, set the index to -1
        widget.clickedDiscussionIndex = -1;
      } else {
        widget.onSortBySelected = sortBy;
      }

    });
  }

  CheckIfNeedToShowReclamationList(String sortBy){
    if (sortBy == "") {
      isSortNeed = false ;
    }
    else {
      isSortNeed = true ;
    }
  }

  GetDiscussionSortedBy(String sortBy) {
    if (sortBy == "2G (GSM)" || sortBy == "3G (CDMA)" || sortBy == "4G (LTE)" )
      return _chatRepo.getSortedDiscussionBasedOnGenaration(sortBy);
    else if (sortBy == "Technical Request" || sortBy=="Commercial Request"){
      return _chatRepo.getSortedDiscussionBasedOnType(sortBy);
    }
    else
      return _chatRepo.getAllDiscussion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(
          /* ------------------------Eronnnée !!!!!!!! -----*/
          onSortBySelected: updateDiscussionSortedBy,
          /*----------------------------------------------*/
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),

              Expanded(
                child:
                isSortNeed?
                StreamBuilder<List<DiscussionModel>>(
                    stream: GetDiscussionSortedBy(widget.onSortBySelected),
                    builder: (context, snapshot) {
                      var _data = snapshot.data;
                      return snapshot.hasData ? ListView.builder(
                        itemCount: _data?.length,
                        itemBuilder: (context, index) => DiscussionCard(
                          isActive: Responsive.isMobile(context) ? false : index == _activeIndex,
                          data: _data![index],
                          press: () {
                            _onCardPressed(index);
                            widget.updateEmailScreen(
                              _data![index].id,
                              _data![index].phoneNo,
                              _data![index].type,
                            );
                          },
                        ),
                      )
                          : const Center(  child: CircularProgressIndicator(), );
                    }
                ):
                    Container(),
              ),



            ],
          ),
        ),
      ),
    );

  }



}
