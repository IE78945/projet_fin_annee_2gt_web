import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projet_fin_annee_2gt_web/Repository/chat_repository.dart';
import 'package:projet_fin_annee_2gt_web/models/Email.dart';
import 'package:projet_fin_annee_2gt_web/models/discussions_model.dart';
import 'package:projet_fin_annee_2gt_web/models/messages_model.dart';
import 'package:projet_fin_annee_2gt_web/screens/main/main_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'package:intl/intl.dart';



class EmailScreen extends StatefulWidget {

  EmailScreen({
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



  GetMessage() async {
    return await _chatRepo.getMessage(widget.id) ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: FutureBuilder(
                          future: GetMessage(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done){
                              if (snapshot.hasData){
                                MessageModel message = snapshot.data as MessageModel;
                                // Convert the map into a list of key-value pairs
                                List<MapEntry<dynamic, dynamic>> items =[];
                                if (widget.ReclamationType == "Technical Request")
                                  items = message.phoneData!.entries.toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.ReclamationType.toString(),
                                                style: Theme.of(context).textTheme.headline6,),
                                              Text.rich(
                                                TextSpan(
                                                  text: widget.UserphoneNo,
                                                  style: Theme.of(context).textTheme.button,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: kDefaultPadding / 2),
                                        Text(
                                          DateFormat('dd/MM/yyyy hh:mm a').format(message.sentDate.toDate()),
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Divider(thickness: 1),
                                    LayoutBuilder(
                                      builder: (context, constraints) => SizedBox(
                                        width: constraints.maxWidth > 850
                                            ? 800 : constraints.maxWidth,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message.message,
                                                style: TextStyle(
                                                  height: 1.5,
                                                  color: Color(0xFF4D5875),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(height: kDefaultPadding),
                                              SizedBox(height: kDefaultPadding / 2),
                                              SizedBox(
                                                height: 200,
                                                child: (widget.ReclamationType == "Technical Request")
                                                    ? Table(
                                                  border: TableBorder.all(color: Colors.black54),
                                                  // Create a table with one row per entry in the map
                                                  children: items.map((entry) {
                                                    return TableRow(
                                                      // Each row has two cells: one for the key, one for the value
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text('${entry.key}'),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Text('${entry.value}'),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                )
                                                    : Text(""),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else return Container();
                            }
                            else return Text("no data");
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
