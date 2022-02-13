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
    return InkWell(
      child: Center(
        child: Container(
          width: _width * 0.96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
                decoration: BoxDecoration(
                    color: _theme.tertiaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        width: 1.5,
                        color: _theme.tertiaryColor.withOpacity(0.4))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.image == "a"
                          ? SizedBox()
                          : Container(
                              height: 400,
                              width: 300,
                              child: Image.network(widget.image)),
                      _buildBookTitle(widget.postText),
                      if (!widget.showName)
                        _buildRichText("By: ", widget.authorName),
                      _buildRichText("Likes: ", widget.likes.toString()),
                      LikeButton(onTap: onLikeButtonTapped),
                    ],
                  ),
                )),
          ),
        ),
      ),
      onTap: () {},
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

  Widget _buildBookTitle(String bookTitle) {
    return Text(
      bookTitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22.0,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRichText(String text1, String text2) {
    return RichText(
      text: TextSpan(
          text: text1,
          style: TextStyle(
            color: _theme.secondaryColor,
            fontWeight: FontWeight.w600,
          ),
          children: <TextSpan>[
            TextSpan(
                text: text2,
                style: const TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.w400)),
          ]),
    );
  }
}
