import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/ui/Input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body:AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height*0.25,),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Login', style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),
                    
                    ChangeNotifierProvider(
                      create: (context) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
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

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        //TODO: mantener la referencia al KEY
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: loginForm.formKey,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(hintText: 'Email', labelText: 'Correo electronico', prefixIcon: Icons.alternate_email_sharp),
              onChanged: (value) => loginForm.email = value,
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
              onChanged: (value) => loginForm.password = value,
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
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                    ? 'Espere'
                    : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                )
              ),
              
              onPressed: loginForm.isLoading ? null : () async{
                
                FocusScope.of(context).unfocus();
                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                await Future.delayed(Duration(milliseconds: 5000));
                
                loginForm.isLoading = false;

                Navigator.pushNamed(context, 'home');
                
              },
            ),
            SizedBox(height: 30,),
          ]
        ),
      ),
    );
  }
}