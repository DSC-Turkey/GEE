import 'package:flutter/material.dart';

import './PostRate.dart';
import './IconLabel.dart';
import './ProfileButton.dart';
import '../../utils/markdown_formatter.dart';
import '../../utils/appPrefences.dart';
import '../../pages/post_page.dart';

class HomePost extends StatelessWidget {
  HomePost(
    this.id,
    this.mail,
    this.title,
    this.description,
    this.viewCount,
    this.commentCount,
    this.replied,
    this.upVote,
    this.downVote,
    this.userPic, {
    this.postPicURL,
  });

  String id;
  String mail;
  String title;
  String description;
  String viewCount;
  String commentCount;
  bool replied;
  String upVote;
  String downVote;
  String userPic;
  String postPicURL;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (this.postPicURL != "" && this.postPicURL != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Image.network(
                this.postPicURL,
                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                  return Image.asset("assets/pictures/non_photo.png");
                },
              ),
            ),
          ListTile(
            leading: ProfileButton(this.mail, this.mail == appPrefences.getString("mail") ? true : false),
            title: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(this.id, this.mail),
                  ),
                );
              },
              child: Text(
                this.title,
                style: TextStyle(fontFamily: "Montserrat"),
              ),
            ),
            trailing: PostRate(this.upVote, this.downVote),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 5),
              child: MarkdownFormatter(this.description),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconLabel(
                this.replied ? Icons.verified : Icons.history,
                this.replied ? "Yanıtlandı" : "Yanıt Bekliyor",
                iconColor: this.replied ? Colors.green : Colors.red,
              ),
              IconLabel(
                Icons.visibility,
                this.viewCount,
              ),
              IconLabel(
                Icons.comment,
                this.commentCount,
              ),
            ],
          )
        ],
      ),
    );
  }
}
