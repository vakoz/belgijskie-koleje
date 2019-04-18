#ifndef LIVEBOARD_H
#define LIVEBOARD_H

#include <QObject>
#include <QStandardItemModel>
#include <QDate>

class ResourceManager;
enum InfoType { Departures, Arrivals};

struct LiveData
{
    Q_GADGET
    Q_PROPERTY(QString station MEMBER m_station)
    Q_PROPERTY(QString trainId MEMBER m_trainId)
    Q_PROPERTY(int platform MEMBER m_plaform)
    Q_PROPERTY(QString time READ time)
    Q_PROPERTY(int delay READ delay)
    Q_PROPERTY(bool canceled MEMBER m_canceled)
    Q_PROPERTY(bool left MEMBER m_left)
public:
    QString time() const { return getFormatedTime(m_time); }
    int delay() const { return m_delay / 60; }
    QString getFormatedTime(int unixTime) const
    {
        QDateTime date;
        date.setTime_t(unixTime);
        return date.time().toString("hh:mm");
    }
    QString m_station;
    QString m_trainId;
    int m_plaform;
    int m_time;
    int m_delay;
    bool m_canceled;
    bool m_left;
};

class Liveboard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel *arrivals READ arrivals)
    Q_PROPERTY(QAbstractItemModel *departures READ departures)
public:
    Liveboard(ResourceManager *resourceManager);
    ~Liveboard();
    QString stationId() const { return m_stationId; }
    QAbstractItemModel *arrivals() { return m_arrivals; }
    QAbstractItemModel *departures() { return m_departures; }
signals:
    void modelUpdated(InfoType type);
public slots:
    void prepareModel(const QByteArray &data, const QString &etag);
    void getData(QString stationId, int type);
private:
    ResourceManager *m_resourceManager;
    QString m_stationId;
    QString m_stationName;
    QString m_etag;
    QAbstractItemModel *m_arrivals;
    QAbstractItemModel *m_departures;
};

#endif // LIVEBOARD_H
