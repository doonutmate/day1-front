import 'package:flutter/material.dart';
import '../../models/community_model.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final String calendarTitle; // 캘린더 제목 추가
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;

  CommunityCard({
    required this.community,
    required this.calendarTitle, // 캘린더 제목 추가
    required this.onTap,
    required this.onMoreOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.transparent),
        ),
        elevation: 1.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 24,
                  ),
                  onPressed: onMoreOptionsTap,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: community.profileImage != "null" ? NetworkImage(community.profileImage) as ImageProvider : AssetImage("assets/icons/mypage_profile.png") as ImageProvider,
                    radius: 27,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    community.calendarName, // 캘린더 제목 사용
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${community.firstUploadedAt} ~ ${community.lastUploadedAt}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        community.memberName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '|',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '${community.totalCount}번의 기록',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}