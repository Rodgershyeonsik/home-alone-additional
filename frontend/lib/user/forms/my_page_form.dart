import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utility/long_button_container.dart';
import 'package:provider/provider.dart';

import '../../auth/api/spring_member_api.dart';
import '../../utility/size.dart';
import '../../utility/providers/user_data_provider.dart';
import '../../widgets/result_alert_dialog.dart';
import '../../widgets/text_form_fields/text_form_field_nickname.dart';

class MyPageForm extends StatefulWidget {
  const MyPageForm({Key? key}) : super(key: key);

  @override
  State<MyPageForm> createState() => MyPageFormState();
}

class MyPageFormState extends State<MyPageForm> {

  late TextEditingController nicknameController = TextEditingController();
  late String newNickname;
  bool? nicknamePass;

  late bool res;

  @override
  void initState() {
    nicknameController.addListener(() {
      newNickname = nicknameController.text;
    });

    super.initState();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
          child: Consumer<UserDataProvider>(
            builder: (context, provider, widget) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("현재 닉네임: " + provider.nickname!,
                        style: const TextStyle(
                            fontSize: 25
                        )),
                    const SizedBox(height: large_gap),
                    const Text("새 닉네임", style: TextStyle(
                        fontSize: 25
                    )),
                    const SizedBox(
                      height: medium_gap,
                    ),
                    TextFormFieldNickname(controller: nicknameController),
                    const SizedBox(height: medium_gap),
                    LongButtonContainer(
                      textButton: TextButton(
                        onPressed: () async {
                          nicknamePass =
                          await SpringMemberApi.nicknameCheck(newNickname);
                          debugPrint(
                              "nicknamePass: " + nicknamePass.toString());

                          if (nicknamePass == true) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                const ResultAlertDialog(alertMsg: "사용 가능한 닉네임입니다.")
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                const ResultAlertDialog(alertMsg: "중복 되는 닉네임입니다.")
                            );
                          }
                        }, child: const Text("닉네임 중복 확인",
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ),
                    LongButtonContainer(
                      textButton: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                nicknamePass == true) {
                              res = await SpringMemberApi.
                              requestModifyUserData(
                                  ChangeNicknameRequest(provider.authToken!,
                                      newNickname));

                              if(res) {
                                await UserDataProvider.storage.write(key: 'nickname', value: newNickname);
                                provider.changeNickname(newNickname);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                    const ResultAlertDialog(alertMsg: "닉네임 변경되었습니다.")
                                );
                                } else {
                                await UserDataProvider.storage.deleteAll();

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                                          ),
                                          content: const Text(
                                              "로그인이 만료되었습니다.\n로그인 후 다시 시도해주세요."
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  await provider.setUserData();
                                                  Navigator.pushNamed(context, "/sign-in");
                                                }, child: const Text("로그인 하기"))
                                          ],
                                        ));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  const ResultAlertDialog(alertMsg: "중복 검사 통과 여부를 확인하세요.")
                              );
                            }
                      },
                          child: const Text("닉네임 변경하기",
                        style: TextStyle(
                            color: Colors.white
                        ),)),
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    TextButton(
                        onPressed: () =>
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                    ),
                                    title: const Text('회원 탈퇴'),
                                    content: const Text('회원 탈퇴 하시겠습니까?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('아니오'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          res = await SpringMemberApi
                                              .requestUnregister(
                                              provider.authToken);
                                          if (res == true) {
                                            await SpringMemberApi
                                                .requestSignOut(
                                                provider.authToken);
                                            await UserDataProvider.storage.deleteAll();
                                            Navigator.pushNamed(
                                                context, "/home");
                                          }
                                        },
                                        child: const Text('네'),
                                      ),
                                    ],
                                  ),
                            ),
                        child: Text("회원 탈퇴하기",
                          style: TextStyle(
                              color: Colors.grey.shade400
                          ),)),
                  ]);
            }
          )
        );
  }
}
