import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:widya/provider/category_provider.dart';
import 'package:widya/provider/login_provider.dart';
import 'package:widya/utils/routes/routes.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:widya/viewModel/category_view_model.dart';
import 'package:widya/viewModel/course_view_model.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';
import 'package:widya/viewModel/lesson_view_model.dart';
import 'package:widya/viewModel/user_view_model.dart';
import 'package:toastification/toastification.dart';

const geminiApiKey = "AIzaSyB1rg-gZlHOll5yFz6vJgpOz92vjMfqxqo";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: geminiApiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseViewModel()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => EnrollmentsViewModel()),
        ChangeNotifierProvider(create: (_) => LessonViewModel()),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          title: 'SeniKitaEdu',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: RouteNames.splashScreen,
          onGenerateRoute: Routes.generateRoute,
          builder: (context, child) {
            return WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                return true;
              },
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
