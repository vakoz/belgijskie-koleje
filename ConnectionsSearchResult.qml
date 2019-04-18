import QtQuick 2.0
import QtQuick.Layouts 1.0

Rectangle {
    property string from
    property string to
    property string date
    function setHeader() {
        mainWindowHeaderTitle.text = "Połączenia"
        Qt.createQmlObject("
        import QtQuick 2.0
import QtQuick.Layouts 1.0
        Column {
Layout.columnSpan: 3
            Text {
color: 'white'
                text: from
            }
RowLayout {
anchors.left: parent.left
anchors.right: parent.right
            Text {
                color: 'white'
                text: to
            }
    Image {
        id: favButton
        source: favRoutes.isInDatabase(from, to) === -1 ? 'images/emptyStar.png' : 'images/filledStar.png'
        sourceSize.height: 32
        sourceSize.width: 32
        Layout.alignment: Qt.AlignRight
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var id = favRoutes.isInDatabase(from, to)
                if (id === -1) {
                    favRoutes.addRoute(from, to);
                    favButton.source = 'images/filledStar.png'
                }
                else {
                    favRoutes.removeRoute(id)
                    favButton.source = 'images/emptyStar.png'
                }
            }
        }
    }
}
            Text {
color: 'white'
                text: date
            }

        }"     , mainWindowHeaderLayout);
    }

    anchors.fill: parent
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
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    if (edit.viasCount) {
                        connections.setViasModel(edit.index)
                        stack.push(connectionDetailsPage, { depTime: edit.departure.time,
                                       depStation: edit.departure.station,arrTime: edit.arrival.time,
                                       arrStation: edit.arrival.station, date: date})
                    }
                    else {
                        train.getData(edit.departure.trainId)
                        stack.push(trainPage, {trainId: edit.departure.trainId, depTime: edit.departure.time,
                                   depStation: edit.departure.station, arrTime: edit.arrival.time,
                                   arrStation: edit.arrival.station})
                    }
                }
            }
        }
    }

    Component {
        id: connectionDetailsPage
        ConnectionDetails {}
    }

    Component {
        id: trainPage
        Train {}
    }
}
