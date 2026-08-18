import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property string object: "org.kde.KWin /VirtualKeyboard org.kde.kwin.VirtualKeyboard"
    readonly property string readCommand: "busctl --user get-property " + object + " visible"
    readonly property string watchCommand: "sh -c \"gdbus monitor --session --dest org.kde.KWin --object-path /VirtualKeyboard | grep -m1 -E 'visibleChanged|activeChanged'\""
    readonly property string showCommand: "busctl --user call " + object + " forceActivate"
    readonly property string hideCommand: "sh -c \"busctl --user set-property " + object + " active b false; busctl --user set-property " + object + " active b true\""

    property bool keyboardVisible: false

    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("Virtual Keyboard")
    toolTipSubText: keyboardVisible ? i18n("Visible - click to hide") : i18n("Hidden - click to show")

    P5Support.DataSource {
        id: runner
        engine: "executable"
        connectedSources: []

        onNewData: function (source, data) {
            disconnectSource(source)
            if (source === root.readCommand) {
                root.keyboardVisible = (data["stdout"] || "").indexOf("true") !== -1
                connectSource(root.watchCommand)
            } else {
                connectSource(root.readCommand)
            }
        }
    }

    Component.onCompleted: runner.connectSource(readCommand)

    compactRepresentation: MouseArea {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        hoverEnabled: true

        Kirigami.Icon {
            anchors.fill: parent
            source: root.keyboardVisible ? "input-keyboard-virtual-on" : "input-keyboard-virtual-off"
            active: parent.containsMouse
        }

        onClicked: runner.connectSource(root.keyboardVisible ? root.hideCommand : root.showCommand)
    }
}
