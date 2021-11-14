part of 'user_bloc.dart';

class UserState {
  const UserState({
    this.realName = '',
  });

  final String realName;

  UserState copyWith({
    String? realName,
  }) {
    return UserState(
      realName: realName ?? this.realName,
    );
  }

  @override
  String toString() {
    return '''UserState { realName: $realName }''';
  }
}
