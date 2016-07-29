#ifndef SQLTOQML_H
#define SQLTOQML_H

#include <QObject>
#include <QtSql/QtSql>
#include "searchhint.h"

class SQLtoQML : public QObject
{
    Q_OBJECT
public:
    explicit SQLtoQML(QObject *parent = 0);
    Q_INVOKABLE QList<QObject*> getHints(QString text, int zone);
signals:

private:
    void loaddb();
    QSqlDatabase sdb;
public slots:

};

#endif // SQLTOQML_H
