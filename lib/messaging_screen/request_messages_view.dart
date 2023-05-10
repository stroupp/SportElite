import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/constants.dart';

class RequestView extends StatefulWidget {
  const RequestView({Key? key}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final int? _incomingRequestFromPerson = 100;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left * 20 / testScreenWidth,
      ),
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            dev.log("[Messaging] pressed on item $index");
          },
          child: Slidable(
            direction: Axis.horizontal,
            key: ValueKey(index),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (val) {
                    dev.log("[Message #$index] on mark as read");
                  },
                  icon: Icons.done_all_outlined,
                  backgroundColor: yellowColor,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(
                right:
                    MediaQuery.of(context).size.height * 25 / testScreenHeight,
                left:
                    MediaQuery.of(context).size.height * 26 / testScreenHeight,
                bottom:
                    MediaQuery.of(context).size.height * 28 / testScreenHeight,
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *
                          82 /
                          testScreenWidth,
                      height: MediaQuery.of(context).size.height *
                          82 /
                          testScreenHeight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        child: Image.network(
                          "https://preview.redd.it/ozx25tyk0g111.jpg?auto=webp&s=05ec7ec6dea555d8643c1a600238def1f60b6671",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *
                          25 /
                          testScreenWidth,
                    ),
                  ),
                  Flexible(
                    flex: 9,
                    child: Column(
                      children: [
                        Text(
                          "Ronnie Coleman",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              20,
                            ),
                            color: messagingMessageTitleWhiteColor,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              4 /
                              testScreenWidth,
                        ),
                        Text(
                          "I am looking for a yoga instructor",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              15,
                            ),
                            color: yellowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *
                          70 /
                          testScreenWidth,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          "15:20",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                            color: messagingDateGreyColor,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              17.3 /
                              testScreenHeight,
                        ),
                        if (_incomingRequestFromPerson == 0)
                          SvgPicture.asset(
                            "${imagePath}opened_messages.svg",
                          )
                        else
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                "${imagePath}incoming_messages_frame.svg",
                              ),
                              Text(
                                _incomingRequestFromPerson! > 99
                                    ? "+99"
                                    : "$widget.incomingMessages",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    15,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: messagingBackgroundBlackColor,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
