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

  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  late int _activeIndex ;

  final _chatRepo = Get.put(ChatRepository());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onCardPressed(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  void didUpdateWidget(covariant ListOfEmails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onSortBySelected != widget.onSortBySelected) {
      updateActiveIndex();
    }
  }

  void updateActiveIndex() {
    setState(() {
      _activeIndex = widget.clickedDiscussionIndex ?? -1;
    });
  }


  @override
  void initState() {
    if (widget.clickedDiscussionIndex == null || widget.clickedDiscussionIndex==-1) {
      _activeIndex = -1;
    }
    else {
      _activeIndex = widget.clickedDiscussionIndex!;
    }
    _selectedStartDate = widget.selectedStartDate ?? DateTime.now();
    _selectedEndDate = widget.selectedEndDate ?? DateTime.now();
    super.initState();
  }


  void updateDiscussionSortedBy(String sortBy) {
    setState(() {
      if (widget.onSortBySelected == sortBy) {
        // If the same sort by option is clicked again, set the index to -1
        widget.clickedDiscussionIndex = -1;
      } else {
        widget.onSortBySelected = sortBy;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(onSortBySelected: updateDiscussionSortedBy, ),
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
                child: StreamBuilder<List<DiscussionModel>>(
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
                      ) : const Center(child: CircularProgressIndicator(),);
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showPopup();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>( kPrimaryColor),
                  ),
                  child: const Text(
                    'View Statistics',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    generateCsvFromFirestore();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>( kPrimaryColor),
                  ),
                  child: const Text(
                    'Download All users CSV Data',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
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

  void showPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Customize the appearance of the popup
          color: Colors.white,
          child: Column(
            children: [
              // Add the contents of the popup here
              SizedBox(height: kDefaultPadding),
              const Text(
                "Statistics",
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: kDefaultPadding),
              const Text(
                "Since when you want stats",
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () => _selectDate(context, true),

                  child: Text('Select StartDate'),
              ),
              SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text('Select EndDate'),
              ),
              SizedBox(height: kDefaultPadding),
              FutureBuilder<int>(
                future: getReclamationsCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error retrieving number');
                  } else {
                    final number = snapshot.data;
                    return Text(
                      'Number of reclamations = $number',
                      style: const TextStyle(
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: kDefaultPadding),
              FutureBuilder<int>(
                future: getThechnicalCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error retrieving number');
                  } else {
                    final number = snapshot.data;
                    return Text(
                      'Number of Technical requests = $number',
                      style: const TextStyle(
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: kDefaultPadding),
              FutureBuilder<int>(
                future: getCommercialCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error retrieving number');
                  } else {
                    final number = snapshot.data;
                    return Text(
                      'Number of Commercial requests = $number',
                      style: const TextStyle(
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: kDefaultPadding),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int> getThechnicalCount() async {
    // Convert the start and end dates to Firestore Timestamps
    final startTimestamp = Timestamp.fromDate(_selectedStartDate);
    final endTimestamp = Timestamp.fromDate(_selectedEndDate.add(Duration(days: 1)));

    // Fetch discussions based on the selected date interval and type
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where("Type", isEqualTo: 'Technical Request')
        .where("LastMessageDate", isGreaterThanOrEqualTo: startTimestamp)
        .where("LastMessageDate", isLessThan: endTimestamp)
        .get();

    // Return the count of discussions
    return querySnapshot.size;
  }

  Future<int> getCommercialCount() async {
    // Convert the start and end dates to Firestore Timestamps
    final startTimestamp = Timestamp.fromDate(_selectedStartDate);
    final endTimestamp = Timestamp.fromDate(_selectedEndDate.add(Duration(days: 1)));

    // Fetch discussions based on the selected date interval and type
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where("Type", isEqualTo: 'Commercial Request')
        .where("LastMessageDate", isGreaterThanOrEqualTo: startTimestamp)
        .where("LastMessageDate", isLessThan: endTimestamp)
        .get();

    // Return the count of discussions
    return querySnapshot.size;
  }


  Future<int> getReclamationsCount() async {
    // Convert the start and end dates to Firestore Timestamps
    final startTimestamp = Timestamp.fromDate(_selectedStartDate);
    final endTimestamp = Timestamp.fromDate(_selectedEndDate.add(Duration(days: 1)));
    // Fetch discussions based on the selected date interval
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .where("LastMessageDate", isGreaterThanOrEqualTo: startTimestamp)
        .where("LastMessageDate", isLessThan: endTimestamp)
        .get();
    // Return the count of discussions
    return querySnapshot.size;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  GetDiscussionSortedBy(String sortBy) {
    if (sortBy == "2G (GSM)" || sortBy == "3G (CDMA)" || sortBy == "4G (LTE)" )
      return _chatRepo.getSortedDiscussionBasedOnGenaration(sortBy);
    else if (sortBy == "Technical Request" || sortBy=="Commercial Request"){
      return _chatRepo.getSortedDiscussionBasedOnType(sortBy);
    }
    else return _chatRepo.getAllDiscussion();

  }
}
