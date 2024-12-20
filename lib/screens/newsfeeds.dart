import 'package:babel/models/api_response.dart';
import 'package:babel/models/newsfeed.dart';
import 'package:babel/services/newsfeed_service.dart';
import 'package:flutter/material.dart';
import 'package:babel/constant.dart';
import 'package:babel/screens/newsfeed_view.dart';

class Newsfeeds extends StatefulWidget {
  const Newsfeeds({super.key});

  @override
  State<Newsfeeds> createState() => _NewsfeedsState();
}

class _NewsfeedsState extends State<Newsfeeds> {
  // dummy data
  // List<Newsfeed> newsfeeds = [
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/1.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'New Cultural Festival in Damascus',
  //     descriptionEn:
  //         'A new cultural festival will take place in Damascus this weekend.',
  //     titleAr: 'مهرجان ثقافي جديد في دمشق',
  //     descriptionAr: 'سيقام مهرجان ثقافي جديد في دمشق نهاية هذا الأسبوع.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Aleppo Museum Reopens After Restoration',
  //     descriptionEn:
  //         'The historic Aleppo Museum has reopened its doors after extensive restoration.',
  //     titleAr: 'إعادة افتتاح متحف حلب بعد الترميم',
  //     descriptionAr:
  //         'أعاد متحف حلب التاريخي فتح أبوابه بعد عمليات ترميم واسعة.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/3.jpg',
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/4.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/1.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/1.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'New Cultural Festival in Damascus',
  //     descriptionEn:
  //         'A new cultural festival will take place in Damascus this weekend.',
  //     titleAr: 'مهرجان ثقافي جديد في دمشق',
  //     descriptionAr: 'سيقام مهرجان ثقافي جديد في دمشق نهاية هذا الأسبوع.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Aleppo Museum Reopens After Restoration',
  //     descriptionEn:
  //         'The historic Aleppo Museum has reopened its doors after extensive restoration.',
  //     titleAr: 'إعادة افتتاح متحف حلب بعد الترميم',
  //     descriptionAr:
  //         'أعاد متحف حلب التاريخي فتح أبوابه بعد عمليات ترميم واسعة.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/3.jpg',
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/4.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/1.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/1.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'New Cultural Festival in Damascus',
  //     descriptionEn:
  //         'A new cultural festival will take place in Damascus this weekend.',
  //     titleAr: 'مهرجان ثقافي جديد في دمشق',
  //     descriptionAr: 'سيقام مهرجان ثقافي جديد في دمشق نهاية هذا الأسبوع.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/3.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Aleppo Museum Reopens After Restoration',
  //     descriptionEn:
  //         'The historic Aleppo Museum has reopened its doors after extensive restoration.',
  //     titleAr: 'إعادة افتتاح متحف حلب بعد الترميم',
  //     descriptionAr:
  //         'أعاد متحف حلب التاريخي فتح أبوابه بعد عمليات ترميم واسعة.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/3.jpg',
  //       'assets/2.jpg',
  //       'assets/1.jpg',
  //       'assets/4.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  //   Newsfeed(
  //     imagesPathes: [
  //       'assets/4.jpg',
  //       'assets/2.jpg',
  //       'assets/3.jpg',
  //       'assets/1.jpg',
  //     ],
  //     titleEn: 'Syrian Cuisine Festival in Homs',
  //     descriptionEn:
  //         'Experience the rich flavors of Syrian cuisine at the festival in Homs.',
  //     titleAr: 'مهرجان المطبخ السوري في حمص',
  //     descriptionAr:
  //         'استمتع بالنكهات الغنية للمطبخ السوري في المهرجان المقام في حمص.',
  //   ),
  // ];

  List<Newsfeed> newsfeeds = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchNewsfeeds();
  }

  void fetchNewsfeeds() async {
    final ApiResponse response = await NewsfeedService().getNewsfeeds();

    if (!mounted) return;

    if (response.error == null) {
      setState(() {
        newsfeeds = response.data as List<Newsfeed>;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0, // Space between columns
              mainAxisSpacing: 10.0, // Space between rows
              childAspectRatio: 1.0, // Aspect ratio of the items
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: newsfeeds.length,
            itemBuilder: (context, index) {
              return newsfeedCard(
                newsfeeds[index],
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewsfeedView(newsfeed: newsfeeds[index])),
                  );
                },
                context,
              );
            },
          );
  }
}
