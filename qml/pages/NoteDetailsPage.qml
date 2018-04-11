import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {

    id: page

    property string title
    property string description
    property string picturePaths
    property double reminderTimestamp
    property string audioFilePath

    SilicaFlickable {

        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            anchors {
                left: parent.left; right: parent.right
            }
            spacing: Theme.paddingMedium

            PageHeader {
                anchors {
                    left: parent.left; right: parent.right
                }
                title: qsTr("Details")
            }

            Label {
                id: reminderLabel
                anchors {
                    left: parent.left; right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                text: qsTr("Reminder").concat(": ")
                      + Qt.formatDateTime(new Date(reminderTimestamp), "dd MMM yyyy hh:mm")
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                visible: reminderTimestamp > 0
            }
            Label {
                id: titleLabel
                anchors {
                    left: parent.left; right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                text: title
                font.pixelSize: Theme.fontSizeExtraLarge
                wrapMode: Text.Wrap
            }
            Text {
                id: descriptionLabel
                anchors {
                    left: parent.left; right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                text: description
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                wrapMode: Text.Wrap
            }
            AudioPlayer {
                id: audioPlayer
                anchors {
                    left: parent.left; right: parent.right
                }
                audioFilePath: page.audioFilePath
                visible: audioFilePath.length > 0
                allowRecording: false
            }
            SilicaListView {
                id: imageListView
                anchors {
                    left: parent.left; right: parent.right
                }
                height: listModel.count === 0 ? 0 : contentHeight
                spacing: Theme.paddingSmall
                model: ListModel { id: listModel }
                delegate: Image {
                    anchors {
                        left: parent.left; right: parent.right
                    }
                    fillMode: Image.PreserveAspectFit
                    source: picturePath
                }
                Component.onCompleted: {
                    picturePaths.split(",").forEach(function(path) {
                        listModel.append({picturePath: path});
                    });
                }
            }
        }
    }
}
