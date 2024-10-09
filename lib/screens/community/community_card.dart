import 'package:flutter/material.dart';
import '../../models/community_model.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final String calendarTitle;
  final VoidCallback onTap;
  final VoidCallback onMoreOptionsTap;

  CommunityCard({
    required this.community,
    required this.calendarTitle,
    required this.onTap,
    required this.onMoreOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 358,
        height: 176,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: community.profileImage != "null"
                    ? NetworkImage(community.profileImage) as ImageProvider
                    : AssetImage("assets/icons/mypage_profile.png") as ImageProvider,
                radius: 27,
              ),
              SizedBox(height: 16.0),
              Text(
                community.calendarName,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                '${community.firstUploadedAt} ~ ${community.lastUploadedAt}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
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
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
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
            ],
          ),
        ),
      ),
    );
  }
}