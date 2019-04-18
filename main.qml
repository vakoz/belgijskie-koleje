import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQml 2.2

ApplicationWindow {
    visible: true
    id: main
    //width: 640
    //height: 480
    width: 360
    height: 600
    title: "s"
    header: ToolBar {
        background: Rectangle {
            color: "#2962ff"
        }
        GridLayout {
            id: mainWindowHeaderLayout
            columns: 3
            rows: 2
            anchors.fill: parent
            ToolButton {
                id: backButton
                text: qsTr("‹")
                contentItem: Text {
                    text: backButton.text
                    color: "white"
                    font.pointSize: 25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: stack.pop()
            }
            Label {
                id: mainWindowHeaderTitle
                text: "Rozkład jazdy"
                color: "white"
                font.pointSize: 25
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }
            Item {
                width: backButton.width
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: MainMenu {}
        //initialItem: Train {}
        //initialItem: StationSearch {}
        //initialItem: FavRoutes {}
        //initialItem: FavTrains {}
        onCurrentItemChanged: {
            clearHeader()
            currentItem.setHeader()
        }
    }
    function clearHeader() {
        var last = mainWindowHeaderLayout.children.length - 1
        if (last > 2) {
            mainWindowHeaderLayout.children[last].destroy()
        }
    }
}
        /* ====================== Dodawanie do Layoutu ======================
    Qt.createQmlObject("
import QtQuick 2.0
Rectangle {
id: zzz
width: 50
height: 50
color: 'green'
}"     , mainWindowHeaderLayout);
*/

        /* ====================== Usuwanie z Layoutu ======================
                    var last = mainWindowHeaderLayout.children.length - 1
                    mainWindowHeaderLayout.children[last].destroy()
        */








//    Component.onCompleted: {
//        train.getData("IC1832")
//    }


/* Concept 2
    Rectangle {
        //id: todo
        anchors.fill: parent
        color: "#2962ff"
        Image {
            source: "images/tory.jpg"
            width: parent.width
            height: parent.height
        }

        Column {
            anchors.centerIn: parent
            spacing: 30
            anchors.leftMargin: 50
            Text {
                id: findConnection
                font.pointSize: 25
                color: "white"
                text: "Znajdź połączenie"
                Image {
                    anchors.right: findConnection.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: findConnection.verticalCenter
                    source: "images/favRoutes.png"
                    sourceSize.width: 30
                    sourceSize.height: 30
                }
            }
            Text {
                font.pointSize: 25
                color: "white"
                text: "Wyszukaj stację"
            }
            Text {
                font.pointSize: 25
                color: "white"
                text: "Ulubione trasy"
            }
            Text {
                font.pointSize: 25
                color: "white"
                text: "Zapisane pociągi"
            }
            // może jakieś ustawienia i w nich np możliwość usuwania
            // ostatnio szukanych - o ile taką opcję bym dodał czy coś
        }

    }
*/



//    ListView {
//        width: 100; height: 100

//        model: xoxo.model
//        delegate: Rectangle {
//            height: 25
//            width: 100
//            Text { text: modelData }
//        }
//    }
//    Label {
//        width: 100; height: 30
//        text: lolek.xo.name1
//    }
//    ListView {
//        width: 100; height: 100

//        model: stations.model
//        delegate: Rectangle {
//            height: 25
//            width: 100
//            Text { text: modelData }
//        }
//    }
/* ListView for train model
    ListView {
        y:125
        width: 300; height: 250 //change those to anchors.fill: parent
        model: train.stops
        delegate: Rectangle { //wrap with layout?
            id: rect
            property bool extraInfo: false
            width: parent.width
            height: 80
            Text {
                id: stationLabel
                text: edit.scheduledArrivalTime + "  " + edit.station
            }
            Text {
                property int arrivalDelay: edit.arrivalDelay
                text: arrivalDelay ? "+" + arrivalDelay : ""
                anchors.right: parent.right
            }
            Item {
                id: extraInfoLabel
                visible: true
                anchors.top: stationLabel.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                Rectangle {
                    id: extraInfoLabelHeaders
                    height: 20
                    width: parent.width
                    color: "blue"
                    Text {
                        text: "Godzina odj/przyj"
                    }
                    Text {
                        text: "Peron"
                        x: (parent.x * 2 + parent.width) / 2
                    }
                    Text {
                        text: "Opóźnienie"
                        anchors.right: parent.right
                    }
                }
                Rectangle {
                    id: extraInfoLabelArrival
                    height: 20
                    width: parent.width
                    anchors.top: extraInfoLabelHeaders.bottom
                    color: "orange"
                    Text {
                        text: edit.scheduledArrivalTime
                    }
                    Text {
                        text: "   " + edit.platform
                        x: (parent.x * 2 + parent.width) / 2
                    }
                    Text {
                        text: edit.arrivalDelay ? "+" + edit.arrivalDelay : ""
                        anchors.right: parent.right
                    }
                }
                Rectangle {
                    height: 20
                    width: parent.width
                    anchors.top: extraInfoLabelArrival.bottom
                    color: "yellow"
                    Text {
                        text: edit.scheduledDepartureTime
                    }
                    Text {
                        text: "   " + edit.platform
                        x: (parent.x * 2 + parent.width) / 2
                    }
                    Text {
                        text: edit.departureDelay ? "+" + edit.departureDelay : ""
                        anchors.right: parent.right
                    }
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    print("Clicked")
                    if (parent.extraInfo == false) {
                        extraInfoLabel.visible = true;
                        print(extraInfoLabel.visible)
                    }
                }
            }
        }
    }
*/



/* Liveboard Ogólnie pewnie zrobie z tego typ; w sumie najprostszy widok
    TabBar {
        y: 80
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("First")
        }
        TabButton {
            text: qsTr("Second")
        }
    }
    Rectangle {
        y:125
        width: 350; height: 200
        color: "#EDEDED"
        ListView {
            anchors.fill: parent
            model: liveboard.departures
            spacing: 5
            delegate: Rectangle {
                width: parent.width
                height: 40
                RowLayout {
                    id: row
                    width: parent.width
                    property int margin: 20
                    Text {
                        Layout.leftMargin: parent.margin
                        Layout.topMargin: parent.margin / 2
                        text: edit.time + "  " + edit.station
                    }
                    Text {
                        Layout.alignment: Qt.AlignRight
                        Layout.topMargin: parent.margin / 2
                        text: edit.platform
                    }

                    Text {
                        anchors.right: parent.right
                        Layout.topMargin: parent.margin / 2
                        text: edit.delay ? "+" + edit.delay : ""
                    }
                }
            }
        }
    }
*/
/* Connections - tutaj trochę zabawy będzie - trzeba bd pod ekran fona dostosować
    Rectangle {
        y:125
        width: 350; height: 200
        color: "#EDEDED"
        ListView {
            //width: 350; height: 250
            anchors.fill: parent
            model: connections.model

            spacing: 5
            delegate: Rectangle {
                id: rect
                property int margin: 20
                width: parent.width
                height: connectionRow.height
                ColumnLayout {
                    id: connectionRow
                    Text {
                        id: depText
                        Layout.leftMargin: rect.margin
                        Layout.topMargin: rect.margin
                        font.pointSize: 24
                        text: "<b>" + edit.departure.time + "</b> " +
                              edit.departure.station
                    }
                    Text {
                        id: depPlatform
                        Layout.leftMargin: rect.margin
                        text: "Peron " + edit.departure.platform
                    }
                    Text {
                        id: arrText
                        Layout.leftMargin: rect.margin
                        font.pointSize: 24
                        text: "<b>" + edit.arrival.time + "</b> " +
                              edit.arrival.station
                    }
                    Text {
                        id: arrPlatform
                        Layout.leftMargin: rect.margin
                        text: "Peron " + edit.arrival.platform
                    }
                    Rectangle {
                        id: horizonalLine
                        Layout.leftMargin: rect.margin
                        Layout.rightMargin: rect.margin
                        Layout.topMargin: rect.margin / 2
                        Layout.bottomMargin: rect.margin / 2
                        height: 1
                        width: rect.width
                        color: "#EDEDED"
                    }
                    Text {
                        Layout.leftMargin: rect.margin
                        Layout.bottomMargin: rect.margin
                        text: "Przesiadki: " + "<b>" + edit.viasCount + "</b>" +
                              " &nbsp; &nbsp; " + "Czas podrózy: " +
                              "<b>" + edit.duration + "</b>"
                    }
                }
            }
        }
    }
*/

/* Details
    ListView {
        x: 200; y:125
        width: 200; height: 250
        model: connections.viasModel
        delegate: Rectangle {
            width: parent.width
            height: 60
            Text {
                id: arrivalLabel
                text: edit.arrival.time + "  " + edit.arrival.station
            }
            Text {
                id: stopLabel
                anchors.top: arrivalLabel.bottom
                text: "Czas na przejscie z peronu " + edit.arrival.platform
                      + " na peron " + edit.departure.platform + " to " + edit.timeBetween
            }
            Text {
                anchors.top: stopLabel.bottom
                text: edit.departure.time + "  " + edit.departure.station
            }
        }
    }
*/
//    Item {
//        y:300
//        Timer {
//            id: trainTimer
//            interval: 500; running: true; repeat: true
//            onTriggered: time.text = Date().toString()
//        }

//        Text { id: time }
//    }

