import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQml 2.0 //

ColumnLayout {
    function setHeader() {
        mainWindowHeaderTitle.text = "Znajdź połączenie"
    }

    anchors {
        left: parent.left
        right: parent.right
    }
    anchors.margins: 20
    TextField {
        id: stationFrom
        Layout.alignment: Qt.AlignTop
        Layout.topMargin: 20
        Layout.fillWidth: true
        //placeholderText: qsTr("Z...")
        text: "Hasselt" //zeby nie pisac poki co
    }
    Image {
        id: switchDirection
        anchors.top : stationFrom.bottom
        anchors.horizontalCenter: stationFrom.horizontalCenter
        anchors.topMargin: 10
        sourceSize.width: stationFrom.height
        sourceSize.height: stationFrom.height
        source: "images/swapDirections.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var tmp = stationFrom.text
                stationFrom.text = stationTo.text
                stationTo.text = tmp
            }
        }
    }
    TextField {
        id: stationTo
        //Layout.alignment: Qt.AlignTop
        anchors.top: switchDirection.bottom
        anchors.topMargin: 10
        Layout.fillWidth: true
        //placeholderText: qsTr("Do...")
        text: "Brugge"
    }

    TabBar {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredHeight: stationFrom.height
        TabButton {
            id: departureTab
            height: parent.height
            Text {
                anchors.centerIn: parent
                text: "Odjazd"
                color: "white"
            }
            background: Rectangle {
                color: parent.checked ? "steelblue" : "lightsteelblue"
            }

            onPressed: {
                selectLabel.text = "Data odjazdu"
            }
        }
        TabButton {
            height: parent.height
            Text {
                anchors.centerIn: parent
                text: "Przyjazd"
                color: "white"
            }
            background: Rectangle {
                color: parent.checked ? "steelblue" : "lightsteelblue"
            }
            onPressed: {
                selectLabel.text = "Data przyjazdu"
            }
        }
    }
    Label {
        id: selectLabel
        text: "Data odjazdu"
    }
    RowLayout {
        TextField {
            id: dateField
            text: Qt.formatDate(new Date(), "dd.MM.yyyy")
            //tu tak samo na stack.width
            Layout.preferredWidth: parent.parent.width * 0.5
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    datePopup.open()
                }
            }
        }
        TextField {
            id: hoursField
            text: new Date().getHours()
            //tu tak samo na stack.width
            Layout.preferredWidth: parent.parent.width * 0.20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    hoursPopup.open()
                }
            }
        }
        TextField {
            id: minutesField
            text: new Date().getMinutes()
            //tu tak samo na stack.width
            Layout.preferredWidth: parent.parent.width * 0.20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    minutesPopup.open()
                }
            }
        }
    }
    Button {
        Text {
            anchors.centerIn: parent
            text: "Wyszukaj"
            color: "white"
        }
        background: Rectangle {
            color: "#2962ff"
        }
        Layout.preferredHeight: stationFrom.height
        Layout.topMargin: 50
        Layout.fillWidth: true
        onPressed: {
            //var date = connections.formatDate(dateField.text)
            var date = "060918"
            connections.getData(stationFrom.text, stationTo.text,
                date, connections.formatTime(hoursField.text + " " + minutesField.text),
                departureTab.checked)
            //stack.push("qrc:/ConnectionsSearchResult.qml")
            stack.push(searchResultPage, {from: stationFrom.text, to: stationTo.text, date: date})
        }
    }

    Popup {
        id: datePopup
        width: parent.width
        //ogólnie to na stack.height zmien
        height: parent.parent.height / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        contentItem: CalendarElement {
            selectedDate: dateField.text
            minimumDate: new Date(2017, 0, 1)
            maximumDate: new Date(2019, 0, 1)
            onClicked: {
                //dateField.text = new Date(date).toLocaleDateString()
                dateField.text = Qt.formatDate(new Date(date), "dd.MM.yyyy")
                datePopup.close()
            }
        }
    }
    Popup {
        id: hoursPopup
        modal: true
        focus: true
        x: hoursField.x
        width: hoursField.width
        y: hoursField.verticalCenter
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        contentItem: Tumbler {
            model: 24
            currentIndex: hoursField.text
            onCurrentIndexChanged: {
                hoursField.text = currentIndex
            }
            MouseArea {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.height / parent.visibleItemCount
                onClicked: {
                    hoursPopup.close()
                }
            }
        }
    }
    Popup {
        id: minutesPopup
        modal: true
        focus: true
        x: minutesField.x
        width: minutesField.width
        y: minutesField.verticalCenter
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        contentItem: Tumbler {
            model: 60
            currentIndex: minutesField.text
            onCurrentIndexChanged: {
                minutesField.text = currentIndex
            }
            MouseArea {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.height / parent.visibleItemCount
                onClicked: {
                    minutesPopup.close()
                }
            }
        }
    }
    Component {
        id: searchResultPage
        ConnectionsSearchResult { }
    }
}
