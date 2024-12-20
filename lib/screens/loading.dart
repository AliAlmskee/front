// import 'package:babel/constant.dart';
// import 'package:babel/models/api_response.dart';
// import 'package:babel/screens/home.dart';
// // import 'package:babel/screens/login.dart';
// // import 'package:babel/services/user_service.dart';
// import 'package:flutter/material.dart';

// class Loading extends StatefulWidget {
//   const Loading({super.key});

//   @override
//   State<Loading> createState() => _LoadingState();
// }

// class _LoadingState extends State<Loading> {
//   void _loadUserInfo() async {
//     String token = await getToken();
//     if (!mounted) return;
//     if (token == '') {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => Login()), (route) => false);
//     } else {
//       ApiResponse response = await getUserDetail();
//       if (!mounted) return;
//       if (response.error == null) {
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => Home()), (route) => false);
//       } else if (response.error == unauthorized) {
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => Login()), (route) => false);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('${response.error}'),
//         ));
//       }
//     }
//   }

//   @override
//   void initState() {
//     // implement initState
//     super.initState();
//     _loadUserInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       color: Colors.white,
//       child: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
