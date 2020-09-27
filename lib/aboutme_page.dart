import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjoon/data.dart';
import 'package:devjoon/user.dart';
import 'package:flutter/material.dart';

class AboutMePage extends StatefulWidget {
  AboutMePage({Key key}) : super(key: key);

  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final _formKey = GlobalKey<FormState>();
  bool _userExists = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About me')),
      body: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(kUserId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            User user;
            var data = snapshot.data.data();
            if (data != null) {
              user = User.fromJson(snapshot.data.data());
              _userExists = true;
            } else {
              user = User(
                  id: kUserId,
                  question1: '',
                  question2: '',
                  question3: '',
                  question4: '');
            }
            TextEditingController _question1 =
                TextEditingController(text: user.question1);
            TextEditingController _question2 =
                TextEditingController(text: user.question2);
            TextEditingController _question3 =
                TextEditingController(text: user.question3);
            TextEditingController _question4 =
                TextEditingController(text: user.question4);
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    buildTextFormField(context, '1. Name-Surname', _question1),
                    SizedBox(height: 16),
                    buildTextFormField(
                        context, '2. Where do you live?', _question2),
                    SizedBox(height: 16),
                    buildTextFormField(
                        context, '3. Which Workshop do you go to?', _question3),
                    SizedBox(height: 16),
                    buildTextFormField(
                        context,
                        '4. Which products are you producing(bags, packages)',
                        _question4),
                    SizedBox(height: 16),
                    Builder(builder: (context) {
                      return MaterialButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text('Submit'),
                        onPressed: () async {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            // _formKey.currentState.save();
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                            user.question1 = _question1.value.text;
                            user.question2 = _question2.value.text;
                            user.question3 = _question3.value.text;
                            user.question4 = _question4.value.text;
                            try {
                              if (_userExists) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(kUserId)
                                    .update(user.toJson());
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(kUserId)
                                    .set(
                                        user.toJson(), SetOptions(merge: true));
                              }
                              Navigator.pop(context);
                            } catch (e) {
                              print(e);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Something went wrong')));
                            }
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
    );
  }

  TextFormField buildTextFormField(
    BuildContext context,
    String labelText,
    TextEditingController _question1,
  ) {
    return TextFormField(
        maxLines: null,
        controller: _question1,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 2),
          ),
          labelText: labelText,
        ),
        autovalidate: true,
        validator: (_value) =>
            _value.isEmpty ? 'Please enter some text' : null);
  }
}
