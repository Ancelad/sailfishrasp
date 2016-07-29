#ifndef POSITIONING_H
#define POSITIONING_H

#include <QObject>
#include <QString>
#include <QGeoPositionInfo>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QScopedPointer>
#include <QGeoPositionInfoSource>

class Positioning : public QObject
{
    Q_OBJECT
public:
    explicit Positioning(QObject *parent = 0);

    Q_INVOKABLE void getNearestStations(const QGeoPositionInfo &info);

    void setNetworkAccessManager(QNetworkAccessManager* mng);
signals:

public slots:
    void requestFinished(QNetworkReply *reply);
    void positionUpdated(const QGeoPositionInfo &info);
private:
    void parseResponce(QJsonDocument document);

    QString apikey;
    QNetworkAccessManager* manager;
    QScopedPointer<QGeoPositionInfoSource> source;
};

#endif // POSITIONING_H
