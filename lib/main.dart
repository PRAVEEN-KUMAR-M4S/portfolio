import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/portfolio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PortfolioService.initialize();
  runApp(const PortfolioApp());
}
