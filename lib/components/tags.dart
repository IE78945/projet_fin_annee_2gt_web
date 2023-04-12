import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants.dart';

class Tags extends StatefulWidget {
  const Tags({
    Key? key,
  }) : super(key: key);

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {

  bool isArrowTagClicked = true;

  void ShowTags() {
    setState(() {
      if (!isArrowTagClicked)
        isArrowTagClicked = true;
      else
        isArrowTagClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            MaterialButton(
              padding: EdgeInsets.all(10),
              minWidth: 40,
              onPressed: () {
                ShowTags();
              },
              child: WebsafeSvg.asset("assets/Icons/Angle down.svg", width: 16),
            ),

            SizedBox(width: kDefaultPadding / 4),
            WebsafeSvg.asset("assets/Icons/Markup.svg", width: 20),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              "Tags",
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: kGrayColor),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: kDefaultPadding / 2),
        Visibility(
          visible: isArrowTagClicked,
          child: Column(
            children: [
              buildTag(context, color: TagColor2G , title: "GSM"),
              buildTag(context, color: TagColor3G, title: "WCDMA"),
              buildTag(context, color: TagColor4G, title: "LTE"),
            ],
          ),
        )




      ],
    );
  }

  InkWell buildTag(BuildContext context,
      {required Color color, required String title}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kDefaultPadding * 1.5, 10, 0, 10),
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              child: WebsafeSvg.asset(
                "assets/Icons/Markup filled.svg",
                height: 18,
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: kGrayColor),
            ),
          ],
        ),
      ),
    );
  }
}
