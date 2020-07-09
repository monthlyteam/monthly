import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';

class ProfileLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "로그인",
                style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  color: kTextColor,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            floating: true,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
