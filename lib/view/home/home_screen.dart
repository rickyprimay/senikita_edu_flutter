import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/provider/home_provider.dart';
import 'package:widya/res/helpers/duration_formatter.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:widya/view/home/widget/category_slider_widget.dart';
import 'package:widya/view/home/widget/course_card_widget.dart';
import 'package:widya/viewModel/course_view_model.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseViewModel()..fetchCourses()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..loadUserData()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  final name = homeProvider.name ?? "Pengguna";
                  final photo = homeProvider.photo;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                      image: const DecorationImage(
                        image: AssetImage('assets/common/hero-texture.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.menu, color: Colors.white),
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
                                      photo,
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            style: AppFont.ralewaySubtitle.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari Pembelajaran...',
                              hintStyle: AppFont.ralewaySubtitle.copyWith(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 10),
              const CategorySliderWidget(),
              const SizedBox(height: 8),
              
              Expanded(
                child: Consumer<CourseViewModel>(
                  builder: (context, courseViewModel, child) {
                    if (courseViewModel.loading) {
                      return Loading(opacity: 0.5);
                    }

                    if (courseViewModel.error != null) {
                      return Center(child: Text("Error: ${courseViewModel.error}"));
                    }

                    final courses = courseViewModel.courses;

                    if (courses == null || courses.isEmpty) {
                      return Center(child: Text("Tidak ada kursus tersedia saat ini.", style: AppFont.ralewaySubtitle.copyWith(fontSize: 16, fontWeight: FontWeight.w500)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];

                        return Column(
                          children: [
                            CourseCard(
                              color: Colors.orange.shade100,
                              title: course.title,
                              subtitle: course.description,
                              duration: formatDuration(course.duration),
                              icon: Icons.music_note,
                              author: course.instructor.name,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
