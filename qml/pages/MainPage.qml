import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    SilicaListView {

        PullDownMenu {
            MenuItem {
                text: qsTr("Add a new note")
                onClicked: openAddNoteDialog();
            }
        }

        id: noteListView
        anchors.fill: parent

        VerticalScrollDecorator {}

        header: PageHeader {
            title: qsTr("Notes")
        }

        model: noteListModel

        delegate: ListItem {

            id: listItem
            contentHeight: Theme.itemSizeSmall
            Item {
                id: noteItem
                height: listItem.contentHeight
                width: parent.width

                Label {
                    id: titleLabel
                    width: parent.width
                    anchors {
                        left: parent.left; right: parent.right; top: parent.top
                        leftMargin: Theme.paddingLarge
                    }
                    text: title
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                }
                Label {
                    id: descriptionLabel
                    anchors {
                        right: parent.right; left: parent.left; top: titleLabel.bottom
                        leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge
                    }
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: description
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                }
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Edit")
                    onClicked: {
                        var note =  {
                            id: id, title: title, description: description, picturePaths: picturePaths,
                            audioFilePath: audioFilePath, reminderTimestamp: reminderTimestamp
                        };
                        var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/EditNoteDialog.qml"),
                                                    {note: note});
                        dialog.accepted.connect(function() {
                            dao.updateNote(dialog.note);
                            noteListModel.updateNote(model.index, dialog.note);
                        });
                    }
                }
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        dao.deleteNote(id);
                        noteListModel.remove(model.index);
                    }
                }
            }
        }
    }

    Component.onCompleted: refreshNoteList()

    function refreshNoteList() {
        noteListModel.clear();
        dao.retrieveAllNotes(function(notes) {
            for (var i = 0; i < notes.length; i++) {
                noteListModel.addNote(notes.item(i));
            }
        });
    }
}
