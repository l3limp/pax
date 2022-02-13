import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pax/theme.dart';

class PostCard extends StatefulWidget {
  final String activityName;
  final String postText;
  final int likes;
  final String authorName;
  final bool showName;
  final String docID;
  final String image;

  const PostCard(
      {Key? key,
      required this.activityName,
      required this.postText,
      required this.likes,
      required this.authorName,
      required this.showName,
      required this.docID,
      required this.image})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

OurTheme _theme = OurTheme();
late double _width;

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width * 0.96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: widget.image == "a"
                    ? SizedBox()
                    : Container(
                        child: Image.network(
                        widget.image,
                        fit: BoxFit.contain,
                      ))),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: _width * 0.6,
                    child: _buildText(
                        "", widget.activityName, 20, FontWeight.w600)),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  if (!widget.showName)
                    Container(
                        alignment: Alignment.centerRight,
                        width: _width * 0.2,
                        child: _buildText(
                            "- ", widget.authorName, 14, FontWeight.normal)),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    _buildText(
                        "", widget.likes.toString(), 16, FontWeight.normal),
                    const SizedBox(
                      width: 5,
                    ),
                    LikeButton(onTap: onLikeButtonTapped),
                  ]),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _buildText("", widget.postText, 16, FontWeight.normal),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    isLiked ? await decreaseLikes() : await increaseLikes();
    return !isLiked;
  }

  increaseLikes() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docID)
        .update({'likes': widget.likes + 1});
  }

  decreaseLikes() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docID)
        .update({'likes': widget.likes - 1});
  }

  Widget _buildText(
      String s1, String bookTitle, double fontSize, FontWeight fontWeight) {
    return Text(
      s1 + bookTitle,
      style: TextStyle(
          fontSize: fontSize, color: Colors.black, fontWeight: fontWeight),
    );
  }
}
