/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* Copyright 2013 - 2020, nymea GmbH
* Contact: contact@nymea.io
*
* This file is part of nymea.
* This project including source code and documentation is protected by
* copyright law, and remains the property of nymea GmbH. All rights, including
* reproduction, publication, editing and translation, are reserved. The use of
* this project is subject to the terms of a license agreement to be concluded
* with nymea GmbH in accordance with the terms of use of nymea GmbH, available
* under https://nymea.io/license
*
* GNU General Public License Usage
* Alternatively, this project may be redistributed and/or modified under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, GNU version 3. This project is distributed in the hope that it
* will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
* of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this project. If not, see <https://www.gnu.org/licenses/>.
*
* For any further details and any questions please contact us under
* contact@nymea.io or see our FAQ/Licensing Information on
* https://nymea.io/license/faq
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import Nymea 1.0

import "../components"
import "../delegates"

Page {
    id: root

    property DeviceClass deviceClass: device ? device.deviceClass : null

    // Optional: If set, it will be reconfigred, otherwise a new one will be created
    property Device device: null

    signal aborted();
    signal done();


    QtObject {
        id: d
        property var vendorId: null
        property DeviceDescriptor deviceDescriptor: null
        property var discoveryParams: []
        property string deviceName: ""
        property int pairRequestId: 0
        property var pairingTransactionId: null
        property int addRequestId: 0
        property var name: ""
        property var params: []

        function pairThing() {
            print("setupMethod", root.deviceClass.setupMethod)

            switch (root.deviceClass.setupMethod) {
            case 0:
                if (root.device) {
                    if (d.deviceDescriptor) {
                        engine.deviceManager.reconfigureDiscoveredDevice(root.device.id, d.deviceDescriptor.id, params);
                    } else {
                        engine.deviceManager.reconfigureDevice(root.device.id, params);
                    }
                } else {
                    if (d.deviceDescriptor) {
                        engine.deviceManager.addDiscoveredDevice(root.deviceClass.id, d.deviceDescriptor.id, d.name, params);
                    } else {
                        engine.deviceManager.addDevice(root.deviceClass.id, d.name, params);
                    }
                }
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                if (root.device) {
                    if (d.deviceDescriptor) {
                        engine.deviceManager.pairDiscoveredDevice(root.deviceClass.id, d.deviceDescriptor.id, params, d.name);
                    } else {
                        engine.deviceManager.rePairDevice(root.device.id, params, d.name);
                    }
                    return;
                } else {
                    if (d.deviceDescriptor) {
                        engine.deviceManager.pairDiscoveredDevice(root.deviceClass.id, d.deviceDescriptor.id, params, d.name);
                    } else {
                        engine.deviceManager.pairDevice(root.deviceClass.id, params, d.name);
                    }
                }

                break;
            }

            busyOverlay.shown = true;

        }
    }

    Component.onCompleted: {
        print("Starting setup wizard. Create Methods:", root.deviceClass.createMethods, "Setup method:", root.deviceClass.setupMethod)
        if (root.deviceClass.createMethods.indexOf("CreateMethodDiscovery") !== -1) {
            print("CreateMethodDiscovery")
            if (deviceClass["discoveryParamTypes"].count > 0) {
                print("Discovery params:", deviceClass.discoveryParamTypes.count)
                internalPageStack.push(discoveryParamsPage)
            } else {
                print("Starting discovery...")
                discovery.discoverDevices(deviceClass.id)
                internalPageStack.push(discoveryPage, {deviceClass: deviceClass})
            }
        } else if (root.deviceClass.createMethods.indexOf("CreateMethodUser") !== -1) {
            print("CreateMethodUser")
            // Setting up a new device
            if (!root.device) {
                print("New device. Opening params page")
                internalPageStack.push(paramsPage)

            // Reconfigure
            } else if (root.device) {
                print("Existing device")
                // There are params. Open params page in any case
                if (root.deviceClass.paramTypes.count > 0) {
                    print("Params:", root.deviceClass.paramTypes.count)
                    internalPageStack.push(paramsPage)

                // No params... go straight to reconfigure/repair
                } else {
                    print("no params")
                    switch (root.deviceClass.setupMethod) {
                    case 0:
                        print("reconfiguring...")
                        // This totally does not make sense... Maybe we should hide the reconfigure button if there are no params?
                        engine.deviceManager.reconfigureDevice(root.device.id, [])
                        busyOverlay.shown = true;
                        break;
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                        print("re-pairing", root.device.id)
                        engine.deviceManager.rePairDevice(root.device.id, []);
                        break;
                    default:
                        console.warn("Unhandled setup method!")
                    }
                }
            }
        }
    }

    Connections {
        target: engine.deviceManager
        onPairDeviceReply: {
            busyOverlay.shown = false
            if (params["deviceError"] !== "DeviceErrorNoError") {
                busyOverlay.shown = false;
                internalPageStack.push(resultsPage, {deviceError: params["deviceError"], message: params["displayMessage"]});
                return;

            }

            d.pairingTransactionId = params["pairingTransactionId"];

            switch (params["setupMethod"]) {
            case "SetupMethodPushButton":
            case "SetupMethodDisplayPin":
            case "SetupMethodUserAndPassword":
                internalPageStack.push(pairingPageComponent, {text: params["displayMessage"], setupMethod: params["setupMethod"]})
                break;
            case "SetupMethodOAuth":
                internalPageStack.push(oAuthPageComponent, {oAuthUrl: params["oAuthUrl"]})
                break;
            default:
                print("Setup method reply not handled:", JSON.stringify(params));
            }
        }
        onConfirmPairingReply: {
            busyOverlay.shown = false
            internalPageStack.push(resultsPage, {deviceError: params["deviceError"], deviceId: params["deviceId"], message: params["displayMessage"]})
        }
        onAddDeviceReply: {
            print("Device added:", JSON.stringify(params))
            busyOverlay.shown = false;
            internalPageStack.push(resultsPage, {deviceError: params["deviceError"], deviceId: params["deviceId"], message: params["displayMessage"]})
        }
        onReconfigureDeviceReply: {
            busyOverlay.shown = false;
            internalPageStack.push(resultsPage, {deviceError: params["deviceError"], deviceId: params["deviceId"], message: params["displayMessage"]})
        }
    }

    DeviceDiscovery {
        id: discovery
        engine: _engine
    }

    StackView {
        id: internalPageStack
        anchors.fill: parent
    }
    property QtObject pageStack: QtObject {
        function pop(item) {
            if (internalPageStack.depth > 1) {
                internalPageStack.pop(item)
            } else {
                root.aborted()
            }
        }
    }

    Component {
        id: discoveryParamsPage
        SettingsPageBase {
            id: discoveryParamsView
            title: qsTr("Discover %1").arg(root.deviceClass.displayName)

            SettingsPageSectionHeader {
                text: qsTr("Discovery options")
            }

            Repeater {
                id: paramRepeater
                model: root.deviceClass ? root.deviceClass.discoveryParamTypes : null
                delegate: ParamDelegate {
                    Layout.fillWidth: true
                    paramType: root.deviceClass.discoveryParamTypes.get(index)
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.margins: app.margins
                text: "Next"
                onClicked: {
                    var paramTypes = root.deviceClass.discoveryParamTypes;
                    d.discoveryParams = [];
                    for (var i = 0; i < paramTypes.count; i++) {
                        var param = {};
                        param["paramTypeId"] = paramTypes.get(i).id;
                        param["value"] = paramRepeater.itemAt(i).value
                        d.discoveryParams.push(param);
                    }
                    discovery.discoverDevices(root.deviceClass.id, d.discoveryParams)
                    internalPageStack.push(discoveryPage, {deviceClass: root.deviceClass})
                }
            }
        }
    }

    Component {
        id: discoveryPage

        SettingsPageBase {
            id: discoveryView

            header: NymeaHeader {
                text: qsTr("Discover %1").arg(root.deviceClass.displayName)
                backButtonVisible: true
                onBackPressed: pageStack.pop()

                HeaderButton {
                    imageSource: "../images/configure.svg"
                    visible: root.deviceClass.createMethods.indexOf("CreateMethodUser") >= 0
                    text: qsTr("Add thing manually")
                    onClicked: internalPageStack.push(paramsPage)
                }
            }


            property var deviceClass: null

            SettingsPageSectionHeader {
                text: qsTr("Nymea found the following things")
                visible: !discovery.busy && discoveryProxy.count > 0
            }

            Repeater {
                model: DeviceDiscoveryProxy {
                    id: discoveryProxy
                    deviceDiscovery: discovery
                    showAlreadyAdded: root.device !== null
                    showNew: root.device === null
                    filterDeviceId: root.device ? root.device.id : ""
                }
                delegate: NymeaListItemDelegate {
                    Layout.fillWidth: true
                    text: model.name
                    subText: model.description
                    iconName: app.interfacesToIcon(discoveryView.deviceClass.interfaces)
                    onClicked: {
                        d.deviceDescriptor = discoveryProxy.get(index);
                        d.deviceName = model.name;
                        internalPageStack.push(paramsPage)
                    }
                }
            }

            busy: discovery.busy
            busyText: qsTr("Searching for things...")

            ColumnLayout {
                visible: !discovery.busy && discoveryProxy.count === 0
                spacing: app.margins
                Layout.preferredHeight: discoveryView.height - discoveryView.header.height - retryButton.height - app.margins * 3
                Label {
                    text: qsTr("Too bad...")
                    font.pixelSize: app.largeFont
                    Layout.fillWidth: true
                    Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                    horizontalAlignment: Text.AlignHCenter
                }
                Label {
                    text: qsTr("No things of this kind could be found...")
                    Layout.fillWidth: true
                    Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                    horizontalAlignment: Text.AlignHCenter
                    text: discovery.displayMessage.length === 0 ?
                              qsTr("Make sure your things are set up and connected, try searching again or go back and pick a different kind of thing.")
                            : discovery.displayMessage
                    wrapMode: Text.WordWrap
                }

            }
            Button {
                id: retryButton
                Layout.fillWidth: true
                Layout.margins: app.margins
                text: qsTr("Search again")
                onClicked: discovery.discoverDevices(root.deviceClass.id, d.discoveryParams)
                visible: !discovery.busy
            }
        }
    }

    Component {
        id: paramsPage

        SettingsPageBase {
            id: paramsView
            title: root.device ? qsTr("Reconfigure %1").arg(root.device.name) : qsTr("Set up %1").arg(root.deviceClass.displayName)

            SettingsPageSectionHeader {
                text: qsTr("Name the thing:")
            }

            TextField {
                id: nameTextField
                text: d.deviceName ? d.deviceName : root.deviceClass.displayName
                Layout.fillWidth: true
                Layout.leftMargin: app.margins
                Layout.rightMargin: app.margins
            }

            SettingsPageSectionHeader {
                text: qsTr("Thing parameters")
            }

            Repeater {
                id: paramRepeater
                model: engine.jsonRpcClient.ensureServerVersion("1.12") || d.deviceDescriptor == null ?  root.deviceClass.paramTypes : null
                delegate: ParamDelegate {
//                            Layout.preferredHeight: 60
                    Layout.fillWidth: true
                    enabled: !model.readOnly
                    paramType: root.deviceClass.paramTypes.get(index)
                    value: d.deviceDescriptor && d.deviceDescriptor.params.getParam(paramType.id) ?
                               d.deviceDescriptor.params.getParam(paramType.id).value :
                               root.deviceClass.paramTypes.get(index).defaultValue
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.leftMargin: app.margins
                Layout.rightMargin: app.margins

                text: "OK"
                onClicked: {
                    var params = []
                    for (var i = 0; i < paramRepeater.count; i++) {
                        var param = {}
                        var paramType = paramRepeater.itemAt(i).paramType
                        if (!paramType.readOnly) {
                            param.paramTypeId = paramType.id
                            param.value = paramRepeater.itemAt(i).value
                            print("adding param", param.paramTypeId, param.value)
                            params.push(param)
                        }
                    }

                    d.params = params
                    d.name = nameTextField.text
                    d.pairThing();
                }
            }
        }
    }

    Component {
        id: pairingPageComponent
        SettingsPageBase {
            id: pairingPage
            title: root.device ? qsTr("Reconfigure %1").arg(root.device.name) : qsTr("Set up %1").arg(root.deviceClass.displayName)
            property alias text: textLabel.text

            property string setupMethod

            SettingsPageSectionHeader {
                text: qsTr("Login required")
            }

            Label {
                id: textLabel
                Layout.fillWidth: true
                Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                wrapMode: Text.WordWrap
            }

            TextField {
                id: usernameTextField
                Layout.fillWidth: true
                Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                placeholderText: qsTr("Username")
                visible: pairingPage.setupMethod === "SetupMethodUserAndPassword"
            }

            PasswordTextField {
                id: pinTextField
                Layout.fillWidth: true
                Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                visible: pairingPage.setupMethod === "SetupMethodDisplayPin" || pairingPage.setupMethod === "SetupMethodUserAndPassword"
                signup: false
            }


            Button {
                Layout.fillWidth: true
                Layout.margins: app.margins
                text: "OK"
                onClicked: {
                    engine.deviceManager.confirmPairing(d.pairingTransactionId, pinTextField.password, usernameTextField.displayText);
                    busyOverlay.shown = true;
                }
            }
        }
    }

    Component {
        id: oAuthPageComponent
        Page {
            id: oAuthPage
            property string oAuthUrl
            header: NymeaHeader {
                text: root.device ? qsTr("Reconfigure %1").arg(root.device.name) : qsTr("Set up %1").arg(root.deviceClass.displayName)
                onBackPressed: pageStack.pop()
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - app.margins * 2
                spacing: app.margins * 2

                Label {
                    Layout.fillWidth: true
                    text: qsTr("OAuth is not supported on this platform. Please use this app on a different device to set up this thing.")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    Layout.fillWidth: true
                    text: qsTr("In order to use OAuth on this platform, make sure qml-module-qtwebview is installed.")
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.smallFont
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Item {
                id: webViewContainer
                anchors.fill: parent

                Component.onCompleted: {
                    // This might fail if qml-module-qtwebview isn't around
                    Qt.createQmlObject(webViewString, webViewContainer);
                }

                property string webViewString:
                    '
                    import QtQuick 2.8;
                    import QtWebView 1.1;
                    WebView {
                        id: oAuthWebView
                        anchors.fill: parent
                        url: oAuthPage.oAuthUrl

                        onUrlChanged: {
                            print("OAUTH URL changed", url)
                            if (url.toString().indexOf("https://127.0.0.1") == 0) {
                                print("Redirect URL detected!");
                                engine.deviceManager.confirmPairing(d.pairingTransactionId, url)
                            }
                        }
                    }
                    '
            }
        }
    }

    Component {
        id: resultsPage

        Page {
            id: resultsView
            header: NymeaHeader {
                text: root.device ? qsTr("Reconfigure %1").arg(root.device.name) : qsTr("Set up %1").arg(root.deviceClass.displayName)
                onBackPressed: pageStack.pop()
            }

            property string deviceId
            property string deviceError
            property string message

            readonly property bool success: deviceError === "DeviceErrorNoError"

            readonly property var device: root.device ? root.device : engine.deviceManager.devices.getDevice(deviceId)

            ColumnLayout {
                width: Math.min(500, parent.width - app.margins * 2)
                anchors.centerIn: parent
                spacing: app.margins * 2
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    text: resultsView.success ? root.device ? qsTr("Thing reconfigured!") : qsTr("Thing added!") : qsTr("Uh oh")
                    font.pixelSize: app.largeFont
                    color: app.accentColor
                }
                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: resultsView.success ? qsTr("All done. You can now start using %1.").arg(resultsView.device.name) : qsTr("Something went wrong setting up this thing...");
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: resultsView.message
                }


                Button {
                    Layout.fillWidth: true
                    Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                    visible: !resultsView.success
                    text: "Retry"
                    onClicked: {
                        internalPageStack.pop({immediate: true});
                        internalPageStack.pop({immediate: true});
                        d.pairThing();
                    }
                }

                Button {
                    Layout.fillWidth: true
                    Layout.leftMargin: app.margins; Layout.rightMargin: app.margins
                    text: qsTr("Ok")
                    onClicked: {
                        root.done();
                    }
                }
            }
        }
    }

    BusyOverlay {
        id: busyOverlay
    }
}
