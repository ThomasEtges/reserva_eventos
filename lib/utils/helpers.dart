import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String plain, {String salt = 'app-eventos-salt'}) {
  final bytes = utf8.encode('$salt::$plain');
  return sha256.convert(bytes).toString();
}
