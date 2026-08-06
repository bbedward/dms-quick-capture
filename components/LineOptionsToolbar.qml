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

    property string currentStyle: "solid"
    property string toolbarPosition: "top"

    signal styleSelected(string style)

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

            // Group: Line Styles (Solid, Dashed, Dotted)
            Repeater {
                model: [
                    { icon: "line_weight", style: "solid", tooltip: I18n.tr("Solid Line") },
                    { icon: "border_style", style: "dashed", tooltip: I18n.tr("Dashed Line") },
                    { icon: "more_horiz", style: "dotted", tooltip: I18n.tr("Dotted Line") }
                ]

                delegate: OptionToolbarButton {
                    iconName: modelData.icon
                    active: root.currentStyle === modelData.style
                    onClicked: {
                        root.styleSelected(modelData.style);
                        root.close();
                    }
                }
            }
        }
    }
}
