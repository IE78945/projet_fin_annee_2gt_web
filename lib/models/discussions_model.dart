import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionModel {
  final String? id ;
  final String type;
  final String lastMessage;
  final DateTime lastMessageDate;
  final bool isLastMessageSeenByAdmin;
  final bool isLastMessageSeenUser;
  final String? generation ;
  final String phoneNo;
  final String userId;
  final String? issue;


  const DiscussionModel({
    this.id,
    required this.type,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.isLastMessageSeenByAdmin,
    required this.isLastMessageSeenUser,
    this.generation,
    required this.phoneNo,
    required this.userId,
    this.issue,
  });

  toJason(){
    return{
      "Type" : type,
      "LastMessage" : lastMessage,
      "LastMessageDate" : lastMessageDate,
      "LastMessageStatusAdmin" : isLastMessageSeenByAdmin,
      "LastMessageStatusUser" : isLastMessageSeenUser,
      "Generation" : generation,
      "Phone" : phoneNo,
      "UserId" : userId,
      "Issue" : issue,
    };
  }

  //Map discussion fetched fromFirebase to DiscussionModel
  factory DiscussionModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    try{
      return DiscussionModel(
        id: document.id,
        type: data["Type"],
        lastMessage: data["LastMessage"],
        lastMessageDate: data["LastMessageDate"].toDate(),
        isLastMessageSeenByAdmin: data["isLastMessageSeenByAdmin"],
        isLastMessageSeenUser: data["isLastMessageSeenUser"],
        generation: data["Generation"],
        phoneNo: data["Phone"],
        userId: data["UserId"],
        issue: data["Issue"],
      );
    } catch(e){
      print("Error creating DiscussionModel from snapshot: $e");
      rethrow;
    }

  }

}