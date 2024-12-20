import 'package:babel/models/newsfeed.dart';
import 'package:babel/utils/image_utils.dart';
import 'package:flutter/material.dart';

class NewsfeedView extends StatefulWidget {
  final Newsfeed newsfeed;
  const NewsfeedView({super.key, required this.newsfeed});

  @override
  State<NewsfeedView> createState() => _NewsfeedViewState();
}

class _NewsfeedViewState extends State<NewsfeedView> {
  late Newsfeed newsfeed;

  @override
  void initState() {
    super.initState();
    newsfeed = widget.newsfeed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Select localized text
    final title = locale == 'ar' ? newsfeed.titleAr : newsfeed.titleEn;
    final description =
        locale == 'ar' ? newsfeed.descriptionAr : newsfeed.descriptionEn;

    return Scaffold(
      body: Stack(
        children: [
          // PageView for scrolling through images
          PageView.builder(
            itemCount: newsfeed.images.length,
            itemBuilder: (context, index) {
              return Image.memory(
                ImageUtils.convertBase64ToUint8List(newsfeed.images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // Positioned back button
          locale == 'ar'
              ? Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.primaryColor, // Theme-based color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              : Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.primaryColor, // Theme-based color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          // DraggableScrollableSheet for the article
          DraggableScrollableSheet(
            initialChildSize: 0.2, // Initially visible part
            minChildSize: 0.2, // Minimum visible size
            maxChildSize: 0.9, // Maximum size when fully dragged up
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          height: 20.0,
                          color: theme.dividerColor, // Theme-based color
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
