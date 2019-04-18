#ifndef CONNECTIONS_H
#define CONNECTIONS_H

#include <QString>
#include <QObject>
#include <QStandardItemModel>
#include <QDate>
#include <QObject>

class ResourceManager;

struct ArrDep
{
    Q_GADGET
    Q_PROPERTY(QString station MEMBER m_station)
    Q_PROPERTY(int platform MEMBER m_plaform)
    Q_PROPERTY(QString time READ time)
    Q_PROPERTY(int delay READ delay)
    Q_PROPERTY(int walking MEMBER m_walking)
    Q_PROPERTY(bool canceled MEMBER m_canceled)
    Q_PROPERTY(QString trainId MEMBER m_trainId)
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
    int m_plaform;
    int m_time;
    int m_delay;
    int m_walking;
    bool m_canceled;
    QString m_trainId;
};
Q_DECLARE_METATYPE(ArrDep)

struct Arrival : ArrDep
{
    Q_GADGET
    Q_PROPERTY(bool arrived MEMBER m_arrived)
public:
    bool m_arrived;
    bool operator !=(Arrival a) { return m_arrived != a.m_arrived; }
};
Q_DECLARE_METATYPE(Arrival)

struct Departure : ArrDep
{
    Q_GADGET
    Q_PROPERTY(bool left MEMBER m_left)
public:
    bool m_left;
    bool operator !=(Departure d) { return m_left != d.m_left; }
};
Q_DECLARE_METATYPE(Departure)

struct Via
{
    Q_GADGET
    Q_PROPERTY(Arrival arrival MEMBER m_arrival)
    Q_PROPERTY(Departure departure MEMBER m_departure)
    Q_PROPERTY(int timeBetween READ timeBetween)
public:
    int timeBetween() const { return m_timeBetween / 60; }

    Arrival m_arrival;
    Departure m_departure;
    int m_timeBetween;
};
Q_DECLARE_METATYPE(Via)

struct Connection
{
    Q_GADGET
    Q_PROPERTY(int index READ index)
    Q_PROPERTY(QString duration READ duration)
    Q_PROPERTY(Departure departure MEMBER m_departure)
    Q_PROPERTY(Arrival arrival MEMBER m_arrival)
    Q_PROPERTY(int viasCount READ viasCount)
public:
    int index() const { return m_index; }
    QString duration() const { return QDateTime::fromTime_t(m_duration).toUTC().toString("H:mm"); }
    int viasCount() const {
        int x = m_vias.count();
        return x;
    }

    int m_index;
    int m_duration;
    Departure m_departure;
    Arrival m_arrival;
    QList<Via *> m_vias;
};
Q_DECLARE_METATYPE(Connection)

class Connections : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel *model READ model)
    Q_PROPERTY(QAbstractItemModel *viasModel READ viasModel)
    Q_DISABLE_COPY(Connections)
public:
    Connections(ResourceManager *resourceManager);
    QAbstractItemModel *model() const { return m_model; }
    QAbstractItemModel *viasModel() const { return m_viasModel; }
signals:
    void modelUpdated();
public slots:
    void setViasModel(int idx);
    void getData(QString stationFrom, QString stationTo,
                 QString date, QString time, bool isDeparture);
    void getData(QString stationFrom, QString stationTo);
    QString formatDate(QString dateFromQML);
    QString formatTime(QString timeFromQML);
    int getDeparturePlatform(int index);
    void forTimer();
private slots:
    void prepareModel(const QByteArray &data, const QString &etag);
private:
    ResourceManager *m_resourceManager;
    QString m_stationFrom;
    QString m_stationTo;
    QString m_date;
    QString m_time;
    QString m_etag;
    QList<Connection *> m_connections;
    QAbstractItemModel *m_model;
    QAbstractItemModel *m_viasModel;
};


#endif // CONNECTIONS_H
