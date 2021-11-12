import 'package:flutter/material.dart';
import 'package:jinglu_management/models/user.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    Key? key,
    required this.user,
    required this.subWidget
  }) : super(key: key);

  final User user;
  final Widget subWidget;



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
            image: AssetImage("images/placeholder.jpg"),
            width: 68,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color(0xFF263238),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: subWidget,
              )
            ],
          ),
        ),
        Spacer(),
        Icon(
          Icons.chevron_right_outlined,
          color: Color(0xFF263238),
        )
      ],
    );
  }
}