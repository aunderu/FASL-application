import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// import package:flutter/widgets.dart.

// ignore: must_be_immutable
class StudentGradeImgScreen extends StatefulWidget {
  final String? imggrade;
  const StudentGradeImgScreen(this.imggrade, {super.key});

  @override
  State<StudentGradeImgScreen> createState() => _StudentGradeImgScreenState();
}

class _StudentGradeImgScreenState extends State<StudentGradeImgScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: CachedNetworkImageProvider(
          'https://fasl.chabafarm.com/storage/file/' +
              widget.imggrade.toString()),
    ));
  }
}
