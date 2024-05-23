import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/view_model/new_item_view_model.dart';

import 'screen/categories_list.dart';

import 'view_model/delete_view_model.dart';
import 'view_model/get_view_model.dart';
import 'view_model/post_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => NewItemViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => PostViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => GetViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => DeleteViewModel(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 147, 229, 250),
            brightness: Brightness.dark,
            surface: const Color.fromARGB(255, 42, 51, 59),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
          useMaterial3: true,
        ),
        home: const CategoriesList());
  }
}
