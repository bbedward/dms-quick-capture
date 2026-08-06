import QtQuick
import qs.Common
import "Constants.js" as Constants

Item {
    id: root
    z: 2000
    anchors.fill: parent

    property bool visibleState: false
    visible: opacity > 0
    opacity: 0

    property real menuX: 0
    property real menuY: 0

    // States for options
    property bool boldActive: false
    property bool italicActive: false
    property bool underlineActive: false
    property bool backgroundActive: false
    property string toolbarPosition: "top"

    signal boldToggled()
    signal italicToggled()
    signal underlineToggled()
    signal backgroundToggled()

    states: [
        State {
            name: "visible"
            when: root.visibleState
            PropertyChanges { target: root; opacity: 1.0 }
            PropertyChanges { target: menuContent; scale: 1.0 }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: root; property: "opacity"; duration: 120; easing.type: Easing.OutQuad }
            NumberAnimation { target: menuContent; property: "scale"; duration: 120; easing.type: Easing.OutQuad }
        }
    ]

    function open(x, y) {
        root.menuX = x;
        root.menuY = y;
        root.visibleState = true;
    }

    function close() {
        root.visibleState = false;
    }

    // Scrim overlay to dismiss when clicking outside
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: (mouse) => {
            root.close();
            mouse.accepted = false;
        }
    }

    OptionToolbarPanel {
        id: menuContent
        popupRoot: root
        width: contentRow.implicitWidth + Theme.spacingM * 2
        height: Constants.subToolbarHeight
        
        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: Theme.spacingS

            Repeater {
                model: [
                    { icon: "format_bold", active: root.boldActive, tag: "bold" },
                    { icon: "format_italic", active: root.italicActive, tag: "italic" },
                    { icon: "format_underlined", active: root.underlineActive, tag: "underline" },
                    { icon: "layers", active: root.backgroundActive, tag: "bg" }
                ]

                delegate: OptionToolbarButton {
                    iconName: modelData.icon
                    active: modelData.active
                    onClicked: {
                        if (modelData.tag === "bold") root.boldToggled();
                        else if (modelData.tag === "italic") root.italicToggled();
                        else if (modelData.tag === "underline") root.underlineToggled();
                        else if (modelData.tag === "bg") root.backgroundToggled();
                    }
                }
            }
        }
    }
}
