import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/res/widgets/shared_preferences.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/home/widget/category_slider_widget.dart';
import 'package:widya/view/home/widget/course_card_widget.dart';
import 'package:widya/viewModel/course_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String? _name;
  String? _photo;

  String? get name => _name;
  String? get photo => _photo;

  Future<void> _loadUserData() async {
    final sp = SharedPrefs.instance;
    final prefs = await sp;
    setState(() {
      _name = prefs.getString("user_name");
      _photo = prefs.getString("user_photo");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        final courseViewModel = Provider.of<CourseViewModel>(context, listen: false);
        courseViewModel.appendNewCourses();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primary,
                      AppColors.tertiary
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  image: DecorationImage(
                    image: AssetImage('assets/common/hero-texture2.png'),
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //   // Colors.black.withAlpha(15),
                    //   // BlendMode.srcOver
                    // ),
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Widya',
                          style: AppFont.crimsonTextTitle.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        ClipOval(
                          child: photo != null
                              ? Image.network(
                                  photo!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey,
                                      child: const Icon(Icons.error, color: Colors.white),
                                    );
                                  },
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey,
                                  child: const Icon(Icons.person, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Halo, $name 👋',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Siapkah kamu untuk melestarikan Kesenian Indonesia? Mari Belajar Seni dan Budaya Nusantara Bersama Ahlinya',
                      style: AppFont.ralewaySubtitle.copyWith(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(22),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      child: TextField(
                        controller: _searchController,
                        style: AppFont.ralewaySubtitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari Pembelajaran...',
                          hintStyle: AppFont.ralewaySubtitle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: AppColors.secondary),
                            onPressed: () {
                              final searchQuery = _searchController.text;
                              if (searchQuery.isNotEmpty) {
                                final courseViewModel = Provider.of<CourseViewModel>(context, listen: false);
                                courseViewModel.searchCourses(searchQuery);
                              } else {
                                final courseViewModel = Provider.of<CourseViewModel>(context, listen: false);
                                courseViewModel.resetCourses();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              const CategorySliderWidget(),
              const SizedBox(height: 8),
              
              Expanded(
                child: Consumer<CourseViewModel>(
                  builder: (context, courseViewModel, child) {
                    Future<void> refreshCourses() async {
                      final courseViewModel = Provider.of<CourseViewModel>(context, listen: false);
                      await courseViewModel.resetCourses();
                    }
                    if (courseViewModel.loading && (courseViewModel.courses == null || courseViewModel.courses!.isEmpty)) {
                      return Loading(opacity: 0.5);
                    }

                    if (courseViewModel.error != null && (courseViewModel.courses == null || courseViewModel.courses!.isEmpty)) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Error: Gagal Koneksi Ke Server",
                              style: AppFont.ralewaySubtitle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => refreshCourses(),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              child: Text(
                                'Coba Lagi',
                                style: AppFont.ralewaySubtitle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final courses = courseViewModel.courses;

                    return LiquidPullToRefresh(
                      onRefresh: refreshCourses,
                      showChildOpacityTransition: true,
                      color: AppColors.primary,
                      height: 60,
                      backgroundColor: Colors.white,     
                      animSpeedFactor: 2.0,        
                      child: (courses == null || courses.isEmpty)
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      "Tidak ada kursus tersedia saat ini.",
                                      style: AppFont.ralewaySubtitle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.all(20),
                              itemCount: courses.length + 1,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < courses.length) {
                                  final course = courses[index];

                                  return Column(
                                    children: [
                                      CourseCard(
                                        title: course.title,
                                        subtitle: course.description,
                                        duration: course.duration,
                                        icon: Icons.music_note,
                                        author: course.instructor.name,
                                        imageUrl: course.thumbnail,
                                        level: course.level,
                                        isEnrolled: course.isEnrolled,
                                        onTap: () {
                                          Navigator.of(context, rootNavigator: true).pushNamed(
                                            RouteNames.course,
                                            arguments: {
                                              'courseId': course.id,
                                              'instructorName': course.instructor.name,
                                              'categoryName': course.category.join(', '), 
                                              'isEnrolled': course.isEnrolled
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );

                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32),
                                    child: Center(
                                      child: courseViewModel.hasMore 
                                        ? const CircularProgressIndicator()
                                        : const SizedBox.shrink(),
                                    ),
                                  );
                                }
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }
}
