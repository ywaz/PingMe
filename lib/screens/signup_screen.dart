import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingMe/bloc/signup_cubit.dart';
import 'package:pingMe/bloc/signup_state.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/models/form_validators.dart' as formz;
import 'package:pingMe/screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const String route = '/SignUpScreen';

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _userNameController = TextEditingController();
    TextEditingController _pwdController = TextEditingController();
    TextEditingController _pwdConfirmationController = TextEditingController();

    Size size = MediaQuery.of(context).size;
    return BlocProvider<SignUPCubit>(
        create: (context) => SignUPCubit(
            RepositoryProvider.of<AuthenticationRepository>(context)),
        child: Scaffold(
            body: BlocListener<SignUPCubit, SignUpState>(
                listener: (context, state) {
                  if (state.status == formz.FormStatus.signUpSuccesfull) {
                    Scaffold.of(context)..showSnackBar(SnackBar(
                      
                      content: Text('Account Created'),
                      backgroundColor: Colors.green,
                    ));
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pushReplacementNamed('/');
                    
                  } else if (state.status == formz.FormStatus.signUpFailure) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Account Creation Failure'),
                      elevation: 5,
                    ));
                  }
                },
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.only(top: size.height / 6),
                        width: size.width * 5 / 7,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            UserNameBuilder(
                                userNameController: _userNameController),
                            SizedBox(
                              height: 5,
                            ),
                            EmailBuilder(emailController: _emailController),
                            SizedBox(height: 5),
                            PWDBuilder(pwdController: _pwdController),
                            SizedBox(height: 5),
                            PWDConfirmBuilder(
                                pwdConfirmationController:
                                    _pwdConfirmationController,
                                pwdController: _pwdController),
                            SizedBox(height: 5),
                            SubmissionBuilder(
                                emailController: _emailController,
                                userNameController: _userNameController,
                                pwdController: _pwdController,
                                pwdConfirmationController:
                                    _pwdConfirmationController),
                            FlatButton(
                                child: Text('Sign In'),
                                textColor: Colors.blueGrey[700],
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed(LoginScreen.route))
                          ],
                        ))))));
  }
}

class SubmissionBuilder extends StatelessWidget {
  const SubmissionBuilder({
    Key key,
    @required TextEditingController emailController,
    @required TextEditingController userNameController,
    @required TextEditingController pwdController,
    @required TextEditingController pwdConfirmationController,
  })  : _emailController = emailController,
        _userNameController = userNameController,
        _pwdController = pwdController,
        _pwdConfirmationController = pwdConfirmationController,
        super(key: key);

  final TextEditingController _emailController;
  final TextEditingController _userNameController;
  final TextEditingController _pwdController;
  final TextEditingController _pwdConfirmationController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUPCubit, SignUpState>(
        buildWhen: (previousState, currentState) =>
            previousState.status != currentState.status,
        builder: (context, state) {
          return (state.status == formz.FormStatus.signUpRequested)
              ? Center(child: CircularProgressIndicator())
              : FlatButton(
                  onPressed: () async {
                    if (state.status != formz.FormStatus.invalidEmail &&
                        state.status != formz.FormStatus.invalidPwd &&
                        state.status != formz.FormStatus.invalidUserName &&
                        state.status != formz.FormStatus.notMatching &&
                        _emailController.text.isNotEmpty &&
                        _userNameController.text.isNotEmpty &&
                        _pwdController.text.isNotEmpty &&
                        _pwdConfirmationController.text.isNotEmpty) {
                      await context.bloc<SignUPCubit>().createAccount(
                          _emailController.text,
                          _userNameController.text,
                          _pwdController.text);
                    }
                  },
                  child: Text('Sign Up'),
                );
        });
  }
}

class PWDConfirmBuilder extends StatelessWidget {
  const PWDConfirmBuilder({
    Key key,
    @required TextEditingController pwdConfirmationController,
    @required TextEditingController pwdController,
  })  : _pwdConfirmationController = pwdConfirmationController,
        _pwdController = pwdController,
        super(key: key);

  final TextEditingController _pwdConfirmationController;
  final TextEditingController _pwdController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUPCubit, SignUpState>(
      buildWhen: (previousState, currentState) =>
          previousState.status != currentState.status,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              flex: 4,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: _pwdConfirmationController,
                decoration: InputDecoration(
                  labelText: 'Password Confirmation',
                  errorText: state.status == formz.FormStatus.notMatching
                      ? 'Unmatched pwd'
                      : null,
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) => context
                    .bloc<SignUPCubit>()
                    .checkInput(_pwdController.text, 'pwdValidation', value),
              ),
            ),
            if (state.status == formz.FormStatus.validPwdConfirmation)
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}

class PWDBuilder extends StatelessWidget {
  const PWDBuilder({
    Key key,
    @required TextEditingController pwdController,
  })  : _pwdController = pwdController,
        super(key: key);

  final TextEditingController _pwdController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUPCubit, SignUpState>(
      buildWhen: (previousState, currentState) =>
          previousState.status != currentState.status,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              flex: 4,
              child: TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: state.status == formz.FormStatus.invalidPwd
                      ? 'Invalid Password'
                      : null,
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) =>
                    context.bloc<SignUPCubit>().checkInput(value, 'pwd'),
              ),
            ),
            if (state.status == formz.FormStatus.validPwd)
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}

class EmailBuilder extends StatelessWidget {
  const EmailBuilder({
    Key key,
    @required TextEditingController emailController,
  })  : _emailController = emailController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUPCubit, SignUpState>(
        buildWhen: (previousState, currentState) =>
            previousState.status != currentState.status,
        builder: (context, state) {
          return Row(
            children: [
              Flexible(
                flex: 4,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: state.status == formz.FormStatus.invalidEmail
                        ? 'Invalid Email'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) =>
                      context.bloc<SignUPCubit>().checkInput(value, 'email'),
                ),
              ),
              if (state.status == formz.FormStatus.validEmail)
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                  ),
                )
            ],
          );
        });
  }
}

class UserNameBuilder extends StatelessWidget {
  const UserNameBuilder({
    Key key,
    @required TextEditingController userNameController,
  })  : _userNameController = userNameController,
        super(key: key);

  final TextEditingController _userNameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUPCubit, SignUpState>(
      buildWhen: (previousState, currentState) =>
          previousState.status != currentState.status,
      builder: (context, state) {
        return Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  errorText: state.status == formz.FormStatus.emptyInput
                      ? 'Empty User Name'
                      : null,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) =>
                    context.bloc<SignUPCubit>().checkInput(value, 'userName'),
              ),
            ),
            if (state.status == formz.FormStatus.validuserName)
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
