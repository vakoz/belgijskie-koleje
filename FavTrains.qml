import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

Rectangle {
    function setHeader() {
        mainWindowHeaderTitle.text = "Zapisane pociągi"
    }

    color: "#F2F2F2"
    ListView {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        model: favTrains
        delegate: Rectangle {
            id: favTrainRect
            width: parent.width
            height: favTrainLayout.height
            border.width: 1
            border.color: "#e0e0e0"
            ColumnLayout {
                id: favTrainLayout
                Text {
                    text: trainId
                    font.pointSize: 18
                    padding: 10
                }
                Text {
                    id: departureLabel
                    text: departureTime + " " + stationFrom
                    font.pointSize: 18
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                Text {
                    text: arrivalTime + " " + stationTo
                    font.pointSize: 18
                    padding: 10
                }
            }
            Button {
                id: deleteButton
                width: departureLabel.height * 1.5
                height: departureLabel.height * 1.5
                anchors.right: parent.right
                anchors.verticalCenter: favTrainLayout.verticalCenter
                background: Image {
                    source: "images/delete.png"
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mouseX >= deleteButton.x && mouseY >= deleteButton.y
                            && mouseY <= deleteButton.y + deleteButton.height)
                        favTrains.removeTrain(index)
                    else {
                        train.getData(trainId)
                        stack.push("qrc:/Train.qml")
                    }
                }
            }
        }
    }
}
