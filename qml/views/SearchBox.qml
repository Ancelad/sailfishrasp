import QtQuick 2.0
import Sailfish.Silica 1.0
import subtrains 1.0

Column {
    id: searchColumn
    property alias placeHolderText: searchField.placeholderText
    height: searchRow.height + hints.height
    width: parent.width

    signal changeFocus(bool focusState)

    property var stationEsr: null
    property int zoneId: 1

    Row {
        id: searchRow
        spacing: Theme.paddingMedium
        width: parent.width

        SearchField {
            id: searchField
            placeholderText: "PlaceHolder text"
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width // - Theme.horizontalPageMargin - Theme.paddingSmall - locateFrom.width
            EnterKey.enabled: hints.count > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                var item = hints.model.get(0);

                if (item) {
                    stationEsr = item.code;
                    searchField.text = item.title;
                }

                hints.model.clear();

                focus = false;
                activeFocus = false;
                changeFocus(false);
            }

            onTextChanged: {
                hints.model.clear();
                stationEsr = null;

                if (text.length > 0) {
                    var results = qmlHandler.getStationHints(text, zoneId);
                    for (var i in results) {
                        hints.model.append(results[i]);
                    }
                }
            }

            onActiveFocusChanged: {
                changeFocus(activeFocus);

                if (!activeFocus) {
                    var item = hints.model.get(0);
                    if (item) {
                        stationEsr = item.code;
                        searchField.text = item.title;
                    }

                    hints.model.clear();
                } else {
                    searchField.textChanged();
                }
            }
        }

//        IconButton{
//            id: locateFrom
//            anchors.verticalCenter: parent.verticalCenter
//            //onClicked: whereFrom()
//            //icon.source:
//            //    "image://theme/icon-m-whereami"
//        }
    }

    SilicaListView {
        id: hints
        width: parent.width
        height: count ? contentHeight : 0

        model: ListModel {}

        delegate: BackgroundItem {
            id: listItem
            width: parent.width
            height: Theme.itemSizeExtraSmall
            property var esrId: code

            Label {
                id: hintLabel
                anchors.fill: parent
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                verticalAlignment: Text.AlignVCenter
                truncationMode: TruncationMode.Fade
                text: title
            }

            onClicked: {
                searchField.text = title;
                stationEsr = esrId;
                hints.model.clear();
            }
        }
    }
}
