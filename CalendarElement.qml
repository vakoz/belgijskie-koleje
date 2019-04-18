import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Calendar {
    anchors.centerIn: parent

    style: CalendarStyle {
        gridVisible: false
        dayDelegate: Rectangle {
            gradient: Gradient {
                GradientStop {
                    position: 0.00
                    color: styleData.selected ? "#111" : (styleData.visibleMonth && styleData.valid ? "#444" : "#666");
                }
                GradientStop {
                    position: 1.00
                    color: styleData.selected ? "#444" : (styleData.visibleMonth && styleData.valid ? "#111" : "#666");
                }
                GradientStop {
                    position: 1.00
                    color: styleData.selected ? "#777" : (styleData.visibleMonth && styleData.valid ? "#111" : "#666");
                }
            }

            Label {
                text: styleData.date.getDate()
                anchors.centerIn: parent
                color: styleData.valid ? "white" : "grey"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#555"
                anchors.bottom: parent.bottom
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "#555"
                anchors.right: parent.right
            }
        }
    }
}
