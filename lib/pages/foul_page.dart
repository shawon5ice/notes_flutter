import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/services/notes_database.dart';
import 'package:notes/model/notes.dart';
import 'package:notes/widgets/note_list_widget.dart';
import 'note_edit_page.dart';
import 'note_detail_page.dart';
import '../widgets/note_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/lif_cycle_handler.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  late List<Note> importantNotes;
  bool isLoading = false;
  bool isGrid = true;

  // TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
          refreshNotes();
        }), suspendingCallBack: () async {  },
      ),
    );
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isGrid = (prefs.getBool('grid') ?? true);

    this.notes = await NotesDatabase.instance.readAllNotes();
    this.importantNotes = await NotesDatabase.instance.readAllFavorite();

    setState(() => isLoading = false);
  }

  void onGridIconTap() async {
    setState(() {
      isGrid ? isGrid = false : isGrid = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('grid', isGrid);
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
              icon: Icon(isGrid ? Icons.list : Icons.grid_view),
              onPressed: onGridIconTap,
            ),
            SizedBox(width: 12)
          ],
        ),
        body: SafeArea(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : notes.isEmpty
                    ? Text(
                        'No Notes',
                        style: TextStyle(fontSize: 24),
                      )
                    : buildNotes(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => isGrid
      ? Column(
          children: [
            Container(
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                itemCount: importantNotes.length,
                staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  final note = importantNotes[index];

                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteDetailPage(noteId: note.id??-99),
                      ));
                      refreshNotes();
                    },
                    child: NoteCardWidget(note: note, index: index),
                  );
                },
              ),
            ),
            buildGeneralPadding(),
            Expanded(
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(8),
                itemCount: notes.length,
                staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteDetailPage(noteId: note.id??-99),
                      ));
                      refreshNotes();
                    },
                    child: NoteCardWidget(note: note, index: index),
                  );
                },
              ),
            ),
          ],
        )
      : Column(
          children: [
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: importantNotes.length,
                itemBuilder: (context, index) {
                  final note = importantNotes[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(noteId: note.id??-99),
                        ),
                      );
                      refreshNotes();
                    },
                    child: NoteListCardWidget(note: note, index: index),
                  );
                },
              ),
            ),
            notes.length > 0
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: buildGeneralPadding(),
                  )
                : SizedBox(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(noteId: note.id??-99),
                        ),
                      );
                      refreshNotes();
                    },
                    child: NoteListCardWidget(note: note, index: index),
                  );
                },
              ),
            )
          ],
        );

  Padding buildGeneralPadding() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'General Notes',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * .4,
              color: Colors.amber,
              height: 1,
            ),
          ],
        ));
  }
}
