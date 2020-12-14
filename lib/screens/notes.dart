import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live_pharmacy/constants/styles.dart';
import 'package:live_pharmacy/provider/notesProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController _notes = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<NotesProvider>(context, listen: false).fetchNotes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: notesProvider.isLoading,
        child: Container(
          padding: EdgeInsets.all(20),
          width: size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  height: size.height * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextFormField(
                                        controller: _notes,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 1)),
                                          isDense: true,
                                          hintText: 'Write note here ...',
                                        ),
                                        maxLines: 4,
                                        minLines: 4,
                                      ),
                                      Container(
                                        width: 200,
                                        child: FlatButton(
                                          onPressed: () async {
                                            await notesProvider.addNote(_notes.value.text.trim());
                                            Navigator.pop(context);
                                            await notesProvider.fetchNotes();
                                          },
                                          child: Text(
                                            'Add Note',
                                            style: kWhiteButtonTextStyle,
                                            maxLines: 1,
                                          ),
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                        '+    NEW',
                        style: kWhiteButtonTextStyle,
                        maxLines: 1,
                      ),
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    flex: 3,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Upcoming reminders',
                        style: kWhiteButtonTextStyle,
                        maxLines: 1,
                      ),
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: notesProvider.notesList.length > 0 ? notesProvider.notesList.length : 0,
                  itemBuilder: (context, index) {
                    var note = notesProvider.notesList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.date.day.toString() + '/' + note.date.month.toString() + '/' + note.date.year.toString(),
                            style: kBlueTextStyle,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Text(note.note, style: kAppbarButtonTextStyle),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 125,
                                child: FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Set a reminder',
                                    style: kWhiteButtonTextStyle,
                                    maxLines: 1,
                                  ),
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 40,
                                child: FlatButton(
                                  onPressed: () async {
                                    await notesProvider.deleteNote(note.docId);
                                    await notesProvider.fetchNotes();
                                  },
                                  child: Icon(FontAwesomeIcons.trash, color: Colors.white, size: 15),
                                  color: kCancelButtonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
