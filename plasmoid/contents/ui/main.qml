import QtCore
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property string showCommand: String(StandardPaths.writableLocation(StandardPaths.HomeLocation)).replace("file://", "") + "/.local/bin/linux-plasma-keyboard-toggle"

    Plasmoid.icon: "input-keyboard"
    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("Virtual Keyboard")
    toolTipSubText: i18n("Click to show the on-screen keyboard")

    function showKeyboard() {
        runner.connectSource(showCommand)
    }

    P5Support.DataSource {
        id: runner
        engine: "executable"
        connectedSources: []
        onNewData: function (source, data) {
            disconnectSource(source)
        }
    }

    compactRepresentation: MouseArea {
        id: compact
        implicitWidth: Kirigami.Units.gridUnit * 1.5
        implicitHeight: Kirigami.Units.gridUnit * 1.5
        hoverEnabled: true
        onClicked: root.showKeyboard()

        Rectangle {
            anchors.fill: parent
            radius: Kirigami.Units.cornerRadius
            color: Kirigami.Theme.highlightColor
            opacity: compact.pressed ? 0.5 : (compact.containsMouse ? 0.25 : 0)

            Behavior on opacity {
                NumberAnimation { duration: Kirigami.Units.shortDuration }
            }
        }

        Kirigami.Icon {
            anchors.fill: parent
            anchors.margins: Math.round(Math.min(compact.width, compact.height) * 0.18)
            source: "input-keyboard"
        }
    }

    fullRepresentation: ColumnLayout {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.minimumHeight: Kirigami.Units.gridUnit * 6
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.Button {
            Layout.alignment: Qt.AlignHCenter
            icon.name: "input-keyboard"
            text: i18n("Show keyboard")
            onClicked: root.showKeyboard()
        }
    }
}
