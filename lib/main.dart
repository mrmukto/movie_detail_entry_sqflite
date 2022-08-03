import 'package:flutter/material.dart';
import 'package:movie_detail_entry/home_page.dart';
import 'package:movie_detail_entry/new_movie_page.dart';
import 'package:movie_detail_entry/details_page.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => HomePage(),
        NewMoviePage.routeName : (context) => NewMoviePage(),
        MovieDetails.routeName : (context) => MovieDetails(),
      },
    );
  }
}
