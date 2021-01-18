import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';

class CreateIdeaScreen extends StatefulWidget {
  CreateIdeaScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreateIdeaScreenState createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  TextEditingController _ideaTextFieldController = new TextEditingController();
  TextEditingController _ideaDescriptionController = new TextEditingController();
  bool _descriptionTextFieldVisible = false;

  void _showDescriptionTextField() {
    _descriptionTextFieldVisible = true;
    setState(() {});
  }

  void _cancel() {
    Navigator.pushNamedAndRemoveUntil(context, "/participantProjectScreen", (r) => false);
  }

  Future<void> _save() async {
    String ideaTitle = _ideaTextFieldController.text;
    if (ideaTitle == null || ideaTitle == '') return;
    int projectId = sharedPreferencesGetValue('project_id');
    int ideaId = await firestoreGetFieldValue('_projects_data', 'project_' + projectId.toString(), 'idea_id_counter');
    String authorInvitationCode = sharedPreferencesGetValue('invitation_code');
    DateTime _timestamp = new DateTime.now();

    String ideaDescriptionText = _ideaDescriptionController.text;
    Map firstComment = {
      'comment': ideaDescriptionText,
      'author_invitation_code': authorInvitationCode, //invitation_code
      'author_name': '', //invitation_code
      'commented_at': _timestamp,
    };
    List comments = ideaDescriptionText == '' ? [] : [firstComment];
    var _ideaData = {
      'id': ideaId,
      'title': _ideaTextFieldController.text,
      'url': '',
      'image_url': '',
      'author_invitation_code': authorInvitationCode,
      'author_name': '',
      'created_on': _timestamp,
      'comments': comments,
      'ratings': [],
    };
    bool _success = await firestoreWrite('project_' + projectId.toString(), 'idea_' + ideaId.toString(), _ideaData); //TODO
    if (!_success) {
      //TODO display error
      return;
    }

    ideaId+=1;
    _success = await firestoreWrite('_projects_data', 'project_' + projectId.toString(), {'idea_id_counter' : ideaId});
    if (_success) {
      Navigator.pushNamedAndRemoveUntil(context, "/participantProjectScreen", (r) => false);
    } else {
      //TODO display error
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add new idea'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _ideaTextFieldController,
                  autofocus: true,
                  maxLength: 70,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'idea',
                  ),
                ),
                SizedBox(height: 15),
                Visibility(
                  visible: !_descriptionTextFieldVisible,
                  child: FlatButton(
                    child: Text('add comment', style: TextStyle(color: Colors.black, fontSize: 18)),
                    onPressed: _showDescriptionTextField,
                  ),
                ),
                Visibility(
                  visible: _descriptionTextFieldVisible,
                  child: TextField(
                    controller: _ideaDescriptionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'comment',
                    ),
                  ),
                ),
                SizedBox(height: 35),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'save',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
