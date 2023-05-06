
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/models/Email.dart';
import 'package:projet_fin_annee_2gt_web/models/messages_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class EmailScreen extends StatefulWidget {

  const EmailScreen({
    Key? key,
    this.email,
    this.id,
    this.UserphoneNo,
    this.ReclamationType,
  }) : super(key: key);

  final Email? email;
  final String? id ;
  final String? UserphoneNo;
  final String? ReclamationType;

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _chatRepo = Get.put(ChatRepository());

  void launchGoogleMaps(GeoPoint geoPoint) async {
    String url = "https://www.google.com/maps/search/?api=1&query=${geoPoint.latitude},${geoPoint.longitude}";

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  GetMessage() async {
    //update  LastMessageStatusAdmin to true in firestore
    await _chatRepo.MessageSeenByAdmin(widget.id);
    //return message
    return await _chatRepo.getMessage(widget.id) ;
  }

  @override
  Widget build(BuildContext context) {
    late bool isTechnicalRequest;
    if (widget.ReclamationType == "Technical Request") {
      isTechnicalRequest = true;
    } else {
      isTechnicalRequest = false;
    }


    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: FutureBuilder(
                          future: GetMessage(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done){
                              if (snapshot.hasData){
                                MessageModel message = snapshot.data as MessageModel;
                                // Convert the map into a list of key-value pairs
                                List<MapEntry<dynamic, dynamic>> items =[];
                                if (widget.ReclamationType == "Technical Request") {
                                  items = message.phoneData!.entries.toList();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.ReclamationType.toString(),
                                                style: Theme.of(context).textTheme.titleLarge,),
                                              Text.rich(
                                                TextSpan(
                                                  text: widget.UserphoneNo,
                                                  style: Theme.of(context).textTheme.labelLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: kDefaultPadding / 2),
                                        Text(
                                          DateFormat('dd/MM/yyyy hh:mm a').format(message.sentDate.toDate()),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: kDefaultPadding),
                                    const Divider(thickness: 1),
                                    LayoutBuilder(
                                      builder: (context, constraints) => SizedBox(
                                        width: constraints.maxWidth > 850
                                            ? 800 : constraints.maxWidth,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/Icons/Message.png",
                                                    width: 30,
                                                  ),
                                                  const SizedBox(width: kDefaultPadding/2),
                                                  const Text(
                                                    "Message",
                                                    style: TextStyle(
                                                      height: 1.5,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: kDefaultPadding / 2),
                                              Text(
                                                message.message,
                                                style: const TextStyle(
                                                  height: 1.5,
                                                  color: Color(0xFF4D5875),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              const SizedBox(height: kDefaultPadding),
                                              const SizedBox(height: kDefaultPadding / 2),
                                              //Location
                                              //Text("Longitude : "+message.location!.longitude.toString()):Text(""),
                                              isTechnicalRequest?
                                              GestureDetector(
                                                onTap: () {
                                                  launchGoogleMaps(message.location!);
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/Icons/localize.png",
                                                          width: 30,
                                                        ),
                                                        const SizedBox(width: kDefaultPadding/2),
                                                        const Text(
                                                          "Location",
                                                          style: TextStyle(
                                                            height: 1.5,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w900,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: kDefaultPadding/2),
                                                    Text(
                                                      "Latitude : "+'${message.location!.latitude}'+"\nLongitude : " +'${message.location!.longitude}',
                                                      style: const TextStyle(
                                                        height: 1.5,
                                                        color: Color(0xFF4D5875),
                                                        fontWeight: FontWeight.w300,
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                              ):const Text(""),

                                              const SizedBox(height: kDefaultPadding),

                                              isTechnicalRequest?
                                              //Text("Latitude : "+message.location!.latitude.toString()):Text(""),
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () {launchGoogleMaps(message.location!);},
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>( kPrimaryColor),
                                                  ),
                                                  child: const Text(
                                                    'View location on Google Maps',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ):const Text(""),

                                              const SizedBox(height: kDefaultPadding),
                                              //tableau
                                              SizedBox(
                                                child: (widget.ReclamationType == "Technical Request")
                                                    ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/Icons/Data.svg",
                                                              width: 30,
                                                            ),
                                                            const SizedBox(width: kDefaultPadding/2),
                                                            const Text(
                                                              "Network parameters",
                                                              style: TextStyle(
                                                                height: 1.5,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w900,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: kDefaultPadding/2),
                                                        Table(
                                                          border: TableBorder.all(
                                                            color: Colors.black54,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  // Create a table with one row per entry in the map
                                                  children: items.map((entry) {
                                                        return TableRow(
                                                            decoration: BoxDecoration(
                                                            color: Colors.grey[200],
                                                            ),
                                                          // Each row has two cells: one for the key, one for the value
                                                          children: [
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${entry.key}'.toUpperCase(),
                                                                    style: const TextStyle(
                                                                      height: 1.5,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w900,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(child: Text(
                                                                    '${entry.value}',
                                                                    style: const TextStyle(
                                                                    height: 1.5,
                                                                    ),
                                                                ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                  }).toList(),
                                                ),
                                                      ],
                                                    )
                                                    : const Text(""),
                                              ),
                                              //
                                              const SizedBox(height: kDefaultPadding),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else {
                                return Container();
                              }
                            }
                            else {return const Center(child: CircularProgressIndicator(),);}
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
