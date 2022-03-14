import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'LoginPage.dart';
import 'ResetPasswordPage.dart';

class UserPage extends StatelessWidget {
  ParseUser? currentUser;

  UserPage({Key? key}) : super(key: key);

  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    void doUserLogout() async {
      var response = await currentUser!.logout();
      if (response.success) {
        Message.showSuccess(
            context: context,
            message: 'User was successfully logout!',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
              );
            });
      } else {
        Message.showError(context: context, message: response.error!.message);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Management'),
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
                        child: CircularProgressIndicator()),
                  );
                default:
                  return Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text('Welcome to SuperChef! ${snapshot.data!.username}')),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            child: const Text('Logout'),
                            onPressed: () => doUserLogout(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            child: const Text('Reset Password'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ResetPasswordPage(email: snapshot.data!.emailAddress!)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
              }
            }));
  }
}