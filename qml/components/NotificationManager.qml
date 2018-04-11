import QtQuick 2.0
import Nemo.Notifications 1.0
import Nemo.DBus 2.0

Item {

    property var timers

    Component {
        id: timerComponent

        Timer {
            property int noteId
            property string summary
            property string body

            id: timer
            onTriggered: {
                notification.replacesId = noteId;
                notification.summary = summary;
                notification.previewSummary = summary;
                notification.body = body;
                notification.previewBody = body;
                notification.publish();
                removeNotification(noteId);
            }
        }
    }

    Notification {
         id: notification
         category: "x-nemo.notifications.sailnotes"
         remoteActions: [
             {
                 "name": "default",
                 "service": "org.fruct.yar.sailnotes",
                 "path": "/org/fruct/yar/sailnotes",
                 "iface": "org.fruct.yar.sailnotes",
                 "method": "openApp"
            }
         ]
    }

    DBusAdaptor {
        service: 'org.fruct.yar.sailnotes'
        iface: 'org.fruct.yar.sailnotes'
        path: '/org/fruct/yar/sailnotes'
        xml: '  <interface name="org.fruct.yar.sailnotes">\n' +
             '    <method name="openApp"/>\n' +
             '  </interface>\n'

        function openApp() {
            activate();
        }
    }

    function scheduleNotification(noteId, summary, body, reminderTimestamp) {
        var timerInterval = reminderTimestamp - new Date().getTime();
        var timer = timerComponent.createObject(appWindow,
                                                {noteId: noteId, summary:summary, body: body,
                                                interval: timerInterval});
        if (noteId in timers) removeNotification(noteId);
        timers[noteId] = timer;
        timers[noteId].start();
    }

    function removeNotification(noteId) {
        if (timers[noteId] !== undefined) {
            timers[noteId].stop();
        }
        delete timers[noteId];
    }

    Component.onCompleted: {
        timers = {};
        dao.retrieveAllNotes(function(rows) {
            for (var i = 0; i < rows.length; i++) {
                var note = rows.item(i);
                if (note.reminderTimestamp > new Date().getTime()) {
                    scheduleNotification(note.id, note.title, note.description,
                                         note.reminderTimestamp);
                }
            }
        });
    }
}
