import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/resources/auth_method.dart';

class UserProvider extends ChangeNotifier{

  final AuthMethods _authMethods = AuthMethods();
  Users? _users;
  Users get getUser => _users!;

  Future<void> refreshUser () async{
  Users users = await _authMethods.getUserDetails();
    _users=users;
    notifyListeners();
  }

}