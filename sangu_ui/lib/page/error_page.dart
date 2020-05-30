import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBar(
            iconTheme: Theme.of(context).iconTheme,
            textTheme: Theme.of(context).textTheme,
            backgroundColor: Colors.transparent,
            titleSpacing: 26,
            elevation: 0,
            title: Text(
              "SANGU",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 26.0, right: 26.0),
              alignment: Alignment.center,
              child: Text(
                message,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
