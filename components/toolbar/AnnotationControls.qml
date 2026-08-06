import QtQuick
import qs.Common
import qs.Widgets
import "../core/Constants.js" as Constants

Item {
    id: control

    property string currentTool: "select"
    property bool showAnnotations: true
    property bool compact: false

    signal toolSelected(string tool)
    signal annotationsToggled()

    width: compact ? Constants.btnSize : content.implicitWidth
    height: compact ? content.implicitHeight : Constants.btnSize

    Flow {
        id: content
        width: control.compact ? Constants.btnSize : implicitWidth
        spacing: Theme.spacingXS
        anchors.centerIn: parent

        DankActionButton {
            iconName: "near_me"
            buttonSize: Constants.btnSize
            iconSize: Constants.iconSize
            tooltipText: "Select (Tab)"
            backgroundColor: control.currentTool === "select" ? Theme.withAlpha(Theme.primary, 0.15) : "transparent"
            iconColor: control.currentTool === "select" ? Theme.primary : Theme.surfaceText
            onClicked: control.toolSelected("select")
        }

        DankActionButton {
            iconName: control.showAnnotations ? "visibility" : "visibility_off"
            buttonSize: Constants.btnSize
            iconSize: Constants.iconSize
            tooltipText: control.showAnnotations ? "Hide Annotations (X)" : "Show Annotations (X)"
            iconColor: control.showAnnotations ? Theme.primary : Theme.surfaceText
            backgroundColor: "transparent"
            onClicked: control.annotationsToggled()
        }

        DankActionButton {
            iconName: "crop"
            buttonSize: Constants.btnSize
            iconSize: Constants.iconSize
            tooltipText: "Crop (Ctrl+X)"
            backgroundColor: control.currentTool === "crop" ? Theme.withAlpha(Theme.primary, 0.15) : "transparent"
            iconColor: control.currentTool === "crop" ? Theme.primary : Theme.surfaceText
            onClicked: control.toolSelected("crop")
        }
    }
}
