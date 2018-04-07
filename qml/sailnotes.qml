import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "persistence"
import harbour.sailnotes 1.0

ApplicationWindow
{
    id: appWindow
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    FileHelper { id: fileHelper }
    NoteListModel { id: noteListModel }
    NotesDao { id: dao }

    function openAddNoteDialog() {
        var note = {
            title: "", description: "", picturePaths: "",
            audioFilePath: "", reminderTimestamp: 0
        };
        var dialog = pageStack.push(Qt.resolvedUrl("dialogs/EditNoteDialog.qml"), {note: note});
        dialog.accepted.connect(function() {
            var noteId = dao.createNote(dialog.note, function(noteId) {
                dialog.note.id = noteId;
                noteListModel.addNote(dialog.note);
            });
        });
    }
}
