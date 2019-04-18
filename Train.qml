import QtQuick 2.6

Rectangle {
    property string trainId
    property string depTime
    property string depStation
    property string arrTime
    property string arrStation
    function setHeader() {
        mainWindowHeaderTitle.text = "Trasa pociągu"
        Qt.createQmlObject("
        import QtQuick 2.6
import QtQuick.Layouts 1.1
        Column {
            Text {
color: 'white'
                text: trainId
            }
            Text {
color: 'white'
                text: depTime + ' ' + depStation
            }
            Text {
color: 'white'
                text: arrTime + ' ' + arrStation
            }
    Image {
        id: favButton
        source: favTrains.isInDatabase(from, to) === -1 ? 'images/emptyStar.png' : 'images/filledStar.png'
        sourceSize.height: 32
        sourceSize.width: 32
        Layout.alignment: Qt.AlignRight
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var id = favTrains.isInDatabase(from, to)
                if (id === -1) {
                    favTrains.addTrain(trainId, depStation, arrStation, depTime, arrTime);
                    favButton.source = 'images/filledStar.png'
                }
                else {
                    favTrains.removeTrain(id)
                    favButton.source = 'images/emptyStar.png'
                }
            }
        }
    }
        }"     , mainWindowHeaderLayout);
    }

    anchors.fill: parent
    color: "#F2F2F2"
    ListView {
        anchors.fill: parent
        anchors.topMargin: 10
        spacing: 10
        model: train.stops
        delegate: Rectangle {
            id: rect
            property bool extraInfo: false
            //"#757575" "#9e9e9e" "#bdbdbd"
//            property string color1: edit.left ? "#757575" : "#2979ff"
//            property string color2: edit.left ? "#9e9e9e" : "#448aff"
//            property string color3: edit.left ? "#bdbdbd" : "#82b1ff"

            property string color1: edit.left ? "white" : "white"
            property string color2: edit.left ? "white" : "white"
            property string color3: edit.left ? "white" : "white"

            width: parent.width
            height: stationLabel.height * 4
            color: "#F2F2F2"
            Rectangle {
                id: statusRect
                height: parent.height
                width: 10
                color: edit.left ? "#d50000" : "#2962ff"
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            Rectangle {
                id: stationLabel
                height: stationName.height
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 10
                color: rect.color1
                Text {
                    id: stationName
                    padding: 5
                    text: edit.scheduledArrivalTime + "  " + edit.station
                }
                Text {
                    property int delay: edit.arrivalDelay > edit.departureDelay
                                        ? edit.arrivalDelay : edit.departureDelay
                    text: delay ? "+" + delay : ""
                    anchors.right: parent.right
                    padding: 5
                }
            }
            Item {
                id: extraInfoLabel
                visible: true
                anchors.top: stationLabel.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 10
                Rectangle {
                    id: extraInfoLabelHeaders
                    height: timeLabel.height
                    width: parent.width
                    color: color2
                    Text {
                        id: timeLabel
                        padding: 5
                        text: "Godzina odj/przyj"
                    }
                    Text {
                        padding: 5
                        text: "Peron"
                        x: (parent.x * 2 + parent.width) / 2
                    }
                    Text {
                        padding: 5
                        text: "Opóźnienie"
                        anchors.right: parent.right
                        rightPadding: 5
                    }
                }
                Rectangle {
                    id: extraInfoLabelArrival
                    height: scheduledArrivalTimeLabel.height
                    width: parent.width
                    anchors.top: extraInfoLabelHeaders.bottom
                    color: rect.color3
                    Text {
                        id: scheduledArrivalTimeLabel
                        padding: 5
                        text: edit.scheduledArrivalTime
                    }
                    Text {
                        padding: 5
                        text: "   " + edit.platform
                        x: (parent.x * 2 + parent.width) / 2
                    }
                    Text {
                        text: edit.arrivalDelay ? "+" + edit.arrivalDelay : ""
                        anchors.right: parent.right
                        padding: 5
                    }
                }
                Rectangle {
                    height: scheduledDepartureTime.height
                    width: parent.width
                    anchors.top: extraInfoLabelArrival.bottom
                    color: rect.color3
                    Text {
                        id: scheduledDepartureTime
                        padding: 5
                        text: edit.scheduledDepartureTime
                    }
                    Text {
                        text: "   " + edit.platform
                        x: (parent.x * 2 + parent.width) / 2
                        padding: 5
                    }
                    Text {
                        text: edit.departureDelay ? "+" + edit.departureDelay : ""
                        anchors.right: parent.right
                        padding: 5
                    }
                }
            }
            Component.onCompleted: {
                console.log(edit.left)
            }
        }
    }
}


