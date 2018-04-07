import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property var note
    property string placeholder: qsTr("Enter the note description")
    property bool placeholderVisible: note.description.length === 0

    canAccept: titleTextField.text.length > 0

    SilicaFlickable {

        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                id: header
                width: parent.width
                title: note.title.length === 0 && note.description.length === 0
                       ? qsTr("Add a note") : qsTr("Edit the note")
            }

            TextField {
                id: titleTextField
                width: parent.width
                text: note.title
                labelVisible: true
                label: qsTr("Title:")
                placeholderText: qsTr("Enter the note title")
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: descriptionTextEdit.focus = true
            }

            TextEdit {
                x: Theme.paddingLarge
                id: descriptionTextEdit
                width: parent.width - Theme.paddingLarge
                text: placeholderVisible ? placeholder : note.description
                font.pixelSize: Theme.fontSizeMedium
                color: placeholderVisible ? Theme.secondaryColor : Theme.primaryColor
                wrapMode: TextEdit.Wrap
                onCursorPositionChanged: {
                    if (placeholderVisible) cursorPosition = 0;
                }
                onFocusChanged: {
                    if (focus) {
                        color = placeholderVisible ? Theme.secondaryHighlightColor : Theme.highlightColor;
                    } else {
                        color = placeholderVisible ? Theme.secondaryColor : Theme.primaryColor
                    }
                }
                onTextChanged: {
                    var rawText = descriptionTextEdit.getText(0, text.length);
                    if (focus && rawText !== placeholder && placeholderVisible) {
                        text = text.replace(placeholder, "");
                        color = Theme.highlightColor;
                        cursorPosition += 1;
                        placeholderVisible = false;
                    } else if (rawText.length === 0 && !placeholderVisible) {
                        text = placeholder;
                        color = Theme.secondaryHighlightColor;
                        placeholderVisible = true;
                    }
                }
            }
        }
    }

    onAccepted: {
        note.title = titleTextField.text;
        note.description = placeholderVisible ? "" : descriptionTextEdit.text;
    }
}
