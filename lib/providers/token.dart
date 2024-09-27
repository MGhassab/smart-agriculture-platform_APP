import 'package:flutter_riverpod/flutter_riverpod.dart';

//final tokenProvider = Provider((ref) => Token());
final tokenProvider = Provider.autoDispose<Token>(
  (ref) => Token(),
);

class Token {
  String token;
  Token({this.token = ''});
}
