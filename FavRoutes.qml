import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    function setHeader() {
        mainWindowHeaderTitle.text = "Ulubione trasy"
    }

    color: "#F2F2F2"
    ListView {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        model: favRoutes
        delegate: Rectangle  {
            width: parent.width
            height: stationFromLabel.height
            border.width: 1
            border.color: "#e0e0e0"
            Text {
                id: stationFromLabel
                anchors.left: parent.left
                anchors.leftMargin: 5
                text:  stationFrom
                font.pointSize: 18
            }
            Button {
                id: switchButton
                width: stationFromLabel.height
                height: stationFromLabel.height
                anchors.left: stationFromLabel.right
                anchors.leftMargin: 10
                background: Image {
                    source: "images/swap.png"
                }
            }
            Text {
                id: stationToLabel
                anchors.left: switchButton.right
                anchors.leftMargin: 10
                text: stationTo
                font.pointSize: 18
            }
            Button {
                id: deleteButton
                width: stationFromLabel.height
                height: stationFromLabel.height
                anchors.right: parent.right
                background: Image {
                    source: "images/delete.png"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mouseX >= switchButton.x && mouseX <= switchButton.x + switchButton.width) {
                        var tmp = stationFromLabel.text
                        stationFromLabel.text = stationToLabel.text
                        stationToLabel.text = tmp
                    }
                    else if (mouseX >= deleteButton.x){
                        favRoutes.removeRoute(index)
                    }
                    else {
                        connections.getData(stationFrom, stationTo)
                        stack.push("qrc:/ConnectionsSearchResult.qml")
                    }
                }
            }
        }
    }
}
