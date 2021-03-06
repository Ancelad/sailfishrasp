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
import Sailfish.Silica 1.0
import subtrains 1.0

Page {
    id: page
    property QmlHandler qmlHandler

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: true
    }

    Connections {
        target: qmlHandler
        onThreadsListRecieved: {
            busyIndicator.running = false;
            viewPlaceholder.text =
                    qsTr("Не нашлось подходящих маршрутов :(");
        }
        onErrorRecievingThreads: {
            busyIndicator.running = false;
            viewPlaceholder.text =
                    qsTr("Что-то пошло не так. " +
                    "Пожалуйста, проверьте, что у вас включена " +
                    "передача данных " +
                    "и попробуйте снова");
        }
    }

    SilicaListView {
        //    ListView {
        id: listView
        model: qmlHandler.routeModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Маршруты по направлению")
        }
        ViewPlaceholder {
            id: viewPlaceholder
            enabled: listView.count == 0 && !busyIndicator.running
            text: ""
        }
        delegate: ListItem {
            id: delegate
            contentHeight: Theme.itemSizeLarge
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }
            Column {
                id: leftColumn
                anchors.left: parent.left
                Label {
                    id: departureTime
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    text: modelData.departure.substring(11,16)
                }
                Label {
                    id: arrivalTime
                    anchors.horizontalCenter: leftColumn.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: modelData.arrival.substring(11,16)
                }
            }
            Label {
                id: centerLabel
                anchors {
                    left: leftColumn.right
                    right: rightColumn.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                text: modelData.thread.title

            }
            Column {
                id: rightColumn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    id: duration
                    text: modelData.duration / 60 + qsTr(" мин.")
                }

            }
            onClicked: {
                qmlHandler.getTrainInfo(modelData.thread.uid, new Date(modelData.departure));
                pageStack.push(Qt.resolvedUrl("ThreadInfo.qml"), {qmlHandler: qmlHandler});
            }
        }
        VerticalScrollDecorator{}
    }
}

