import 'package:flutter/material.dart';
import 'package:mynote_application/view/mynote_screen.dart';
import 'package:mynote_application/database/sql_helper.dart';

import '../model/user.dart'; // Import StudentScreen

// void main() {
//   runApp(const MaterialApp(
//     home: LoginPage(),
//   ));
// }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showSignIn = true;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  Future<void> _refreshUser() async {
    final data = await SQLHelper.getUsers();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyNote_Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In / Sign Up'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showSignIn = true;
                    });
                  },
                  child: const Text('Sign In'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showSignIn = false;
                    });
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          _showSignIn ? SignInForm(signInSuccess: _signInSuccess) : SignUpForm(refreshUser: _refreshUser),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final Function refreshUser; // Callback to refresh user list after sign up

  SignUpForm({Key? key, required this.refreshUser}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int _selectedGender = 0; // 0: Male, 1: Female

  Future<void> _createUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Password and Confirm Password do not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await SQLHelper.createUser(User(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        gender: _selectedGender,
      ));
      widget.refreshUser(); // Refresh user list after adding new user

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('User registered successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      //After register success
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _emailController.clear();
    } catch (err) {
      debugPrint("create user error: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Gender: '),
                Radio(
                  value: 0,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value as int;
                    });
                  },
                ),
                const Text('Male'),
                Radio(
                  value: 1,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value as int;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Sign Up'),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
          ],
        ),
      ),
    );
  }
}


class SignInForm extends StatefulWidget {
  final Function signInSuccess; // Callback function

  const SignInForm({super.key, required this.signInSuccess});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () async {
              List<Map<String, dynamic>> users = await SQLHelper.getUsers();

              bool isAuthenticated = false;
              for (var user in users) {
                if (user['username'] == _usernameController.text &&
                    user['password'] == _passwordController.text) {
                  isAuthenticated = true;
                  break;
                }
              }

              if (isAuthenticated) {
                widget.signInSuccess(); // Call the callback to navigate to StudentScreen
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Invalid username or password.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
