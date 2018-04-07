import QtQuick 2.0
import Sailfish.Silica 1.0

import "../persistence"

Page {

    SilicaListView {

        id: noteListView
        anchors.fill: parent

        VerticalScrollDecorator {}

        header: PageHeader {
            title: qsTr("Notes")
        }

        model: NoteListModel {
            id: noteListModel
        }

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
        }
    }

    Component.onCompleted: refreshNoteList()

    NotesDao { id: dao }

    function refreshNoteList() {
        noteListModel.clear();
        dao.retrieveAllNotes(function(notes) {
            for (var i = 0; i < notes.length; i++) {
                noteListModel.addNote(notes.item(i));
            }
        });
    }
}
