import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:widya/res/widgets/discover_list.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/art/art_screen.dart';
import 'package:widya/view/certificate/certificate_screen.dart';
import 'package:widya/view/class_detail/class_detail_screen.dart';
import 'package:widya/view/course/course_screen.dart';
import 'package:widya/view/discover/discover_screen.dart';
import 'package:widya/view/feedback/feedback_screen.dart';
import 'package:widya/view/history_quiz/history_quiz_screen.dart';
import 'package:widya/view/home/home_screen.dart';
import 'package:widya/view/login/login_screen.dart';
import 'package:widya/view/my_class/my_class_screen.dart';
import 'package:widya/view/profile/profile_screen.dart';
import 'package:widya/view/quiz/quiz_screen.dart';
import 'package:widya/view/senikita/senikita_screen.dart';
import 'package:widya/view/senikita_edu/senikita_edu.dart';
import 'package:widya/view/splash/splash_screen.dart';
import 'package:widya/view/submission/submission_screen.dart';
import 'package:widya/view/submission_history/submission_history_screen.dart';
import 'package:widya/view/temu_batiik/temu_batik_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case (RouteNames.login):
        return MaterialPageRoute(builder: (BuildContext context) => const LoginScreen());
      case (RouteNames.discover):
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return Discover(
            controller: PersistentTabController(initialIndex: 0),
            screens: discoverScreens,
          );
        },
      );
      case (RouteNames.home):
        return MaterialPageRoute(builder: (BuildContext context) => const HomeScreen());
      case (RouteNames.splashScreen):
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case (RouteNames.profile):
        return MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen());
      case (RouteNames.myClass):
        return MaterialPageRoute(builder: (BuildContext context) => const MyClassScreen());
      case (RouteNames.seniKita):
        return MaterialPageRoute(builder: (BuildContext context) => const SeniKitaScreen());
      case (RouteNames.seniKitaEdu):
        return MaterialPageRoute(builder: (BuildContext context) => const SeniKitaEduScreen());
      case (RouteNames.art):
        return MaterialPageRoute(builder: (BuildContext context) => const ArtScreen());
      case (RouteNames.quizHistory):
        return MaterialPageRoute(builder: (BuildContext context) => const HistoryQuizScreen());
      case (RouteNames.certificate):
        return MaterialPageRoute(builder: (BuildContext context) => const CertificateScreen());
      case (RouteNames.temuBatik):
        return MaterialPageRoute(builder: (BuildContext context) => const TemuBatikScreen());
      case (RouteNames.feedback):
        final args = settings.arguments as Map<String, dynamic>;
        final lessonId = args['lessonId'] as int;
        final rules = args['rules'] as String;

        return MaterialPageRoute(
          builder: (BuildContext context) =>
            FeedbackScreen(
              lessonId: lessonId,
              rules: rules,
            )
          );
      case (RouteNames.submissionHistory):
        final args = settings.arguments as Map<String, dynamic>;
        final lessonId = args['lessonId'] as int;
        final lessonName = args['lessonName'] as String;
        final submissionType = args['submissionType'] as String;

        return MaterialPageRoute(
          builder: (BuildContext context) =>
            SubmissionHistoryScreen(
              lessonId: lessonId,
              lessonName: lessonName,
              submissionType: submissionType,
            )
        );
      case (RouteNames.submission):
        final args = settings.arguments as Map<String, dynamic>;
        final lessonId = args['lessonId'] as int;
        final submissionType = args['submissionType'] as String;

        return MaterialPageRoute(
          builder: (BuildContext context) => SubmissionScreen(
            lessonId: lessonId,
            submissionType: submissionType,
          ),
        );
      case (RouteNames.quiz):
        final args = settings.arguments as Map<String, dynamic>;
        final quizTitle = args['quizTitle'] as String;
        final timeLimit = args['timeLimit'] as int;
        final lessonId = args['lessonId'] as int;

        return MaterialPageRoute(
          builder: (BuildContext context) => QuizScreen(
            quizTitle: quizTitle,
            timeLimit: timeLimit,
            lessonId: lessonId,
        ));
      case (RouteNames.course):
        final args = settings.arguments as Map<String, dynamic>;
        final courseId = args['courseId'] as int;
        final instructorName = args['instructorName'] as String;
        final categoryName = args['categoryName'] as String;
        final isEnrolled = (args['isEnrolled'] as bool?) ?? false;

        return MaterialPageRoute(
          builder: (BuildContext context) => CourseScreen(
            courseId: courseId,
            instructorName: instructorName,
            categoryName: categoryName,
            isEnrolled: isEnrolled,
          ),
        );
      case (RouteNames.classDetail):
        final args = settings.arguments as Map<String, dynamic>;
        final courseId = args['courseId'] as int;
        final courseName = args['courseName'] as String;
        final courseDescription = args['courseDescription'] as String;

        return MaterialPageRoute( 
          builder: (BuildContext context) => ClassDetailScreen(
            courseId: courseId,
            courseName: courseName,
            courseDescription: courseDescription,
          )
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("No route is configured"),
            ),
          ),
        );
    }
  }
}