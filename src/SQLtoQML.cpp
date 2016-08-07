#include "SQLtoQML.h"
#include <QtSql/QtSql>
#include "sailfishapp.h"

SQLtoQML::SQLtoQML(QObject *parent)
    : QObject(parent)
{
}

QList<QObject*> SQLtoQML::getHints(QString text, int zone)
{
    QSqlQuery query;

    query.prepare("SELECT title, esr FROM station "
                  "WHERE "
                  "zone=:zone AND "
                  "(UPPER(title) LIKE :title "
                  "OR UPPER(popular_title) LIKE :title "
                  "OR UPPER(short_title) LIKE :title "
                  ") "
                  "ORDER BY importance, title LIMIT 5; ");
    query.bindValue(":title", text.toUpper() + "%");
    query.bindValue(":zone", zone);
    if (!query.exec()) {
        qDebug() << "SQL query error: " << query.lastError().text();
    }

    QSqlRecord rec = query.record();
    QList<QObject*> hints;

    while (query.next()) {
        int esr = query.value(rec.indexOf("esr")).toInt();
        QString title = query.value(rec.indexOf("title")).toString();
        hints.append(new SearchHint(title, esr));
    }

    return hints;
}

QList<QObject *> SQLtoQML::getZonesLike(QString text)
{
    QSqlQuery query;

    query.prepare("select id, settlement_title from zone "
                  "where settlement_title LIKE :settlement_title "
                  "order by settlement_title ASC");
    query.bindValue(":settlement_title", text.toUpper() + "%");
    query.exec();

    QList<QObject*> zones;
    while (query.next()) {
        zones.append(new SearchHint(
                             query.value("settlement_title").toString()
                           , query.value("id").toInt()
                         ));
    }

    return zones;
}

QList<QObject *> SQLtoQML::getAllZones()
{
    QSqlQuery query;

    query.exec("select id, settlement_title from zone "
                  "order by settlement_title ASC");

    QList<QObject*> zones;
    while (query.next()) {
        zones.append(new SearchHint(
                             query.value("settlement_title").toString()
                           , query.value("id").toInt()
                         ));
    }

    return zones;
}
