import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property date dateTime
    property bool isNew

    canAccept: !dateTimeValidationLabel.visible

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width

            DialogHeader { title: isNew ? qsTr("Add reminder") : qsTr("Edit reminder") }

            ValueButton {
                width: parent.width
                label: qsTr("Date").concat(": ")
                value: dateTime.getTime() > 0 ? Qt.formatDate(dateTime, "dd MMM yyyy") : qsTr("Select")
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
                                                { date: dateTime.getTime() === 0 ? 'undefined' : dateTime });
                    dialog.accepted.connect(function() {
                        updateDateTime(dialog.date.getFullYear(), dialog.date.getMonth(),
                                       dialog.date.getDate(), dateTime.getHour(),
                                       dateTime.getMinutes());
                    });
                }
            }

            ValueButton {
                width: parent.width
                label: qsTr("Time").concat(": ")
                value: dateTime.getTime() > 0 ? Qt.formatTime(dateTime, "hh:mm") : qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog",
                                                { hour: dateTime.getHours(), minute: dateTime.getMinutes() });
                    dialog.accepted.connect(function() {
                        updateDateTime(dateTime.getFullYear(), dateTime.getMonth(),
                                       dateTime.getDate(), dialog.hour, dialog.minute);
                    });
                }
            }

            Label {
                id: dateTimeValidationLabel
                visible: dateTime.getTime() > 0 && dateTime < new Date()
                text: qsTr("The reminder datetime must follow the current datetime")
                color: Qt.rgba(1.0, 0.3, 0.3, 1)
                wrapMode: Text.Wrap
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
            }

            Button {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                text: qsTr("Clear reminder")
                visible: dateTime.getTime() > 0
                onClicked: {
                    dateTime = new Date(0);
                    accept();
                }
            }
        }
    }

    function updateDateTime(year, month, dayOfMonth, hour, minute) {
        dateTime = new Date(year, month, dayOfMonth, hour, minute, 0, 0);
    }

    Component.onCompleted: {
        if (dateTime.getTime() === 0) {
            dateTime = new Date();
            isNew = true;
        }
    }
}
