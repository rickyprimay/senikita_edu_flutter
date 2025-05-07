// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:widya/models/course/course_model.dart';
// import 'package:widya/res/widgets/shared_preferences.dart';
// import 'package:widya/viewModel/course_view_model.dart';

// class HomeProvider extends ChangeNotifier {
//   final CourseViewModel courseViewModel = CourseViewModel();

//   // late final PagingController<int, Course> _pagingController = PagingController<int, Course>(
//   //   getNextPageKey: (state) => (state.keys?.last ?? 0 ) + 1,
//   //   fetchPage: (pageKey) => courseViewModel.fetchCoursesForPaging(page: pageKey),
//   // );

//   PagingController<int, Course> get pagingController => _pagingController;
  
//   String? _name;
//   String? _photo;

//   String? get name => _name;
//   String? get photo => _photo;

//   Future<void> loadUserData() async {
//     final sp = SharedPrefs.instance;
//     final prefs = await sp;
//     _name = prefs.getString("user_name");
//     _photo = prefs.getString("user_photo");

//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
// }
