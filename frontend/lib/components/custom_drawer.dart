import 'package:flutter/material.dart';
import 'package:frontend/api/spring_member_api.dart';
import 'package:frontend/utility/main_color.dart';

import '../utility/user_data.dart';
import 'custom_alert_dialog.dart';
import 'forms/board_register_form.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late bool isLogin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserData.setUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserData.authToken != null ? isLogin = true : isLogin = false;

          return Drawer(
              child: Column(
              children: [
                isLogin
                  ? UserAccountsDrawerHeader(
                      accountName: Text(UserData.nickname!),
                      accountEmail: Text(UserData.email!))
                  : DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, "/sign-in"),
                            child: const Text("로그인"),
                          ),
                          SizedBox(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                          ),
                      ]),
                  decoration: BoxDecoration(
                    color: MainColor.mainColor
                  ),
                    ),
                ListTile(
                  title: const Text("홈화면 가기"),
                  onTap: () => Navigator.pushNamed(context, "/home"),
              ),
                ExpansionTile(
                  title: Text("게시판 보기"),
                  children: [
                  ListTile(
                    title: Text("자유 게시판"),
                    onTap: () =>
                        Navigator.pushNamed(context, "/board-list-free"),
                  ),
                  ListTile(
                    title: Text("질문 게시판"),
                    onTap: () =>
                        Navigator.pushNamed(context, "/board-list-ask"),
                  ),
                  ListTile(
                    title: Text("1인분 게시판"),
                    onTap: () =>
                        Navigator.pushNamed(context, "/board-list-recipe"),
                  ),
                ],
              ),
              isLogin
                  ? ListTile(
                      title: Text("게시물 작성하기"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardRegisterForm(),
                          )))
                  : Container(),
              isLogin
                  ? ListTile(
                      title: Text("내 정보 보기"),
                      onTap: () => Navigator.pushNamed(context, "/my-page"))
                  : Container(),
                ListTile(
                  title: Text("공지사항"),
                  onTap: () => Navigator.pushNamed(context, "/board-list-notice"),
                ),
              isLogin
                  ? ListTile(
                    title: Text("로그아웃"),
                    onTap: () async {
                      await SpringMemberApi()
                          .requestSignOut(UserData.authToken);
                      await UserData.storage.deleteAll();
                      debugPrint("storage 삭제");
                      setState(() {
                        isLogin = false;
                      });
                      showResultDialog(context, "로그아웃", "로그아웃이 완료되었습니다.");
                    },
                    )
                  : Container()
            ],
          ));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void showResultDialog(BuildContext context, String title, String alertMsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CustomAlertDialog(title: title, alertMsg: alertMsg));
  }
}
