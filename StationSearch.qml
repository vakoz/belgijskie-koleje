import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

ColumnLayout {
    function setHeader() {
        mainWindowHeaderTitle.text = "Stacje"
    }
    anchors.fill: parent
    anchors.margins: 20
    TextField {
        id: stationTextField
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true
        placeholderText: qsTr("Nazwa stacji...")
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: stationTextField.height + 10

        Layout.fillHeight: true
        model: stations.model
        spacing: 10
        delegate: Rectangle {
            height: stationName.height + 3
            width: parent.width
            Text {
                id: stationName
                text: modelData
                font.pointSize: 18
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    liveboard.getData(stationName.text, 0)
                    stack.push(stationPage, {station: stationName.text})
                }
            }
            Rectangle {
                anchors.top: stationName.bottom
                anchors.topMargin: 2
                height: 1
                width: parent.width
                color: "#EDEDED"
            }

        }
    }
    Component {
        id: stationPage
        Station {}
    }
}

//height: 1
//width: rect.width
//color: "#EDEDED"
