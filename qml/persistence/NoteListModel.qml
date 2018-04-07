import QtQuick 2.0

ListModel {

    function addNote(note) {
        append({id: note.id, title: note.title, description: note.description || "",
                   picturePaths: note.picturePaths || "", audioFilePath: note.audioFilePath || "",
                   reminderTimestamp: note.reminderTimestamp || 0});
    }

    function updateNote(index, note) {
        set(index,
            {
                title: note.title, description: note.description || "",
                picturePaths: note.picturePaths || "", audioFilePath: note.audioFilePath || "",
                reminderTimestamp: note.reminderTimestamp || 0
            });
    }
}
