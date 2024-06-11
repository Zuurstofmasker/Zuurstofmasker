import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/navHelper.dart';
import 'package:zuurstofmasker/Models/note.dart';
import 'package:zuurstofmasker/Widgets/buttons.dart';
import 'package:zuurstofmasker/Widgets/inputFields.dart';
import 'package:zuurstofmasker/Widgets/paddings.dart';
import 'package:zuurstofmasker/Widgets/popups.dart';
import 'package:zuurstofmasker/config.dart';
import 'package:video_player/video_player.dart';

Future<List<Note>> getVideoNotes(String sessionID) async {
  return await getListFromFile(
      "$sessionPath$sessionID/videoNotes.json", Note.fromJson);
}

List<Widget> calcThumbs(
    VideoPlayerValue value,
    String sessionID,
    double progressBarWidth,
    ValueNotifier<List<Note>> noteList,
    VideoPlayerController controller,
    BuildContext context) {
  final List<Widget> thumbWidgetList = [];

  // Iterate over each note and calculate its position
  for (Note note in noteList.value) {
    final double left = note.noteTime.inMilliseconds /
        value.duration.inMilliseconds *
        progressBarWidth;

    thumbWidgetList.add(
      Positioned(
        left: left - 5,
        top: -5,
        child: GestureDetector(
          onTap: () {
            controller.seekTo(note.noteTime);
            controller.pause();
            showNote(note, sessionID, noteList, context);
          },
          child: Container(
            width: 10.0, // Thumb width
            height: 20.0, // Thumb height
            decoration: const BoxDecoration(
              color: dangerColor,
              shape: BoxShape.rectangle,
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }
  return thumbWidgetList;
}

void addNote(String sessionID, Duration time,
    ValueNotifier<List<Note>> noteList, context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      actions: [
        Button(
          onTap: () => Navigator.pop(context),
          text: "Sluiten",
        ),
        Button(
          onTap: () async {
            if (formKey.currentState!.validate()) {
              PopupAndLoading.showLoading();
              noteList.value.add(Note(
                  id: const Uuid().v4(),
                  noteTime: time,
                  description: descriptionController.text,
                  title: titleController.text));
              noteList.notifyListeners();
              try {
                await appendItemToListFile(noteList.value.last,
                    "$sessionPath$sessionID/videoNotes.json", Note.fromJson);
                PopupAndLoading.showSuccess("Notitie opgeslagen");
                Navigator.pop(context);
              } catch (e) {
                print(e);
                PopupAndLoading.showError("Notitie is niet opgeslagen");
              }
              PopupAndLoading.endLoading();
            }
          },
          text: "Opslaan",
        ),
      ],
      title: const Text("Notitie toevoegen"),
      content: IntrinsicHeight(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const PaddingSpacing(),
              InputField(
                controller: titleController,
                hintText: "Titel",
              ),
              const PaddingSpacing(),
              InputField(
                controller: descriptionController,
                hintText: "Beschrijving",
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> deleteNote(
    Note note, String sessionID, ValueNotifier<List<Note>> noteList) async {
  final String path = "$sessionPath$sessionID/videoNotes.json";
  noteList.value =
      noteList.value.where((whereNote) => note.id != whereNote.id).toList();
  await writeListToFile(noteList.value, path);
}

void showNote(Note note, String sessionID, ValueNotifier<List<Note>> noteList,
    BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      actions: [
        Button(
          onTap: () async {
            PopupAndLoading.showLoading();
            try {
              await deleteNote(note, sessionID, noteList);
              PopupAndLoading.showSuccess("Notitie verwijderd");
              Navigator.pop(context);
            } catch (e) {
              print(e);
              PopupAndLoading.showError("Notitie verwijderd mislukt");
            }
            PopupAndLoading.endLoading();
          },
          text: "Verwijderen",
          color: dangerColor,
        ),
        Button(
          onTap: () => Navigator.pop(context),
          text: "Sluiten",
        )
      ],
      title: Text(note.title),
      content: Text(note.description),
    ),
  );
}
