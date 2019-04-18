import QtQuick 2.5
import QtQuick.Layouts 1.1

ListView {
    property string depTime
    property string depStation
    property string arrTime
    property string arrStation
    property string date
    function setHeader() {
        mainWindowHeaderTitle.text = "Szczegóły połączenia"
        Qt.createQmlObject("
        import QtQuick 2.5
import QtQuick.Layouts 1.1
        Column {
Layout.columnSpan: 3
            Text {
color: 'white'
                text: depTime + ' ' + depStation
            }
            Text {
color: 'white'
                text: arrTime + ' ' + arrStation
            }
            Text {
color: 'white'
                text: date
            }
        }"     , mainWindowHeaderLayout);
    }
    anchors.fill: parent
    model: connections.viasModel
    delegate: Rectangle {
        id: rect
        property int margin: 20
        width: parent.width
        height: connectionRow.height
        ColumnLayout {
            id: connectionRow
            ColumnLayout {
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
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        train.getData(edit.departure.trainId)
                        stack.push(trainPage, {trainId: edit.departure.trainId, depTime: edit.departure.time,
                                   depStation: edit.departure.station, arrTime: edit.arrival.time,
                                   arrStation: edit.arrival.station})
                    }
                }
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
                //visible: edit.timeBetween
            }
            Row {
                Layout.leftMargin: rect.margin
                spacing: 10
                Image {
                    id: bench
                    source: "images/bench.png"
                    sourceSize.width: 30
                    sourceSize.height: 30
                    visible: edit.timeBetween
                }
                Text {

                    text: "Przesiadka w " + edit.arrival.station + '\n' + edit.timeBetween +
                          " min. na przejście z peronu " + edit.arrival.platform + " na peron " +
                          connections.getDeparturePlatform(index + 1)
                    visible: edit.timeBetween
                }
            }
            Rectangle {
                Layout.leftMargin: rect.margin
                Layout.rightMargin: rect.margin
                Layout.topMargin: rect.margin / 2
                Layout.bottomMargin: rect.margin
                height: 1
                width: rect.width
                color: "#EDEDED"
                visible: edit.timeBetween
            }
        }
    }
    Component {
        id: trianPage
        Train {}
    }
}

//MouseArea {
//    anchors.fill: parent
//    onPressed: {
//        train.getData(edit.departure.trainId)
//        stack.push(trainView)
//    }
//}
