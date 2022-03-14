import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'ResetPasswordPage.dart';
import 'SignUpPage.dart';
import 'UserPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  late List<ParseObject> userDetails = [];

  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  Future<List<ParseObject>> getUserObject() async {
    var currentUser = await getUser();
    if(currentUser != null){
      QueryBuilder<ParseObject> queryBook =
      QueryBuilder<ParseObject>(ParseObject('User'))
        ..whereEqualTo('objectId', currentUser.objectId.toString());
      final ParseResponse apiResponse = await queryBook.query();

      if (apiResponse.success && apiResponse.results != null) {
        userDetails = apiResponse.results as List<ParseObject>;
        return apiResponse.results as List<ParseObject>;
      } else {
        return [];
      }
    }
    else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: FutureBuilder<ParseUser?>(
          future: getUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()
                  ),
                );
              default:

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: controllerUsername,
                        enabled: !isLoggedIn,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Username'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: controllerPassword,
                        enabled: !isLoggedIn,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelText: 'Password'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Login'),
                          onPressed: isLoggedIn ? null : () => doUserLogin(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Sign Up'),
                          onPressed: () => navigateToSignUp(),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ));
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      navigateToUser();
    } else {
      Message.showError(context: context, message: response.error!.message);
    }
  }

  void navigateToUser() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
          (Route<dynamic> route) => false,
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
}