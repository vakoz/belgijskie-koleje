#ifndef STATIONOBJ_H
#define STATIONOBJ_H

#include <QObject>


class StationObj : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<> author READ author WRITE setAuthor NOTIFY authorChanged)
public:
    Message(QObject *parent = nullptr);
    void setAuthor(const QString &a) {
        if (a != m_author) {
            m_author = a;
            emit authorChanged();
        }
    }
    QString author() const {
        return m_author;
    }
public slots:
    void forTimer(){ setAuthor("From timer"); }
signals:
    void authorChanged();
private:
    QString m_author;
};

#endif // STATIONOBJ_H
