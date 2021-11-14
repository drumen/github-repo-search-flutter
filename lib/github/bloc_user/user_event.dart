part of 'user_bloc.dart';

abstract class UserEvent {
}

class FetchUser extends UserEvent {
  FetchUser(this.userName);
  final String userName;
}
