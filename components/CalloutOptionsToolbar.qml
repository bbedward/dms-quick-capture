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

    property int currentLinkLines: 1
    property string currentShape: "rect"
    property string toolbarPosition: "top"

    signal linkLinesSelected(int count)
    signal shapeSelected(string shape)

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

            // Row 1: Shape (Rectangle, Ellipse)
            Row {
                id: shapeRow
                spacing: Theme.spacingS
                Repeater {
                    model: [
                        { icon: "crop_square", shape: "rect", tooltip: I18n.tr("Rectangle") },
                        { icon: "circle", shape: "ellipse", tooltip: I18n.tr("Ellipse") }
                    ]
                    delegate: OptionToolbarButton {
                        iconName: modelData.icon
                        active: root.currentShape === modelData.shape
                        onClicked: {
                            root.shapeSelected(modelData.shape);
                            root.close();
                        }
                    }
                }
            }

            // Row 2: Connecting Lines (1 Line, 2 Lines)
            Row {
                id: linesRow
                spacing: Theme.spacingS
                Repeater {
                    model: [
                        { icon: "remove", count: 1, tooltip: I18n.tr("1 Connecting Line") },
                        { icon: "density_medium", count: 2, tooltip: I18n.tr("2 Connecting Lines") }
                    ]
                    delegate: OptionToolbarButton {
                        iconName: modelData.icon
                        active: root.currentLinkLines === modelData.count
                        onClicked: {
                            root.linkLinesSelected(modelData.count);
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
