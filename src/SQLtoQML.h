#ifndef SQLTOQML_H
#define SQLTOQML_H

#include <QObject>
#include <QtSql/QtSql>
#include "SearchHint.h"

class SQLtoQML : public QObject
{
    Q_OBJECT
public:
    SQLtoQML(QObject *parent = 0);
    Q_INVOKABLE QList<QObject*> getHints(QString text, int zone);
    Q_INVOKABLE QList<QObject*> getZonesLike(QString text);
    Q_INVOKABLE QList<QObject*> getAllZones();

signals:

public slots:

};

#endif // SQLTOQML_H
