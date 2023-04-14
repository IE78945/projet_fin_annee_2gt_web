import 'package:flutter/material.dart';
import 'package:projet_fin_annee_2gt_web/components/side_menu.dart';
import 'package:projet_fin_annee_2gt_web/models/discussions_model.dart';
import 'package:projet_fin_annee_2gt_web/responsive.dart';
import 'package:projet_fin_annee_2gt_web/screens/email/email_screen.dart';
import 'components/list_of_emails.dart';

class MainScreen extends StatefulWidget {




  MainScreen({
    this.updatedEmailData

  });

  final DiscussionModel? updatedEmailData;


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: ListOfEmails(),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListOfEmails(),
            ),
            Expanded(
              flex: 9,
              child: widget.updatedEmailData != null
                  ? EmailScreen(id: widget.updatedEmailData!.id,UserphoneNo :widget.updatedEmailData!.phoneNo, ReclamationType : widget.updatedEmailData!.type)
                  : EmailScreen(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 3 : 5,
              child: ListOfEmails(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child:  widget.updatedEmailData != null
                  ? EmailScreen(id: widget.updatedEmailData!.id,UserphoneNo :widget.updatedEmailData!.phoneNo, ReclamationType : widget.updatedEmailData!.type)
                  : EmailScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
