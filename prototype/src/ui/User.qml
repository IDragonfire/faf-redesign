import QtQuick 2.2

Rectangle {
    id: wrapper
    anchors.verticalCenter: parent.verticalCenter
    anchors.rightMargin: 5
    width: childrenRect.width
    state: "closed"
    states: [
        State {
            name: "open"
            PropertyChanges { target: wrapper; color: background }
        },
        State {
            name: "closed"
            PropertyChanges { target: wrapper; color: mouseArea.containsMouse ? "#454545" : "transparent" }
        }
    ]

    property string background
    signal clicked

    Row {
        spacing: 5
        x: 5

        Text {
            text: "log in"
            anchors.verticalCenter: parent.verticalCenter
            color: "#969696"
        }

        Item {
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: "icons/user.svg"
                sourceSize: Qt.size(24, 24)
                anchors.centerIn: parent
            }
        }
        // ActionIcon {
        //     source: "icons/user.svg"
        //     size: 30
        //     anchors.verticalCenter: parent.verticalCenter
        // }
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onClicked: wrapper.clicked()
    }
}
