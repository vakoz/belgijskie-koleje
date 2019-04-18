import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

TabView {
    id: frame
    property string station
    function setHeader() {
        mainWindowHeaderTitle.text = station
    }

    anchors.fill: parent
    property int pWidth: width / 2 + anchors.margins / 2
    onCurrentIndexChanged: {
        if (!currentIndex)
            liveboard.getData(station, 0)
        else
            liveboard.getData(station, 1)
    }

    Tab {
        title: "Odjazdy"

        ListView {
            anchors.fill: parent
            anchors.topMargin: 10
            model: liveboard.departures
            delegate: liveboardDelegate
        }
    }
    Tab {
        title: "Przyjazdy"
        ListView {
            anchors.fill: parent
            anchors.topMargin: 10
            model: liveboard.arrivals
            delegate: liveboardDelegate
        }
    }
    style: TabViewStyle {
        frameOverlap: 10
        tab: Rectangle {
            color: styleData.selected ? "steelblue" :"lightsteelblue"
            border.color:  "steelblue"
            implicitWidth: pWidth
            implicitHeight: 20
            radius: 2
            Text {
                id: text
                anchors.centerIn: parent
                text: styleData.title
                color: styleData.selected ? "white" : "black"
            }
        }
    }
    Component {
        id: liveboardDelegate
        Item {
            height: 15
            width: frame.width
            Text {
                id: hour
                text: edit.time
            }
            Text {
                id: delay
                anchors.left: hour.right
                anchors.leftMargin: 10
                text: edit.delay ? "+" + edit.delay : ""
                width: fm.width
                TextMetrics {
                    id: fm
                    text: "+999"
                }
            }
            Text {
                anchors.left: delay.right
                anchors.leftMargin: 10
                text: edit.station
            }
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: "p." + edit.platform
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    train.getData(edit.trainId)
                    stack.push("qrc:/Train.qml")
                }
            }
        }
    }
}
