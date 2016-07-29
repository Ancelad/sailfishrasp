#include "Positioning.h"

#include <QNetworkRequest>

Positioning::Positioning(QObject *parent)
    : QObject(parent)
    , apikey("20e7cb3e-6b05-4774-bcbb-4b0fb74a58b0")
    , source(QGeoPositionInfoSource::createDefaultSource())
{
    connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                        this, SLOT(positionUpdated(QGeoPositionInfo)));
    source->startUpdates();
}

void Positioning::getNearestStations(const QGeoPositionInfo &info)
{
    QString url = QString("https://api.rasp.yandex.net/v1.0/nearest_stations/?&apikey=%1&format=json&lat=%2&lng=%3&distance=50&lang=ru&transport_types=train")
            .arg(apikey, info.coordinate().latitude(), info.coordinate().longitude());

    QNetworkRequest request(QUrl(url));
    manager->get(request);
}

void Positioning::setNetworkAccessManager(QNetworkAccessManager *mng)
{
    manager = mng;
    connect(_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
}

void Positioning::requestFinished(QNetworkReply *reply)
{
    parseResponce(QJsonDocument::fromBinaryData(reply->readAll());
}

void Positioning::positionUpdated(const QGeoPositionInfo &info)
{
    source->stopUpdates();
    getNearestStations(info);
}

void Positioning::parseResponce(QJsonDocument document)
{

}

