import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pingMe/bloc/login_cubit.dart';
import 'package:pingMe/bloc/login_state.dart';
import 'package:pingMe/repository/authentication_repository.dart';
import 'package:pingMe/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String route= '/LoginScreen';
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _pwdController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          LoginCubit(RepositoryProvider.of<AuthenticationRepository>(context)),
      child: Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, LoginState state) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(top: size.height / 5),
                width: size.width * 5 / 7,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText:
                            (state is EmailNeeded) ? 'Invalid Email' : null,
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context.bloc<LoginCubit>().emailChanged(value);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _pwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText:
                            state == PWDNeeded() ? 'Invalid Password' : null,
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context.bloc<LoginCubit>().passwordChanged(value);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    (state is LoginRequested)
                        ? Center(child: CircularProgressIndicator())
                        : FlatButton(
                            onPressed: () {
                              if (_emailController.text.isNotEmpty &&
                                  _pwdController.text.isNotEmpty) {
                                context.bloc<LoginCubit>().signInWithEmail(
                                    _emailController.text, _pwdController.text);
                              }
                              if (state is LoginFailure) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  elevation: 5,
                                  backgroundColor: Colors.red,
                                  content: Text('Login Has Failed!'),
                                ));
                              }
                            },
                            child: Text('Login'),
                          ),
                          FlatButton(
                            
                            textColor: Colors.blueGrey[600],
                            child: Text('Create Account', ),
                            onPressed: ()=>Navigator.of(context).pushReplacementNamed(SignUpScreen.route))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
