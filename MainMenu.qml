import QtQuick 2.0

Rectangle {
    //id: todow
    function setHeader() {
        mainWindowHeaderTitle.text = "Rozkład jazdy"
    }

    anchors.fill: parent
    color: "#2962ff"
    Column {
        anchors.centerIn: parent
        spacing: 30
        anchors.leftMargin: 50
        Text {
            id: findConnection
            font.pointSize: 25
            color: "white"
            text: "Znajdź połączenie"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    stack.push("qrc:/ConnectionSearch.qml")
                }
            }
            Image {
                anchors.right: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "images/findConnection.png"
                sourceSize.width: 30
                sourceSize.height: 30
            }
        }
        Text {
            font.pointSize: 25
            color: "white"
            text: "Wyszukaj stację"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    stack.push("qrc:/StationSearch.qml")
                }
            }
            Image {
                anchors.right: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "images/findStation.png"
                sourceSize.width: 30
                sourceSize.height: 30
            }
        }
        Text {
            font.pointSize: 25
            color: "white"
            text: "Ulubione trasy"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                   stack.push("qrc:/FavRoutes.qml")
                }
            }
            Image {
                anchors.right: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "images/favRoutes.png"
                sourceSize.width: 30
                sourceSize.height: 30
            }
        }
        Text {
            font.pointSize: 25
            color: "white"
            text: "Zapisane pociągi"
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    stack.push("qrc:/FavTrains.qml")
                }
            }
            Image {
                anchors.right: parent.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: "images/favTrains.png"
                sourceSize.width: 30
                sourceSize.height: 30
            }
        }
    }
}
