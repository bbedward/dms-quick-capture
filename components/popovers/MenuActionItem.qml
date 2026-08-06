import QtQuick
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    property string iconName: ""
    property string text: ""

    signal activated()

    width: parent ? parent.width : 0
    height: 32
    radius: Theme.cornerRadius - 2
    color: mouseArea.containsMouse ? Theme.withAlpha(Theme.primary, 0.15) : "transparent"

    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingS
        anchors.rightMargin: Theme.spacingS
        spacing: Theme.spacingS
        anchors.verticalCenter: parent.verticalCenter

        DankIcon {
            name: root.iconName
            size: 16
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: root.text
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }
}
