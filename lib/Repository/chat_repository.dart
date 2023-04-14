
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:projet_fin_annee_2gt_web/models/discussions_model.dart';
import 'package:projet_fin_annee_2gt_web/models/messages_model.dart';


class ChatRepository extends GetxController{

  static ChatRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //Store message in firestore
  Future<bool> addMessage(MessageModel message, String DiscId) async {
    bool b = false;
    await _db.collection("Chats").doc(DiscId).collection("Messages").add(message.toJason()).whenComplete(() => { b = true })
        .catchError((error, stackTrace){ print(error.toString()); b = false; });
    return b;
  }

  // Fetch All discussions in firestore
  Stream<List<DiscussionModel>> getAllDiscussion() {
    var _ref = _db.collection("Chats");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
            return DiscussionModel.fromSnapshot(doc);
      }).toList();
    });
  }

  // Fetch discussions in firestore based on type
  Stream<List<DiscussionModel>> getSortedDiscussionBasedOnType(String? type) {
    var _ref = _db.collection("Chats").where("Type" , isEqualTo: type);
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DiscussionModel.fromSnapshot(doc);
      }).toList();
    });
  }

  // Fetch discussions in firestore based on generation
  Stream<List<DiscussionModel>> getSortedDiscussionBasedOnGenaration(String? generation) {
    var _ref = _db.collection("Chats").where("Generation" , isEqualTo: generation);
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        print(doc);
        return DiscussionModel.fromSnapshot(doc);
      }).toList();
    });
  }

  // Fetch all messages based on discussionID
  Stream<List<MessageModel>> getAllMessages(String? DiscussionId){
    var _ref =_db.collection("Chats").doc(DiscussionId).collection("Messages");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return MessageModel.fromSnapshot(doc);
      }).toList();
    });
  }


  //Fetch message sent by user based on discussion ID
    Future<MessageModel> getMessage(String? DiscussionId) async{
      final snapshot = await _db.collection("Chats").doc(DiscussionId).collection("Messages").get();
      final message = snapshot.docs.map((e) => MessageModel.fromSnapshot(e)).single;
      return message;
    }


  // Count unread messages by admin
  Future<int> getUnreadMessagesNumber() async{
    AggregateQuerySnapshot num = await _db.collection("Chats").where("LastMessageStatusAdmin",isEqualTo: false).count().get();
    return num.count;
  }



}