import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String baserUrl = dotenv.get('BASEURL');
}

class ApiKey {
  static String currentPage = "";

  static String totalPages = "";

  static String totalItems = "";

  static String hasMorePage = "";

  static String message = "";

  static String statusCode = "";
}
