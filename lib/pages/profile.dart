import 'package:flutter/widgets.dart';
import 'package:presto/pages/login.dart';
// import 'package:presto/pages/register.dart';
 
class Profile extends StatefulWidget {
  const Profile({super.key});
 
  @override
  State<Profile> createState() => _HomeState();
}
 
class _HomeState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // return const Center(child: RegisterPage());
    return const Center(child: LoginPage());
  }
}