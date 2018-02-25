import QtQuick 2.8
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import Guh 1.0
import "../components"

ItemDelegate {
    id: root

    property var paramType: null
    property alias value: d.value
    property var param: Param {
        id: d
        paramTypeId: paramType.id
        value: paramType.defaultValue
    }
    property bool writable: true

    contentItem: ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                text: root.paramType.displayName
                elide: Text.ElideRight
            }
            Loader {
                id: loader
                Layout.fillWidth: sourceComponent == textFieldComponent
                sourceComponent: {
                    if (!root.writable) {
                        return stringComponent;
                    }

                    switch (root.paramType.type) {
                    case "Bool":
                        return boolComponent;
                    case "Int":
                        return stringComponent;
                    case "String":
                        if (root.paramType.allowedValues.length > 0) {
                            return comboBoxComponent;
                        }
                        return textFieldComponent;
                    case "Color":
                        return colorPreviewComponent;
                    }
                    console.warn("Param Delegate: Fallback to stringComponent", root.paramType.name, root.paramType.type)
                    return stringComponent;
                }
            }
        }
        Loader {
            Layout.fillWidth: true
            sourceComponent: {
                switch (root.paramType.type) {
                case "Int":
                case "Double":
                    if (root.paramType.minValue != undefined && root.paramType.maxValue != undefined) {
                        return sliderComponent
                    }
                    break;
                case "Color":
                    return colorPickerComponent
                }
                return null;
            }
        }
    }

    Component {
        id: stringComponent
        Label {
            text: {
                switch (root.paramType.type) {
                case "Int":
                    return Math.round(root.param.value);
                }
                return root.param.value;
            }

        }
    }
    Component {
        id: boolComponent
        Switch {
            checked: root.param.value === true
            onClicked: {
                root.param.value = checked;
            }
        }
    }
    Component {
        id: sliderComponent
        RowLayout {
            spacing: app.margins
            Label {
                text: root.paramType.minValue
            }
            Slider {
                Layout.fillWidth: true
                from: root.paramType.minValue
                to: root.paramType.maxValue
                value: root.param.value
                stepSize: {
                    switch (root.paramType.type) {
                    case "Int":
                        return 1;
                    }
                    return 0.01;

                }

                onMoved: {
                    root.param.value = value;
                }
            }
            Label {
                text: root.paramType.maxValue
            }
        }

    }

    Component {
        id: textFieldComponent
        TextField {
            text: root.param.value
            onEditingFinished: {
                root.param.value = text
            }
        }
    }

    Component {
        id: comboBoxComponent
        ComboBox {
            model: root.paramType.allowedValues
            currentIndex: root.paramType.allowedValues.indexOf(root.param.value)
            onActivated: {
                root.param.value = root.paramType.allowedValues[index]
                print("setting value to", root.param.value)
            }
        }
    }

    Component {
        id: colorPickerComponent
        ColorPicker {
            id: colorPicker
            implicitHeight: 200
//            color: root.param.value

            Binding {
                target: colorPicker
                property: "color"
                value: root.param.value
                when: !colorPicker.pressed
            }

            onColorChanged: {
                root.param.value = color;
            }

            touchDelegate: Rectangle {
                height: 15
                width: height
                radius: height / 2
                color: Material.accent


                Rectangle {
                    color: colorPicker.hovered || colorPicker.pressed ? "#11000000" : "transparent"
                    anchors.centerIn: parent
                    height: 30
                    width: height
                    radius: width / 2
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }
    }

    Component {
        id: colorPreviewComponent
        Rectangle {
            implicitHeight: app.mediumFont
            implicitWidth: implicitHeight
            color: root.param.value
            radius: width / 4
        }
    }
}