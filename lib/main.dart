import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widya/provider/category_provider.dart';
import 'package:widya/provider/login_provider.dart';
import 'package:widya/provider/quiz_provider.dart';
import 'package:widya/utils/routes/routes.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:widya/viewModel/category_view_model.dart';
import 'package:widya/viewModel/certificate_view_model.dart';
import 'package:widya/viewModel/course_view_model.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';
import 'package:widya/viewModel/lesson_view_model.dart';
import 'package:widya/viewModel/quiz_view_model.dart';
import 'package:widya/viewModel/submission_view_model.dart';
import 'package:widya/viewModel/user_view_model.dart';
import 'package:toastification/toastification.dart';

const geminiApiKey = "AIzaSyB1rg-gZlHOll5yFz6vJgpOz92vjMfqxqo";

Future<void> _requestPermissions() async {
  if (await Permission.storage.status.isDenied) {
    await Permission.storage.request();
  }
  
  if (await Permission.photos.status.isDenied) {
    await Permission.photos.request(); 
  }
  
  if (await Permission.videos.status.isDenied) {
    await Permission.videos.request();
  }
  
  if (await Permission.audio.status.isDenied) {
    await Permission.audio.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: geminiApiKey);
  await _requestPermissions();
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
        ChangeNotifierProvider(create: (_) => CourseViewModel()..fetchCourses()),
        ChangeNotifierProvider(create: (_) => EnrollmentsViewModel()..fetchEnrollments()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LessonViewModel()),
        ChangeNotifierProvider(create: (_) => SubmissionViewModel()),
        ChangeNotifierProvider(create: (_) => CertificateViewModel()),
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProxyProvider<QuizViewModel, QuizProvider>(
          create: (context) => QuizProvider(quizViewModel: context.read<QuizViewModel>()),
          update: (context, quizViewModel, previous) => 
              previous ?? QuizProvider(quizViewModel: quizViewModel),
        ),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          title: 'Widya',
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
