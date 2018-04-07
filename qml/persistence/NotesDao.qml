import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {

    property var db

    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("sailnotes", "1.0");
        createNotesTable();
    }

    function createNotesTable() {
        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS notes ("
                + "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                + "title TEXT NOT NULL, description TEXT DEFAULT '', picturePaths TEXT DEFAULT '', "
                + "audioFilePath TEXT DEFAULT '', reminderTimestamp INTEGER DEFAULT 0);");
        });
    }

    function createNote(note, callback) {
        db.transaction(function(tx) {
            var results = tx.executeSql("INSERT INTO notes ("
                            + "title, description, picturePaths, audioFilePath, reminderTimestamp) "
                            + "VALUES(?, ?, ?, ?, ?)",
                            [note.title, note.description, note.picturePaths, note.audioFilePath,
                             note.reminderTimestamp]);
            callback(parseInt(results.insertId));
        });
    }

    function updateNote(note) {
        db.transaction(function(tx) {
            var results = tx.executeSql("UPDATE notes "
                        + "SET title = ?, description = ?, picturePaths = ?, audioFilePath = ?, "
                        + "reminderTimestamp = ? WHERE id = ?",
                          [note.title, note.description, note.picturePaths, note.audioFilePath,
                           note.reminderTimestamp, note.id]);
        });
    }

    function deleteNote(id) {
        db.transaction(function(tx) {
            tx.executeSql("DELETE FROM notes WHERE id = ?", [id]);
        });
    }

    function retrieveAllNotes(callback) {
        db.readTransaction(function(tx) {
            var result = tx.executeSql("SELECT * FROM notes ORDER BY id DESC;");
            callback(result.rows);
        });
    }
}
