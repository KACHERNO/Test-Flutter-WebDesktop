import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/bloc/auth_bloc.dart';


class LoginApative extends StatelessWidget {
  const LoginApative({super.key});

  String getPlatformInfo() {
    String platform  = '';
    const  isWebJS   = bool.fromEnvironment('dart.library.js_util');
    const  isWebWasm = bool.fromEnvironment('dart.tool.dart2wasm');

    if (isWebJS || isWebWasm) {
      platform = isWebWasm ? 'WEB (WebAssembly)' : 'WEB (JavaScript)';
    } else {
      platform = '${Platform.operatingSystem}: ${Platform.operatingSystemVersion}';
    }
    return 'Платформа $platform';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Row(
       children: 
       <Widget>[
          if (MediaQuery.of(context).size.width > 600)
          Flexible(
              flex: 3,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(getPlatformInfo(), style: TextStyle(fontSize: 10,color: Theme.of(context).colorScheme.onPrimary),),
                  )),
              )),
          
          Flexible(
              flex: 5,
              child: 
                MediaQuery.of(context).size.width > 600 ?
                const LoginWidget() : const Center(child: LoginWidget())
                ),
        ],
      ),
    );
  }
}

class LoginWidget extends StatefulWidget{
  const LoginWidget({super.key}) ;

  

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
  }
  
class _LoginWidgetState extends State<LoginWidget> {

  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

  return 

  SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20,20,20,20),
      child: SizedBox(
        width: 320,
        height: 600,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            //
            //
            //
            children: <Widget>[
              //MediaQuery.of(context).size.width < 600 ?
              SizedBox(
                height: 100, 
                width: 320, 
                child: Align(
                  alignment: MediaQuery.of(context).size.width < 600 ?  Alignment.center : Alignment.bottomLeft,
                  child: 
                    Text('Мини-ITIL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32, color: Theme.of(context).colorScheme.primary ), )
                    ), ),
            //
            //
            //              
            SizedBox(
              width: 320,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = RegExp(pattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'Введине корректный Email...';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Пароль"),
                    validator: (value) {
                      return value!.length < 4
                          ? "Длина пароля не менее 4 символов..."
                          : null;
                    },
                    obscureText: true,
                  ),
      
          const SizedBox(height: 60),
          
          Align(
            alignment: MediaQuery.of(context).size.width < 600 ?
            Alignment.center : Alignment.bottomLeft,
            child: FilledButton(
              onPressed: () {
              if (formKey.currentState!.validate()) {
                BlocProvider.of<AuthBloc>(context).add(SignIn(emailController.text, passwordController.text));
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
                )
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8,8,8,8),
                child: Text('Вход', style:  TextStyle(fontSize: 24), ),
              ) ,
                
              ),
          ),
          //
          //
          //
          const SizedBox(height: 40),
          //
          //
          //
          Row( 
            mainAxisAlignment: MediaQuery.of(context).size.width < 600 ?  MainAxisAlignment.center : MainAxisAlignment.start,
            children: <Widget>[
              OutlinedButton(
                style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
                )
              ),
                child: const Text('Tom'), 
                onPressed: () { 
                emailController.text    = 'tom@gmail.com';
                passwordController.text = '1qaz!QAZ1qaz';
              },),
              const SizedBox(width: 5,),
              OutlinedButton(
                style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2)
                )
              ),
                onPressed: () { 
                emailController.text    = 'ivan@mail.ru';
                passwordController.text = 'Topaz108_Chernov';
              },
                child: const Text('Ivan'),)
            ]
          ),
                  const SizedBox(height: 40)
      
      
              ],
            ),
          ),
                ],
              ),
            ),
        ),
    ),
    );

//  );


  }
}
