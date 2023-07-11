import 'package:flutter/material.dart';
import 'package:products_app/ui/Input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 250,),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),

                    _LoginForm()
                  ],
                )
              ),
              SizedBox(height: 50,),
              Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ),
        )
      )
    );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        //TODO: mantener la referencia al KEY
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(hintText: 'Email', labelText: 'Correo electronico', prefixIcon: Icons.alternate_email_sharp),
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                ? null
                :'Correo invalido';

              },
            ),
            SizedBox(height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecorations.authInputDecoration(hintText: '****', labelText: 'Contraseña', prefixIcon: Icons.lock),
              validator: (value) {
                return(value!=null && value.length>=6) 
                ? null
                : 'La contraseña debe de ser de 6 caracteres';

              },
            ),
            
            SizedBox(height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.green,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white),
                )
              ),
              onPressed: () {
                //TODO: login form
              },
            ),
            SizedBox(height: 30,),
          ]
        ),
      ),
    );
  }
}


// String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
 
// RegExp regExp  = new RegExp(pattern);