import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/portfolio_info.dart';

class PortfolioService {
  static PortfolioInfo? _info;

  static PortfolioInfo get info {
    assert(_info != null, 'PortfolioService.initialize() must be called before use');
    return _info!;
  }

  static Future<void> initialize() async {
    final jsonString =
        await rootBundle.loadString('assets/data/portfolio_info.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    _info = PortfolioInfo.fromJson(data);
  }
}
