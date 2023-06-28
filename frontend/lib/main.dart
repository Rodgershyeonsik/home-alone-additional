import 'package:flutter/material.dart';
import 'package:frontend/board/screens/ask_board_screen.dart';
import 'package:frontend/board/screens/free_board_screen.dart';
import 'package:frontend/board/screens/notice_board_screen.dart';
import 'package:frontend/board/screens/recipe_board_screen.dart';
import 'package:frontend/user/screens/my_page_screen.dart';
import 'package:frontend/auth/screens/sign_in_screen.dart';
import 'package:frontend/auth/screens/sign_up_complete_screen.dart';
import 'package:frontend/auth/screens/sign_up_screen.dart';
import 'package:frontend/utility/providers/category_provider.dart';
import 'package:frontend/utility/main_color.dart';
import 'package:frontend/utility/providers/board_list_provider.dart';
import 'package:frontend/utility/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';

void main() {
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) =>UserDataProvider()),
          ChangeNotifierProvider(create: (BuildContext context) => BoardListProvider()),
          ChangeNotifierProvider(create: (BuildContext context) => CategoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: MainColor.mainColor,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
        backgroundColor: MainColor.mainColor,
        ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black
            )
          )
        ),
        title: 'HOME ALONE',
        initialRoute: "/home",
        routes: {
        "/sign-up": (context) => SignUpScreen(),
        "/home": (context) => HomeScreen(),
        "/sign-in": (context) => SignInScreen(),
        "/sign-up-complete": (context) =>SignUpCompleteScreen(),
        "/board-list-free": (context) => FreeBoardScreen(),
        "/board-list-ask": (context) => AskBoardScreen(),
        "/board-list-recipe": (context) => RecipeBoardScreen(),
        "/board-list-notice": (context) => NoticeBoardScreen(),
          "/my-page": (context) => MyPageScreen(),
        },
      ),
    );
  }
}
