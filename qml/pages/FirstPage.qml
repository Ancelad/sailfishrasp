/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import QtPositioning 5.2
import Sailfish.Silica 1.0
import "../views"
import "Util.js" as Util

Page {
    id: page

    PositionSource {
        id: positionSource
        active: true
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Сменить регион")
                //                    onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height


        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.

        Column {
            id: column

            anchors.fill: parent
            spacing: Theme.paddingMedium

            /*Button {
                text: "Test"
                onClicked: {
                    qmlHandler.getRoute("182209", "181704", new Date(2016,07,29));
                }
            }*/

            PageHeader {
                title: qsTr("Расписание электричек")
                id: pageHeader
            }
            //            Label {
            //                x: Theme.paddingLarge
            //                text: qsTr("Hello Sailors")
            //                color: Theme.secondaryHighlightColor
            //                font.pixelSize: Theme.fontSizeExtraLarge
            //            }

            SectionHeader {
                id: cityName
                text: qsTr("Москва и область")
            }


            // ОТКУДА

            SearchBox {
                id: searchFrom
                placeHolderText: qsTr("Откуда")
            }

            // КУДА

            SearchBox {
                id: searchTo
                placeHolderText: qsTr("Куда")
            }

            // ДАТА

            BackgroundItem {
                id: button
                width: parent.width
                height: Screen.sizeCategory > Screen.Medium ? Theme.itemSizeMedium : Theme.itemSizeExtraSmall
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var currentDate = new Date();
                    var dateForCalendar = dateLabel.areSelectedAndCurrentDateEqual() === true ?
                                currentDate :
                                dateLabel.selectedDate;
                    var dialog = pageStack.push(pickerComponent, {
                                                    date: dateForCalendar
                                                })
                    dialog.accepted.connect(function() {
                        dateLabel.selectedDate = dialog.date;
                        dateLabel.text = dateLabel.formatDate(dialog.date);
                    })
                }

                Label {
                    id: dateLabel
                    anchors {
                        right: moreImage.left
                        rightMargin: Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    property var selectedDate: {return null}
                    property var monthNames: {return ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                                              ];}
                    property var formatDate: {
                        function(date) {
//                            return "Поезда на " + date.getDate() + " " +
//                                    dateLabel.monthNames[date.getMonth()] + " " +
//                                    date.getFullYear();
                            return Util.formatDateWeekday(date)
                        }
                    }
                    property var areSelectedAndCurrentDateEqual: {
                        function() {
                            var currentDate = new Date();
                            if (dateLabel.selectedDate.getDate() !== currentDate.getDate() ||
                                    dateLabel.selectedDate.getMonth() !== currentDate.getMonth() ||
                                    dateLabel.selectedDate.getFullYear() !== currentDate.getFullYear()) {
                                return false;
                            }
                            return true;
                        }
                    }
                    text: {var currentDate = new Date();
                        dateLabel.selectedDate = currentDate;
                        return Util.formatDateWeekday(currentDate)}
                    color: button.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                }


                Image {
                    id: moreImage
                    anchors {
                        right: parent.right
                        rightMargin: Screen.sizeCategory > Screen.Medium ? Theme.horizontalPageMargin : Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    source: "image://theme/icon-m-right?" + (button.highlighted ? Theme.highlightColor
                                                                                : Theme.primaryColor)
                }

                Component {
                    id: pickerComponent
                    DatePickerDialog {}
                }
            }





            //                //                TextField {
            //                //                    label: "Откуда"
            //                //                    placeholderText: label
            //                //                }
            //                TextField {
            //                    placeholderText: qsTr("Станция отправления")
            //                    label: qsTr("Откуда")
            //                    //                    width: parent.width - IconButton.width
            //                    //                    EnterKey.enabled: text.length > 0
            //                    //                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
            //                    //                    EnterKey.onClicked: textArea.focus = true
            //                }
            //                //                IconButton{
            //                //                    onClicked: doAction()
            //                //                    icon.source:
            //                //                        "image://theme/icon-m-whereami"
            //                //                }
            //        }
        }
    }
}


