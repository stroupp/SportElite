import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/constants.dart';
import '../utils/localization_en.dart';

class DashboardEmptyView extends StatelessWidget {
  const DashboardEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 90 / testScreenHeight,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 62 / testScreenWidth,
              left: MediaQuery.of(context).size.width * 63 / testScreenWidth,
            ),
            child: Image.asset(
              '${imagePath}dashboard_emptyView_img.png',
              width: MediaQuery.of(context).size.width * 288 / testScreenWidth,
              height:
                  MediaQuery.of(context).size.height * 288 / testScreenHeight,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 51 / testScreenWidth,
              left: MediaQuery.of(context).size.width * 51 / testScreenWidth,
            ),
            child: Text(
              dashboard_emptyView_noTrainee_title,
              style: TextStyle(
                color: dashboardAppbarYellow,
                fontSize: ScreenUtil().setSp(
                  20,
                ),
                overflow: TextOverflow.fade,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 10 / testScreenHeight,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 40 / testScreenWidth,
              left: MediaQuery.of(context).size.width * 40 / testScreenWidth,
            ),
            child: Text(
              dashboard_emptyView_noTrainee_subTitle,
              style: TextStyle(
                color: dashboardEmptyTraineeListSubtitleGreyColor,
                fontSize: ScreenUtil().setSp(15),
                overflow: TextOverflow.fade,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 140 / testScreenHeight,
          ),
          IconButton(
            onPressed: () {
              dev.log("[Dashboard] pressed on add a trainer button");
            },
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 26 / testScreenWidth,
              left: MediaQuery.of(context).size.width * 340 / testScreenWidth,
            ),
            iconSize:
                MediaQuery.of(context).size.height * 50 / testScreenHeight,
            icon: SvgPicture.asset(
              '${imagePath}dashboard_emptyView_addTrainee_btn.svg',
            ),
          ),
        ],
      ),
    );
  }
}
