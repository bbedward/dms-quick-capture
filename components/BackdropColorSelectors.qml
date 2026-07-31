import QtQuick
import qs.Common
import qs.Widgets
import "Constants.js" as Constants

Grid {
    id: controlRoot

    property string backdropMode: "none"
    property color backdropSolidColor: Theme.primary
    property color backdropGradientStart: Theme.primary
    property color backdropGradientEnd: Theme.secondary
    property string gradientActiveSlot: "start"
    property int itemSize: 24
    property int iconSize: 18
    property bool isVertical: false
    property bool imageBlurEnabled: false
    property bool imageDimEnabled: false
    property int imageDimStrength: 28

    signal setGradientActiveSlot(string slot)
    signal autoColorBalanceRequested()
    signal colorPickerRequested(color currentColor)
    signal eyedropperRequested(string slot)
    signal imageBlurToggled(bool enabled)
    signal imageDimToggled(bool enabled)
    signal imageDimControlHovered(var controlItem)
    signal imageDimControlExited()
    signal imageDimControlWheel(int delta)

    columns: isVertical ? 1 : 4
    spacing: isVertical ? 10 : Theme.spacingXS
    anchors.verticalCenter: isVertical ? undefined : parent.verticalCenter
    anchors.horizontalCenter: isVertical ? parent.horizontalCenter : undefined

    Item {
        visible: controlRoot.backdropMode === "solid"
        width: Constants.verticalSelectorItemWidth
        height: controlRoot.itemSize

        Rectangle {
            width: controlRoot.itemSize; height: controlRoot.itemSize; radius: controlRoot.itemSize / 2
            color: controlRoot.backdropSolidColor
            border.color: Theme.withAlpha(Theme.outline, 0.3)
            border.width: 1
            anchors.centerIn: parent

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton) {
                        controlRoot.eyedropperRequested("solid")
                    } else {
                        controlRoot.colorPickerRequested(controlRoot.backdropSolidColor)
                    }
                }
            }
        }
    }

    Item {
        visible: controlRoot.backdropMode === "image"
        width: Constants.verticalSelectorItemWidth
        height: controlRoot.itemSize

        DankActionButton {
            anchors.centerIn: parent
            buttonSize: controlRoot.itemSize
            iconName: "blur_on"
            iconSize: controlRoot.iconSize
            backgroundColor: controlRoot.imageBlurEnabled ? Theme.withAlpha(Theme.primary, 0.18) : "transparent"
            iconColor: controlRoot.imageBlurEnabled ? Theme.primary : Theme.surfaceText
            tooltipText: I18n.tr("Blur Backdrop Image")
            onClicked: controlRoot.imageBlurToggled(!controlRoot.imageBlurEnabled)
        }
    }

    Item {
        id: imageDimControl
        visible: controlRoot.backdropMode === "image"
        width: controlRoot.isVertical ? Constants.verticalSelectorItemWidth : dimHorizontalContent.implicitWidth + Theme.spacingXS * 2
        height: controlRoot.isVertical ? 40 : controlRoot.itemSize

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerRadiusSmall
            color: controlRoot.imageDimEnabled ? Theme.withAlpha(Theme.primary, 0.18) :
                   (dimMouse.containsMouse ? Theme.withAlpha(Theme.surfaceText, 0.08) : "transparent")
        }

        Row {
            id: dimHorizontalContent
            visible: !controlRoot.isVertical
            anchors.centerIn: parent
            spacing: Theme.spacingXS

            DankIcon {
                name: "dark_mode"
                size: controlRoot.iconSize
                color: controlRoot.imageDimEnabled ? Theme.primary : Theme.surfaceText
            }

            StyledText {
                text: controlRoot.imageDimStrength + "%"
                font.pixelSize: Theme.fontSizeSmall
                color: controlRoot.imageDimEnabled ? Theme.primary : Theme.surfaceText
            }
        }

        Column {
            visible: controlRoot.isVertical
            anchors.centerIn: parent
            spacing: 1

            DankIcon {
                name: "dark_mode"
                size: controlRoot.iconSize
                color: controlRoot.imageDimEnabled ? Theme.primary : Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: controlRoot.imageDimStrength + "%"
                font.pixelSize: Theme.fontSizeSmall - 2
                color: controlRoot.imageDimEnabled ? Theme.primary : Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            id: dimMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                const enabled = !controlRoot.imageDimEnabled;
                controlRoot.imageDimToggled(enabled);
                if (enabled) controlRoot.imageDimControlHovered(imageDimControl);
                else controlRoot.imageDimControlExited();
            }
            onEntered: {
                if (controlRoot.imageDimEnabled) controlRoot.imageDimControlHovered(imageDimControl);
            }
            onExited: controlRoot.imageDimControlExited()
            onWheel: (wheel) => {
                controlRoot.imageDimControlWheel(wheel.angleDelta.y);
                wheel.accepted = true;
            }
        }
    }

    readonly property bool isGradient: backdropMode === "gradient" || backdropMode === "radial" || backdropMode === "conic"

    Item {
        visible: controlRoot.isGradient
        width: controlRoot.isVertical ? Constants.verticalSelectorItemWidth : (controlRoot.itemSize * 2 + Theme.spacingXS)
        height: controlRoot.isVertical ? (controlRoot.itemSize * 2 + Theme.spacingXS) : controlRoot.itemSize

        Grid {
            columns: controlRoot.isVertical ? 1 : 2
            spacing: Theme.spacingXS
            anchors.centerIn: parent

            Rectangle {
                width: controlRoot.itemSize; height: controlRoot.itemSize; radius: controlRoot.itemSize / 2
                color: controlRoot.backdropGradientStart
                border.color: controlRoot.gradientActiveSlot === "start" ? Theme.primary : Theme.withAlpha(Theme.outline, 0.3)
                border.width: controlRoot.gradientActiveSlot === "start" ? (controlRoot.itemSize >= 24 ? 2 : 1.5) : 1
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        controlRoot.setGradientActiveSlot("start")
                        if (mouse.button === Qt.RightButton) {
                            controlRoot.eyedropperRequested("start")
                        }
                    }
                }
            }
            Rectangle {
                width: controlRoot.itemSize; height: controlRoot.itemSize; radius: controlRoot.itemSize / 2
                color: controlRoot.backdropGradientEnd
                border.color: controlRoot.gradientActiveSlot === "end" ? Theme.primary : Theme.withAlpha(Theme.outline, 0.3)
                border.width: controlRoot.gradientActiveSlot === "end" ? (controlRoot.itemSize >= 24 ? 2 : 1.5) : 1
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: (mouse) => {
                        controlRoot.setGradientActiveSlot("end")
                        if (mouse.button === Qt.RightButton) {
                            controlRoot.eyedropperRequested("end")
                        }
                    }
                }
            }
        }
    }

    Item {
        visible: controlRoot.backdropMode !== "image"
        width: Constants.verticalSelectorItemWidth
        height: controlRoot.itemSize

        DankActionButton {
            anchors.fill: parent
            iconName: "colorize"
            iconSize: controlRoot.iconSize
            backgroundColor: "transparent"
            iconColor: Theme.surfaceText
            tooltipText: I18n.tr("Pick Color")
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: (mouse) => {
                let col = controlRoot.backdropMode === "solid" ? controlRoot.backdropSolidColor :
                          (controlRoot.gradientActiveSlot === "start" ? controlRoot.backdropGradientStart : controlRoot.backdropGradientEnd);
                let targetSlot = controlRoot.backdropMode === "solid" ? "solid" : controlRoot.gradientActiveSlot;
                if (mouse.button === Qt.RightButton) {
                    controlRoot.eyedropperRequested(targetSlot)
                } else {
                    controlRoot.colorPickerRequested(col)
                }
            }
        }
    }

    Item {
        visible: controlRoot.backdropMode !== "image"
        width: Constants.verticalSelectorItemWidth
        height: controlRoot.itemSize

        DankActionButton {
            buttonSize: controlRoot.itemSize
            iconName: "auto_awesome"
            iconSize: controlRoot.iconSize
            backgroundColor: "transparent"
            iconColor: Theme.surfaceText
            tooltipText: I18n.tr("Auto Balance")
            anchors.centerIn: parent
            onClicked: controlRoot.autoColorBalanceRequested()
        }
    }
}
