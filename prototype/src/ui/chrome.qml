import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0

Window {
    id: root
    title: "FA Forever"
    width: 1024
    height: 768
    minimumWidth: 400
    minimumHeight: 300
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint
    color: "#111111"

    Action {
        id: closeWindow
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit();
    }

    Action {
        id: toggleDebug
        shortcut: "Ctrl+`"
        onTriggered: {
            if (debugWindow.state == "open") {
                debugWindow.state = "closed"
            } else {
                debugWindow.state = "open"
            }
        }
    }

    Action {
        id: toggleSideMenu
        shortcut: "Ctrl+D"
        onTriggered: {
            if (sideMenu.state == "open") {
                sideMenu.state = "closed"
            } else {
                sideMenu.state = "open"
            }
        }
    }

    Rectangle {
        id: borderResizeHook // use to allow resizing through edge drag - not implemented yet
        anchors.fill: parent
        border.width: root.visibility == Window.Maximized ? 0 : 1
        border.color: "#454545"
        color: "transparent"

        Item {
            id: topArea
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height

            MouseArea {
                id: topAreaMouseHandle
                anchors.fill: parent
                onDoubleClicked: root.visibility == Window.Maximized ? root.showNormal() : root.showMaximized()

                property variant previousPosition
                onPressed: {
                    previousPosition = Qt.point(mouseX, mouseY)
                }
                onPositionChanged: {
                    if (pressedButtons == Qt.LeftButton && root.visibility != Window.Maximized) {
                        var dx = mouseX - previousPosition.x
                        var dy = mouseY - previousPosition.y
                        root.x += dx
                        root.y += dy
                    }
                }
            }

            Image {
                id: actionIcon
                source: "icons/faf.png"
                sourceSize: Qt.size(24, 24)
                smooth: true
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.leftMargin: 2*5

                MouseArea {
                    anchors.fill: parent
                    onClicked: { toggleSideMenu.trigger() }
                }
            }

            Item {
                id: windowControls
                anchors.right: parent.right
                anchors.top: parent.top

                Row {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 5

                    Rectangle {
                        width: 26
                        height: 26
                        color: minimizeMouseArea.containsMouse ? "#454545" : "transparent"

                        Image {
                            source: "icons/minimize.svg"
                            sourceSize: Qt.size(10, 10)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            id: minimizeMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.showMinimized()
                        }
                    }

                    Rectangle {
                        width: 26
                        height: 26
                        color: maximizeMouseArea.containsMouse ? "#454545" : "transparent"

                        Image {
                            source: root.visibility == Window.Maximized ? "icons/restore.svg" : "icons/maximize.svg"
                            sourceSize: Qt.size(10, 10)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            id: maximizeMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.visibility == Window.Maximized ? root.showNormal() : root.showMaximized()
                        }
                    }

                    Rectangle {
                        width: 32
                        height: 26
                        color: closeMouseArea.containsMouse ? "#454545" : "transparent"

                        Image {
                            source: "icons/close.svg"
                            sourceSize: Qt.size(10, 10)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            id: closeMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: closeWindow.trigger(closeMouseArea)
                        }
                    }
                }
            }
        }

        Item {
            id: debugWindow
            anchors.top: topArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 5
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            height: 0.8*parent.height
            z: 1100
            state: "closed"
            states: [
                State {
                    name: "open"
                    PropertyChanges { target: debugWindow; visible: true }
                },
                State {
                    name: "closed"
                    PropertyChanges { target: debugWindow; visible: false }
                }
            ]


            TextArea {
                anchors.fill: parent
                frameVisible: false
                style: TextAreaStyle {
                    textColor: "#969696"
                    backgroundColor: "#2f2f2f"
                }
            }
        }

        Rectangle {
            id: sideMenu
            anchors.left: parent.left
            anchors.top: topArea.bottom
            anchors.bottom: bottomArea.top
            anchors.leftMargin: borderResizeHook.border.width
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            width: 32+2*5
            z: 1000
            color: root.color
            state: "closed"

            states: [
                State {
                    name: "open"
                    PropertyChanges { target: sideMenu; visible: true }
                },
                State {
                    name: "closed"
                    PropertyChanges { target: sideMenu; visible: false }
                }
            ]

            Column {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                property size sideMenuIconSize: Qt.size(42, 42)

                Image {
                    source: "icons/rss.svg"
                    sourceSize: parent.sideMenuIconSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "icons/lightbulb.svg"
                    sourceSize: parent.sideMenuIconSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "icons/point.svg"
                    sourceSize: parent.sideMenuIconSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "icons/world.svg"
                    sourceSize: parent.sideMenuIconSize
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Item {
            id: centralArea
            anchors.top: topArea.bottom
            anchors.bottom: bottomArea.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            Rectangle {
                id: centralWidget
                color: "#202025"
                anchors.fill: parent
            }
        }

        Item {
            id: bottomArea
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 5
            height: 13 // childrenRect.height // this reports binding loop for some reason

            Label {
                id: label
                text: model.label
                color: "#454545"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 2*5
            }

            Row {
                id: status
                visible: model.taskRunning
                anchors.right: resizer.left
                anchors.bottom: parent.bottom
                anchors.rightMargin: 2*5
                width: childrenRect.width
                spacing: 5

                Label {
                    id: actionLabel
                    text: model.taskStatusText
                    color: "#969696"
                }

                ProgressBar {
                    visible: !model.taskStatusIsIndefinite
                    width: visible ? 128 : 0
                    height: actionLabel.height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    value: model.taskStatusProgress
                    style: ProgressBarStyle {
                        background: Rectangle {
                            color: "transparent"
                            border.color: "#969696"
                            border.width: 1
                            implicitWidth: 200
                            implicitHeight: 24
                        }
                        progress: Rectangle {
                            color: "#969696"
                            border.color: "#969696"
                        }
                    }
                }
            }

            Image {
                id: resizer
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 5
                source: "icons/corner.svg"
                sourceSize: Qt.size(label.height, label.height)

                MouseArea {
                    anchors.fill: parent

                    property variant previousPosition
                    onPressed: {
                        previousPosition = Qt.point(mouseX, mouseY)
                    }
                    onPositionChanged: {
                        if (pressedButtons == Qt.LeftButton && root.visibility != Window.Maximized) {
                            var dx = mouseX - previousPosition.x
                            var dy = mouseY - previousPosition.y
                            root.width = Math.max(root.width + dx, root.minimumWidth)
                            root.height = Math.max(root.height + dy, root.minimumHeight)
                        }
                    }
                }
            }
        }
    }
}
