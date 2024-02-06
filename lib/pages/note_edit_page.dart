import 'package:notes/model/notes.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/notes_database.dart';
import '../widgets/note_form_Widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  bool? isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    if (isImportant == null) {
      isImportant = false;
    } else {
      isImportant = widget.note?.isImportant == 0 ? false : true;
    }

    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant??false,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextButton(
        // style: ElevatedButton.styleFrom(
        //   foregroundColor: Colors.white,
        //   backgroundColor: isFormValid ? null : Colors.grey.shade700,
        // ),
        onPressed: addOrUpdateNote,
        child: Text('Save', style: TextStyle(color: isFormValid ? Colors.white : Colors.grey.shade400),),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid == true) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note?.copy(
      isImportant: isImportant!=null && isImportant! ? 1 : 0,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.update(note!);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant!=null && isImportant! ? 1 : 0,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
