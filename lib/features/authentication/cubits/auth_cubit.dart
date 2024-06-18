import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/features/authentication/cubits/auth_states.dart';
import 'package:playhub/features/authentication/data/user_model.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit():super(AuthInitialState());
  String? name;
  String? email;
  String? phone;
  String? password;
  String? confirmPassword;
 void setName (String? value){
   name=value;
 }
  void setEmail (String? value){
    email=value;
  }
  void setPhone (String? value){
    phone=value;
  }
  void setPassword (String? value){
    password=value;
  }
  void setConfirmPassword (String? value){
    confirmPassword=value;
  }

  Future<void> registeration({required UserType type}) async {
   var user=UserModel(fullName:name, email:email, phoneNumber:phone, password:password, type:type, city:null, region:null);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email??"",
          password: password??"",
        ).then((UserCredential value){
          FirebaseFirestore.instance.collection('Users').add(user.toJson()).then((DocumentReference docRef) {
            log('DocumentSnapshot added with ID: ${docRef.id}');
          }).catchError((error) {
            log('Error adding document: $error');
          });
        });
        /*Fluttertoast.showToast(
          msg: "Successfully registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );*/
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );*/
      } on FirebaseAuthException catch (e) {
          log(e.message!);
        /*Fluttertoast.showToast(
          msg: e.code,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );*/
      }

  }
  Future<void> login() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email??"",
          password: password??"",
        );
        print("Doneeeeeeeee");
        // Fluttertoast.showToast(
        //   msg: "Successfully logged in!",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        // );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
      } on FirebaseAuthException catch (e) {
        // Fluttertoast.showToast(
        //   msg: e.code,
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        // );
      }

  }
}