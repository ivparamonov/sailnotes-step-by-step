import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    property string picturePath

    DialogHeader {
        id: header
        title: qsTr("Draw a picture")
    }

    Canvas {
        property real lastX
        property real lastY
        property bool filled: false

        id: canvas
        anchors {
            left: parent.left; right: parent.right
            top: header.bottom; bottom: parent.bottom
            margins: Theme.paddingLarge
        }
        onPaint: {
            var ctx = getContext('2d');
            if (status === PageStatus.Active && !filled) {
                ctx.fillStyle = Qt.rgba(1, 1, 1, 0.5);
                ctx.fillRect(0, 0, width, height);
                filled = true;
            }
            ctx.lineWidth = 5;
            ctx.strokeStyle = "black";
            ctx.beginPath();
            ctx.moveTo(lastX, lastY);
            lastX = area.mouseX;
            lastY = area.mouseY;
            ctx.lineTo(lastX, lastY);
            ctx.stroke();
        }
        MouseArea {
            id: area
            anchors.fill: parent
            onPressed: {
                canvas.lastX = mouseX;
                canvas.lastY = mouseY;
            }
            onPositionChanged: canvas.requestPaint()
        }
    }
    onDone: {
        if (result === DialogResult.Accepted) {
            picturePath = fileHelper.generatePictureFullPath();
            canvas.save(picturePath);
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active) {
            canvas.requestPaint();
        }
    }
}