//Rectangle {
//    anchors.fill: parent
//    color: "#6200ea"
//    ListView {
//        anchors.fill: parent
//        spacing: 10
//        model: train.stops
//        delegate: Rectangle {
//            id: rect
//            property bool extraInfo: false
//            //"#757575" "#9e9e9e" "#bdbdbd"
//            property string color1: edit.left ? "#757575" : "#2979ff"
//            property string color2: edit.left ? "#9e9e9e" : "#448aff"
//            property string color3: edit.left ? "#bdbdbd" : "#82b1ff"

//            width: parent.width
//            height: stationLabel.height * 4
//            color: "#6200ea"
//            Rectangle {
//                id: stationLabel
//                height: stationName.height
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.leftMargin: 10
//                anchors.rightMargin: 10
//                color: rect.color1
//                Text {
//                    id: stationName
//                    padding: 5
//                    text: edit.scheduledArrivalTime + "  " + edit.station
//                }
//                Text {
//                    property int delay: edit.arrivalDelay > edit.departureDelay
//                                        ? edit.arrivalDelay : edit.departureDelay
//                    text: delay ? "+" + delay : ""
//                    anchors.right: parent.right
//                    padding: 5
//                }
//            }
//            Item {
//                id: extraInfoLabel
//                visible: true
//                anchors.top: stationLabel.bottom
//                anchors.bottom: parent.bottom
//                anchors.left: parent.left
//                anchors.right: parent.right
//                anchors.leftMargin: 10
//                anchors.rightMargin: 10
//                Rectangle {
//                    id: extraInfoLabelHeaders
//                    height: timeLabel.height
//                    width: parent.width
//                    color: color2
//                    Text {
//                        id: timeLabel
//                        padding: 5
//                        text: "Godzina odj/przyj"
//                    }
//                    Text {
//                        padding: 5
//                        text: "Peron"
//                        x: (parent.x * 2 + parent.width) / 2
//                    }
//                    Text {
//                        padding: 5
//                        text: "Opóźnienie"
//                        anchors.right: parent.right
//                        rightPadding: 5
//                    }
//                }
//                Rectangle {
//                    id: extraInfoLabelArrival
//                    height: scheduledArrivalTimeLabel.height
//                    width: parent.width
//                    anchors.top: extraInfoLabelHeaders.bottom
//                    color: rect.color3
//                    Text {
//                        id: scheduledArrivalTimeLabel
//                        padding: 5
//                        text: edit.scheduledArrivalTime
//                    }
//                    Text {
//                        padding: 5
//                        text: "   " + edit.platform
//                        x: (parent.x * 2 + parent.width) / 2
//                    }
//                    Text {
//                        text: edit.arrivalDelay ? "+" + edit.arrivalDelay : ""
//                        anchors.right: parent.right
//                        padding: 5
//                    }
//                }
//                Rectangle {
//                    height: scheduledDepartureTime.height
//                    width: parent.width
//                    anchors.top: extraInfoLabelArrival.bottom
//                    color: rect.color3
//                    Text {
//                        id: scheduledDepartureTime
//                        padding: 5
//                        text: edit.scheduledDepartureTime
//                    }
//                    Text {
//                        text: "   " + edit.platform
//                        x: (parent.x * 2 + parent.width) / 2
//                        padding: 5
//                    }
//                    Text {
//                        text: edit.departureDelay ? "+" + edit.departureDelay : ""
//                        anchors.right: parent.right
//                        padding: 5
//                    }
//                }
//            }
//            Component.onCompleted: {
//                console.log(edit.trainId)
//            }
//        }
//    }
//}
