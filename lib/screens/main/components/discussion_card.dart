import 'package:flutter/material.dart';
import 'package:projet_fin_annee_2gt_web/models/Email.dart';
import 'package:projet_fin_annee_2gt_web/models/discussions_model.dart';
import 'package:projet_fin_annee_2gt_web/screens/email/email_screen.dart';
import 'package:projet_fin_annee_2gt_web/screens/main/main_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class DiscussionCard extends StatefulWidget {
  const DiscussionCard({
    Key? key,
    this.isActive = true,
    this.data,
    this.press,
  }) : super(key: key);

  final bool isActive;
  final DiscussionModel? data;
  final VoidCallback? press;


  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  late bool isSelected;

  GetColor(){
    if (widget.data!.generation == "2G (GSM)") return TagColor2G;
    if (widget.data!.generation == "3G (CDMA)") return TagColor3G;
    if (widget.data!.generation == "4G (LTE)") return TagColor4G;
    else return Colors.white;
  }

  @override
  void initState() {
    isSelected = widget.isActive;
    super.initState();
  }

  void _handleTap() {
    setState(() {
      isSelected = true;
    });
      widget.press?.call();
  }

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly


    Color c =GetColor();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: widget.isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "${widget.data!.phoneNo} \n",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: widget.isActive ? Colors.white : kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: widget.data!.type,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      color:
                                          widget.isActive ? Colors.white : kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy hh:mm a').format(widget.data!.lastMessageDate),
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: widget.isActive ? Colors.white70 : null,
                                ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    widget.data!.lastMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          height: 1.5,
                          color: widget.isActive ? Colors.white70 : null,
                        ),
                  )
                ],
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: Offset(5, 5),
              topShadowColor: Colors.white60,
              bottomShadowColor: Color(0xFF234395).withOpacity(0.15),
            ),
            if (!widget.data!. isLastMessageSeenByAdmin)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kBadgeColor,
                  ),
                ).addNeumorphism(
                  blurRadius: 4,
                  borderRadius: 8,
                  offset: Offset(2, 2),
                ),
              ),
            if (widget.data!.generation != null)
              Positioned(
                left: 8,
                top: 0,
                child: WebsafeSvg.asset(
                  "assets/Icons/Markup filled.svg",
                  height: 18,


                  colorFilter: ColorFilter.mode(c, BlendMode.modulate)


                ),
              )
          ],
        ),
      ),
    );
  }
}
