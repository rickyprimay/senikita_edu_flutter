import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widya/utils/routes/routes_names.dart';
import 'package:widya/view/my_class/widget/course_card_progress_widget.dart';
import 'package:widya/viewModel/enrollments_view_model.dart';
import 'package:widya/res/widgets/colors.dart';
import 'package:widya/res/widgets/fonts.dart';
import 'package:widya/res/widgets/loading.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyClassScreen extends StatefulWidget {
  const MyClassScreen({super.key});

  @override
  State<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends State<MyClassScreen> {

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(() {
        final enrollmentsViewModel = Provider.of<EnrollmentsViewModel>(context, listen: false);
        enrollmentsViewModel.appendNewEnrollments();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.tertiary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
                image: const DecorationImage(
                  image: AssetImage('assets/common/hero-texture2.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Center(
                child: Text(
                  'Kelas Saya',
                  style: AppFont.crimsonTextSubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<EnrollmentsViewModel>(
                builder: (context, enrollmentsViewModel, child) {
                  Future<void> refreshEnrollments() async {
                      final enrollmentsViewModel = Provider.of<EnrollmentsViewModel>(context, listen: false);
                      await enrollmentsViewModel.resetEnrollments();
                    }
                  if (enrollmentsViewModel.loading && enrollmentsViewModel.enrollments.isEmpty) {
                    return Loading(opacity: 0.5);
                  }

                  if (enrollmentsViewModel.error != null && enrollmentsViewModel.enrollments.isEmpty) {
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
                            onPressed: () => refreshEnrollments(),
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

                  final enrollments = enrollmentsViewModel.enrollments;

                  return LiquidPullToRefresh(
                    onRefresh: refreshEnrollments,
                    showChildOpacityTransition: true,
                    color: AppColors.primary,
                    height: 60,
                    backgroundColor: Colors.white,
                    animSpeedFactor: 2.0,
                    child: enrollments.isEmpty
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
                            controller: controller,
                            padding: const EdgeInsets.all(20),
                            itemCount: enrollments.length + 1,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index < enrollments.length) {
                                final enrollment = enrollments[index];

                                  return Column(
                                  children: [
                                    CourseCardWithProgress(
                                      title: enrollment.course.title,
                                      subtitle: enrollment.course.description,
                                      duration: enrollment.course.duration,
                                      author: enrollment.course.instructor.name,
                                      status: enrollment.status,
                                      imageUrl: enrollment.course.thumbnail,
                                      progress: enrollment.completionStats?.completionPercentage ?? 0.0,
                                      onTap: () {
                                        Navigator.of(context, rootNavigator: true).pushNamed(
                                          RouteNames.classDetail,
                                          arguments: {
                                            'courseId': enrollment.course.id,
                                            'courseName': enrollment.course.title,
                                            'courseDescription': enrollment.course.description,
                                          },
                                        );
                                      },
                                      levelLabel: enrollment.course.level,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              } else {
                                return Padding (
                                  padding: const EdgeInsets.symmetric(vertical: 32),
                                  child: Center(
                                    child: enrollmentsViewModel.hasMore
                                        ? const CircularProgressIndicator()
                                        : const SizedBox.shrink(),
                                  )
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
