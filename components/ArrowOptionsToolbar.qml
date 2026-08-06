import QtQuick
import qs.Common
import "Constants.js" as Constants
import "Helpers.js" as Helpers

Item {
    id: root
    z: 2000
    anchors.fill: parent

    property bool visibleState: false
    visible: opacity > 0
    opacity: 0

    property real menuX: 0
    property real menuY: 0

    property string currentLineStyle: "solid"
    property string currentHeadStyle: "single-filled"
    property string toolbarPosition: "top"

    signal lineStyleSelected(string style)
    signal headStyleSelected(string style)

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

    Rectangle {
        id: menuContent
        width: contentColumn.implicitWidth + Theme.spacingM * 2
        height: contentColumn.implicitHeight + Theme.spacingM * 2
        x: Helpers.popoverX(root.width, width, root.menuX)
        y: Helpers.popoverY(root.height, height, root.menuY, root.toolbarPosition)
        scale: 0.95

        color: Theme.surfaceContainer
        border.color: Theme.withAlpha(Theme.outline, 0.15)
        border.width: 1
        radius: Theme.cornerRadius
        
        Column {
            id: contentColumn
            anchors.centerIn: parent
            spacing: Theme.spacingS

            // Top Row: Arrow Head Styles (Filled, Open, Double)
            Row {
                id: headRow
                spacing: Theme.spacingS
                Repeater {
                    model: [
                        { icon: "trending_flat", style: "single-filled" },
                        { icon: "chevron_right", style: "single-open" },
                        { icon: "swap_horiz", style: "double-filled" }
                    ]

                    delegate: OptionToolbarButton {
                        iconName: modelData.icon
                        active: root.currentHeadStyle === modelData.style
                        onClicked: {
                            root.headStyleSelected(modelData.style);
                            root.close();
                        }
                    }
                }
            }

            // Horizontal Separator
            Rectangle {
                width: headRow.implicitWidth; height: 1
                color: Theme.withAlpha(Theme.outline, 0.15)
            }

            // Bottom Row: Line Styles (Solid, Dashed, Dotted)
            Row {
                id: lineRow
                spacing: Theme.spacingS
                Repeater {
                    model: [
                        { icon: "line_weight", style: "solid" },
                        { icon: "border_style", style: "dashed" },
                        { icon: "more_horiz", style: "dotted" }
                    ]

                    delegate: OptionToolbarButton {
                        iconName: modelData.icon
                        active: root.currentLineStyle === modelData.style
                        onClicked: {
                            root.lineStyleSelected(modelData.style);
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
