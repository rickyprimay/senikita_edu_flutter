import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/res/helpers/duration_formatter.dart';
import 'package:widya/view/my_class/widget/course_card_progress_widget.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyClassScreen extends StatelessWidget {
  const MyClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnrollmentsViewModel()..fetchEnrollments(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
                  image: const DecorationImage(
                    image: AssetImage('assets/common/hero-texture2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Kelas Saya',
                        style: AppFont.crimsonTextSubtitle.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section
              Expanded(
                child: Consumer<EnrollmentsViewModel>(
                  builder: (context, enrollmentsViewModel, child) {
                    Future<void> refreshEnrollments() async {
                      await enrollmentsViewModel.fetchEnrollments();
                    }

                    if (enrollmentsViewModel.loading && (enrollmentsViewModel.enrollments.isEmpty)) {
                      return Loading(opacity: 0.5);
                    }

                    if (enrollmentsViewModel.error != null && (enrollmentsViewModel.enrollments.isEmpty)) {
                      return Center(child: Text("Error: ${enrollmentsViewModel.error}"));
                    }

                    final enrollments = enrollmentsViewModel.enrollments;

                    return LiquidPullToRefresh(
                      onRefresh: refreshEnrollments,
                      showChildOpacityTransition: false,
                      color: AppColors.primary,
                      height: 60,
                      backgroundColor: Colors.white,     
                      animSpeedFactor: 2.0,        
                      child: (enrollments.isEmpty)
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      "Tidak ada kelas yang terdaftar.",
                                      style: AppFont.ralewaySubtitle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: enrollments.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final enrollment = enrollments[index];

                                return Column(
                                  children: [
                                    CourseCardWithProgress(
                                      title: enrollment.course.title,
                                      subtitle: enrollment.course.description,
                                      duration: formatDuration(enrollment.course.duration),
                                      author: enrollment.course.instructor?.name ?? "", 
                                      imageUrl: enrollment.course.thumbnail,
                                      progress: 0.22,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
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
