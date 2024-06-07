import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  var bytes = utf8.encode(password); // Convert password to bytes
  var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
  return digest.toString(); // Convert the digest to a string
}
