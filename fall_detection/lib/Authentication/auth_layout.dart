import 'package:fall/Authentication/authService.dart';
import 'package:fall/FallDetected.dart';
import 'package:fall/LoginPage.dart';
import 'package:flutter/cupertino.dart';

class AuthLayout extends StatelessWidget{
  const AuthLayout({
    super.key,
    this.pageIsNotConnected,
});

  final Widget? pageIsNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: authService,
        builder: (context, authService, child){
          return StreamBuilder(
              stream: authService.authStateChanges,
              builder: (context, snapshot) {
                Widget widget;
                  if(snapshot.hasData){
                    widget = SensorHomePage();
                  }
                  else{
                    widget = pageIsNotConnected ?? LoginPage();
                  }
                  return widget;
              });
        });
  }
}
