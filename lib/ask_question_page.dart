import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjoon/data.dart';
import 'package:devjoon/question.dart';
import 'package:devjoon/user.dart';
import 'package:flutter/material.dart';

class AskQuestionPage extends StatefulWidget {
  AskQuestionPage({Key key}) : super(key: key);

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _question1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ask Querstion')),
      body:Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    buildTextFormField(context, 'What is your question?', _question1),
                    SizedBox(height: 16),
                    Builder(builder: (context) {
                      return MaterialButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            _formKey.currentState.save();
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                           try{ await FirebaseFirestore.instance
                                .collection('users')
                                .doc(kUserId).collection('questions')
                                .add(Question(question:_question1.value.text).toJson());
                            Navigator.pop(context);
                             } catch (e) {
                              print(e);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Something went wrong')));
                            }
                          }
                        },
                        child: Text('Submit'),
                      );
                    }),
                  ],
                ),
              )
            )
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
