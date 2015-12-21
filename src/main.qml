import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "ZimbleQ"

    Text {
        text: "Press \"Ctrl+O\" to open an image"
        color: "grey"
        anchors.centerIn: parent
    }

    Rectangle {
        id: imgFrame
        width: parent.width
        height: parent.height
        transform: Scale {
            id: imgFrameTransform
        }

        function reset() {
            imgFrame.x = 0
            imgFrame.y = 0
            imgFrameTransform.xScale = 1.0
            imgFrameTransform.yScale = 1.0
        }

        Image {
            id: img
            asynchronous: true
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
            smooth: true
            antialiasing: true
        }

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            drag.target: imgFrame
            onWheel: {
                if (wheel.angleDelta.y > 0 || (wheel.angleDelta.y <= 0 && imgFrameTransform.xScale > 1.0 && imgFrameTransform.yScale > 1.0)) {
                    var x = wheel.x * imgFrameTransform.xScale;
                    var y = wheel.y * imgFrameTransform.yScale;

                    var zoomFactor = 1.2
                    if (wheel.angleDelta.y <= 0)
                        zoomFactor = 1 / zoomFactor

                    imgFrame.x += (1 - zoomFactor) * x;
                    imgFrame.y += (1 - zoomFactor) * y;
                    imgFrameTransform.xScale *= zoomFactor;
                    imgFrameTransform.yScale *= zoomFactor;
                }
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: "File"

            MenuItem {
                text: "Open image..."
                shortcut: "Ctrl+O"
                onTriggered: fileDialog.open()
            }

            MenuItem {
                text: "Open in Google Image Search"
                shortcut: "Ctrl+G"
            }

            MenuItem {
                text: "Settings..."
            }

            MenuSeparator { }

            MenuItem {
                text: "Close"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "View"

            MenuItem {
                text: "Reset view"
                shortcut: "Ctrl+0"
                onTriggered: imgFrame.reset()
            }
        }

        Menu {
            title: "Help"

            MenuItem { text: "About" }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Choose an image"
        folder: shortcuts.home
        onAccepted: {
            imgFrame.reset()
            img.source = fileDialog.fileUrl
        }
        Component.onCompleted: visible = true
    }
}
