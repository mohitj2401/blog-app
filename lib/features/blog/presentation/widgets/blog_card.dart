import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/add_blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_detail_page.dart';
import 'package:blog_app/features/blog/presentation/pages/edit_blog.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Color color;
  final Blog blog;
  final String userId;
  const BlogCard({
    required this.blog,
    required this.color,
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, BlogDetailPage.route(blog)),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(
                                color: null,
                                label: Text(e),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${calculateReadingTime(blog.content)} min'),
                if (blog.userId == userId)
                  IconButton(
                    onPressed: () =>
                        Navigator.push(context, EditBlogPage.route(blog)),
                    icon: const Icon(
                      Icons.edit_note,
                      size: 25,
                      weight: 4,
                      color: AppPallete.backgroundColor,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
