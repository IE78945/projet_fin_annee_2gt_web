import 'package:flutter/material.dart';
import 'package:projet_fin_annee_2gt_web/models/Email.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class EmailCard extends StatelessWidget {
  const EmailCard({
    Key? key,
    this.isActive = true,
    required this.data,
    this.press,
  }) : super(key: key);

  final bool isActive;
  final Email? data;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(data!.image),
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "${data!.name} \n",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isActive ? Colors.white : kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: data!.subject,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(
                                      color:
                                          isActive ? Colors.white : kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            data!.time,
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: isActive ? Colors.white70 : null,
                                ),
                          ),
                          SizedBox(height: 5),
                          if (data!.isAttachmentAvailable)
                            WebsafeSvg.asset(
                              "assets/Icons/Paperclip.svg",
                              colorFilter: isActive
                                  ? ColorFilter.mode(Colors.white, BlendMode.modulate)
                                  : ColorFilter.mode(kGrayColor, BlendMode.modulate),
                            )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    data!.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          height: 1.5,
                          color: isActive ? Colors.white70 : null,
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
            if (!data!.isChecked)
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
            if (data!.tagColor != null)
              Positioned(
                left: 8,
                top: 0,
                child: WebsafeSvg.asset(
                  "assets/Icons/Markup filled.svg",
                  height: 18,
                  colorFilter: ColorFilter.mode(data!.tagColor, BlendMode.modulate)
                ),
              )
          ],
        ),
      ),
    );
  }
}
