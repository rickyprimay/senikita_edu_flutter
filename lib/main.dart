import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/utils/routes/routes.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/viewModel/auth_view_model.dart';
import 'package:widya/viewModel/user_view_model.dart';
import 'package:toastification/toastification.dart';

void main() async {
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
