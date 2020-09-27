import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devjoon/ask_question_page.dart';
import 'package:devjoon/data.dart';
import 'package:devjoon/question.dart';
import 'package:devjoon/aboutme_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImageCoding;

class HandcraftPage extends StatefulWidget {
  HandcraftPage({Key key}) : super(key: key);

  @override
  _HandcraftPageState createState() => _HandcraftPageState();
}

class _HandcraftPageState extends State<HandcraftPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DevJoon'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Code: " + kUserId),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'About Me',
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutMePage(),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(kUserId)
                          .collection('questions')
                          .orderBy('createdAt')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator();
                        List<Question> questions = snapshot.data.docs
                            .map((e) => Question.fromJson(e.data()))
                            .toList();
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              Question question = questions[index];
                              return ListTile(
                                title: Text(question.question),
                                subtitle: question.answer != null
                                    ? Text(question.answer)
                                    : null,
                              );
                            },
                          ),
                        );
                      })),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 100,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(kUserId)
                          .collection('images')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator();
                        List<String> images = snapshot.data.docs
                            .map<String>((e) => e.data()['imageUrl'] as String)
                            .toList();
                        print(images);
                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              VerticalDivider(),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            String image = images[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                imageUrl: image,
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'Ask Question',
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AskQuestionPage(),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => MaterialButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          'Take Picture',
                        ),
                        onPressed: () async {
                          PickedFile image = await ImagePicker()
                              .getImage(source: ImageSource.gallery);
                          String imageUrl =
                              await _uploadImage(File(image.path));
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(kUserId)
                                .collection('images')
                                .add({'imageUrl': imageUrl});
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Image send')));
                          } catch (e) {
                            print(e);
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Something went wrong')));
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> _uploadImage(File image) async {
  if (image != null) {
    final StorageReference _storage = FirebaseStorage.instance.ref();
    StorageUploadTask _uploadTask;
    String _milliSeconds = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath =
        'users/$kUserId/images/${kUserId + '_' + _milliSeconds}.png';
    ImageCoding.Image _image =
        ImageCoding.decodeImage(await image.readAsBytes());
    _uploadTask =
        _storage.child(filePath).putData(ImageCoding.encodePng(_image));
    await _uploadTask.onComplete;
    String downloadUrl = await _uploadTask.lastSnapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
