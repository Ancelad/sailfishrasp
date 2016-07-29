#ifndef SEARCHHINT_H
#define SEARCHHINT_H

#include <QObject>

class SearchHint : public QObject
{
     Q_OBJECT
     Q_PROPERTY(QString title READ title)
     Q_PROPERTY(int esr READ esr)

 public:
     explicit SearchHint(QObject *parent = 0);
     SearchHint(QString title, int id, QObject *parent = 0);

 public slots:
     QString title() { return _title; }
     int esr() { return _id; }

 private:
     QString _title;
     int _id;
};

#endif // SEARCHHINT_H
