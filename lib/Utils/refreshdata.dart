// simulates data refresh delay for 2 seconds//
Future<void> refreshdata() async{
  await Future.delayed(Duration(seconds: 2));
}