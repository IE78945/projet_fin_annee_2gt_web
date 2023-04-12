
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

  // Fetch All Users discussions in firestore
  Stream<List<DiscussionModel>> getAllDiscussion() {
    var _ref = _db.collection("Chats");
    return _ref.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
            return DiscussionModel.fromSnapshot(doc);
      }).toList();
    });
  }


}