import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/auth.dart';

//enum AuthenticationMode { Signup, Login }

class AuthenticationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticationPageState();
  }
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final Map<String, dynamic> _formDate = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthenticationMode _authenticationMode = AuthenticationMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstOut),
      image: AssetImage('assets/716592_M.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          //labelText: 'Login',
          hintText: 'Enter your email id',
          filled: true,
          fillColor: Colors.white30),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formDate['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          //labelText: 'Password',
          hintText: 'Enter your Password',
          filled: true,
          fillColor: Colors.white30),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formDate['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          //labelText: 'Password',
          hintText: 'Confirm Password',
          filled: true,
          fillColor: Colors.white30),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Password Do Not Match';
        }
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formDate['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formDate['acceptTerm'] = value;
        });
      },
      title: Text('AcceptTerm'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formDate['acceptTerm']) {
      return;
    }

    _formKey.currentState.save();
    Map<String, dynamic> successInformation;

    successInformation =
        await authenticate(_formDate['email'], _formDate['password'],_authenticationMode);
    if (successInformation['success']) {
     // Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okey'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double devicewidth = MediaQuery.of(context).size.width;
    final double targetWidth = devicewidth > 786.0 ? 500.0 : devicewidth * 0.97;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      // title: Text('login'),

      // ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 9.0,
                    ),
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 15.0,
                    ),
                    _authenticationMode == AuthenticationMode.Signup
                        ? _buildPasswordConfirmTextField()
                        : Container(),
                    SizedBox(
                      height: 15.0,
                    ),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authenticationMode == AuthenticationMode.Login ? 'SignUp' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          _authenticationMode =
                              _authenticationMode == AuthenticationMode.Login
                                  ? AuthenticationMode.Signup
                                  : AuthenticationMode.Login;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isloading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                child: Text(_authenticationMode ==
                                        AuthenticationMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP'),
                                onPressed: () =>
                                    _submitForm(model.authenticate),
                              );
                      },
                    ),
                    //Divider(color: Colors.lime),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
