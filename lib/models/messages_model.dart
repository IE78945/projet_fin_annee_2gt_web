import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id ;
  final String message;
  final Timestamp sentDate;
  final String senderId;
  final String status;
  final Map? phoneData;
  final GeoPoint? location;

  const MessageModel({
    this.id,
    required this.senderId,
    required this.sentDate,
    required this.message,
    required this.status,
    this.phoneData,
    this.location
  });

  toJason(){
    return{
      "SenderId" : senderId,
      "SentDate" : sentDate,
      "Message" : message,
      "Status" : status,
      "PhoneData" : phoneData,
      "Location" : location,
    };
  }

  //Map user fetched fromFirebase to UserModel
  factory MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return MessageModel(
      id: document.id,
      senderId: data["SenderId"],
      sentDate: data["SentDate"],
      message: data["Message"],
      status: data["Status"],
      phoneData: data["PhoneData"],
      location: data["Location"],
    );
  }
  DateTime get sentDateTime => sentDate.toDate();
}