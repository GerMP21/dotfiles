// SDDM login screen in Tokyo Night colors (Qt 6, SDDM 0.21+).
// SDDM provides these objects: sddm (login, power), userModel, sessionModel,
// config (the [General] keys of theme.conf).
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1b26"

    readonly property color fg: "#c0caf5"
    readonly property color dim: "#a9b1d6"
    readonly property color accent: "#7aa2f7"
    readonly property color danger: "#f7768e"
    readonly property color field: "#24283b"
    readonly property string fontFamily: config.font || "sans-serif"

    property int userIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    readonly property string userName: currentUser ? currentUser.uName : userModel.lastUser
    readonly property string displayName: currentUser && currentUser.uReal !== "" ? currentUser.uReal : userName
    readonly property string userIcon: currentUser ? currentUser.uIcon : ""

    function login() {
        message.text = ""
        sddm.login(root.userName, password.text, root.sessionIndex)
    }

    // Reads the user list, to look up the selected user's name and picture.
    // A Repeater creates every item even while hidden (a zero-size ListView
    // would create none).
    Item {
        visible: false
        Repeater {
            id: users
            model: userModel
            delegate: Item {
                property string uName: model.name
                property string uReal: model.realName || ""
                property string uIcon: model.icon || ""
            }
        }
    }
    readonly property Item currentUser: users.count > 0 ? users.itemAt(Math.min(root.userIndex, users.count - 1)) : null

    Connections {
        target: sddm
        function onLoginFailed() {
            message.text = "Wrong password"
            password.text = ""
            password.forceActiveFocus()
        }
    }

    Image {
        anchors.fill: parent
        source: config.background ? Qt.resolvedUrl(config.background) : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
    }

    Rectangle {
        id: card
        width: 420
        height: column.implicitHeight + 64
        radius: 18
        color: "#cc1a1b26"
        border.color: "#3b4261"
        border.width: 1
        x: Math.min(Math.max(parent.width * (parseFloat(config.cardPosition) || 0.5) - width / 2, 24), parent.width - width - 24)
        anchors.verticalCenter: parent.verticalCenter

        Column {
            id: column
            anchors.centerIn: parent
            width: parent.width - 64
            spacing: 14

            Text {
                id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.fg
                font.family: root.fontFamily
                font.pixelSize: 64
                font.weight: Font.Light
                text: Qt.formatTime(new Date(), "HH:mm")
            }
            Text {
                id: date
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.dim
                font.family: root.fontFamily
                font.pixelSize: 16
                text: Qt.formatDate(new Date(), "dddd, d MMMM")
            }
            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: {
                    clock.text = Qt.formatTime(new Date(), "HH:mm")
                    date.text = Qt.formatDate(new Date(), "dddd, d MMMM")
                }
            }

            Item { width: 1; height: 6 }

            // Square profile picture, or the first letter of the name without one
            Rectangle {
                id: avatar
                width: 136; height: 136
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.field
                border.color: root.accent
                border.width: 3

                Image {
                    id: avatarImage
                    anchors.fill: parent
                    anchors.margins: parent.border.width
                    source: root.userIcon
                    sourceSize: Qt.size(256, 256)
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
                Text {
                    anchors.centerIn: parent
                    visible: avatarImage.status !== Image.Ready
                    color: root.fg
                    font.family: root.fontFamily
                    font.pixelSize: 56
                    text: root.displayName.charAt(0).toUpperCase()
                }
            }

            // Name, with arrows to switch user when there's more than one
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12
                Text {
                    visible: userModel.count > 1
                    color: root.dim; font.pixelSize: 20; text: "‹"
                    MouseArea { anchors.fill: parent; onClicked: root.userIndex = (root.userIndex + userModel.count - 1) % userModel.count }
                }
                Text {
                    color: root.fg
                    font.family: root.fontFamily
                    font.pixelSize: 22
                    text: root.displayName
                }
                Text {
                    visible: userModel.count > 1
                    color: root.dim; font.pixelSize: 20; text: "›"
                    MouseArea { anchors.fill: parent; onClicked: root.userIndex = (root.userIndex + 1) % userModel.count }
                }
            }

            TextField {
                id: password
                width: parent.width
                height: 44
                echoMode: TextInput.Password
                placeholderText: "Password"
                placeholderTextColor: "#565f89"
                color: root.fg
                font.family: root.fontFamily
                font.pixelSize: 16
                horizontalAlignment: TextInput.AlignHCenter
                focus: true
                background: Rectangle {
                    radius: 10
                    color: root.field
                    border.color: password.activeFocus ? root.accent : "#3b4261"
                    border.width: 2
                }
                Keys.onReturnPressed: root.login()
                Keys.onEnterPressed: root.login()
            }

            Text {
                id: message
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: root.danger
                font.family: root.fontFamily
                font.pixelSize: 14
                text: ""
                visible: text !== ""
                wrapMode: Text.Wrap
            }

            ComboBox {
                id: session
                width: parent.width
                height: 36
                model: sessionModel
                textRole: "name"
                currentIndex: root.sessionIndex
                onActivated: root.sessionIndex = currentIndex
                font.family: root.fontFamily
                font.pixelSize: 14
                contentItem: Text {
                    leftPadding: 12
                    verticalAlignment: Text.AlignVCenter
                    color: root.dim
                    font: session.font
                    text: "Session: " + session.displayText
                }
                background: Rectangle { radius: 10; color: root.field; border.color: "#3b4261"; border.width: 1 }
            }

            // Power buttons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24
                Repeater {
                    model: [
                        { label: "Suspend",   show: sddm.canSuspend,  run: function() { sddm.suspend() } },
                        { label: "Reboot",    show: sddm.canReboot,   run: function() { sddm.reboot() } },
                        { label: "Power off", show: sddm.canPowerOff, run: function() { sddm.powerOff() } }
                    ]
                    delegate: Text {
                        required property var modelData
                        visible: modelData.show
                        color: mouse.containsMouse ? root.accent : root.dim
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        text: modelData.label
                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.run()
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: password.forceActiveFocus()
}
