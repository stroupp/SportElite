import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sport_elite_app/router/router.dart';
import 'package:sport_elite_app/search_by_name/interactor/search_by_name_interactor.dart';

import '../../home_screen/interactor/home_screen_interactor.dart';
import '../../utils/constants.dart';
import '../entity/search_by_name_entity.dart';

class SearchByName extends StatefulWidget {
  String userType;

  SearchByName({Key? key, required this.userType}) : super(key: key);

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  TextEditingController searchField = TextEditingController();
  late Future<List<User>> futureUser;
  int searchLength = 0;

  SearchByNameInteractor searchByNameInteractor = SearchByNameInteractor();

  @override
  void initState() {
    super.initState();
    if (widget.userType == "trainer") {
      futureUser = searchByNameInteractor.fetchAllUsers();
    } else {
      futureUser = searchByNameInteractor.fetchTrainers();
    }
  }

  Future<String> getUserAvatarUrl(String? uid) async {
    return await HomeScreenInteractor.getPpUrlOfUser(uid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            dev.log("[SEARCH BY NAME]back button pressed");
            FocusManager.instance.primaryFocus?.unfocus();
            Timer(Duration(milliseconds: 200), () {
              Navigator.pop(context);
            });
          },
          icon: SvgPicture.asset(
            '${imagePath}back_button.svg',
            width: MediaQuery.of(context).size.width * 27 / testScreenWidth,
            height: MediaQuery.of(context).size.height * 27 / testScreenHeight,
          ),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width * 329 / testScreenWidth,
          decoration: const BoxDecoration(
              color: Color(0xFF2E2E2E),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchLength = value.length;
                });
              },
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 1,
              autocorrect: true,
              enableSuggestions: true,
              controller: searchField,
              decoration: InputDecoration(
                  suffixIcon: (searchLength > 0)
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: yellowColor,
                          ),
                          onPressed: () {
                            searchField.clear();
                            setState(() {
                              searchLength = 0;
                            });
                          })
                      : const Icon(
                          Icons.search,
                          color: yellowColor,
                        ),
                  border: InputBorder.none),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.85),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        toolbarHeight:
            MediaQuery.of(context).size.height * 131 / testScreenHeight,
      ),
      body: FutureBuilder(
        future: futureUser,
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (snapshot.data![index].username
                    .toLowerCase()
                    .contains(searchField.text.toLowerCase())) {
                  return GestureDetector(
                    onTap: () {
                      navigateToProfilePage(context, snapshot.data![index].uid,
                          snapshot.data![index].username, true);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    69 /
                                    testScreenHeight,
                                width: MediaQuery.of(context).size.width *
                                    73 /
                                    testScreenWidth,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                      snapshot.data![index].pp_url),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].username,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(
                                            16,
                                          ),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          color: yellowColor,
                                          size: 14,
                                        ),
                                        Text(
                                          " 4.9",
                                          style: TextStyle(color: yellowColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text("//About me part",
                              style: TextStyle(
                                color: yellowColor,
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                              )),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height *
                              60.1 /
                              testScreenHeight,
                        ),
                        Center(
                          child: Container(
                            color: const Color(0xFF707070),
                            height: MediaQuery.of(context).size.height *
                                1 /
                                testScreenHeight,
                            width: MediaQuery.of(context).size.width *
                                364 /
                                testScreenWidth,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            );
          }
        },
      ),
    );
  }
}
