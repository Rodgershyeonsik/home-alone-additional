import 'package:flutter/material.dart';
import 'package:frontend/auth/api/spring_member_api.dart';
import 'package:frontend/utility/main_color.dart';
import 'package:provider/provider.dart';

import '../board/screens/board_register_screen.dart';
import '../utility/providers/user_data_provider.dart';
import 'result_alert_dialog.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late bool isLogin;
  late UserDataProvider userDataProvider;

  @override
  void initState() {
    super.initState();
    userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    userDataProvider.authToken != null ? isLogin = true : isLogin = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, provider, widget){
              return Drawer(
                  child: Column(
                    children: [
                      isLogin
                          ? UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                              color: MainColor.mainColor
                                ),
                              accountName: Text(provider.nickname!),
                              accountEmail: Text(provider.email!))
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
                                builder: (context) => const BoardRegisterScreen(),
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
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                    AlertDialog(
                                     title: Text("알림"),
                                      content: Text("로그아웃 하시겠습니까?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }, child: Text("아니오")),
                                        TextButton(
                                          onPressed: () async {
                                            await signOut();
                                            setState(() {
                                              isLogin = false;
                                            });
                                            Navigator.pushNamed(context, '/home');
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    const ResultAlertDialog(alertMsg: "로그아웃이 완료되었습니다."));
                                          },
                                          child: Text("네")
                                        )
                                      ],
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0))),
                                  )
                              );
                            },
                      )
                          : Container()
                    ],
                  ));
          },
        );
  }

  Future<void> signOut() async {
    await SpringMemberApi()
        .requestSignOut(userDataProvider.authToken);
    await UserDataProvider.storage.deleteAll();
    debugPrint("storage 삭제");
  }

}
