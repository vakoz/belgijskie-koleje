#ifndef TRAIN_H
#define TRAIN_H

#include <QObject>
#include <QAbstractItemModel>
#include <QDate>
class ResourceManager;


struct Stop
{
    Q_GADGET
    Q_PROPERTY(QString station MEMBER m_station)
    Q_PROPERTY(QString scheduledArrivalTime READ scheduledArrivalTime)
    Q_PROPERTY(QString scheduledDepartureTime READ scheduledArrivalTime)
    Q_PROPERTY(int platform MEMBER m_platform)
    Q_PROPERTY(int arrivalDelay READ arrivalDelay)
    Q_PROPERTY(int departureDelay READ departureDelay)
    Q_PROPERTY(bool arrivalCanceled MEMBER m_arrivalCanceled)
    Q_PROPERTY(bool departureCanceled MEMBER m_departureCanceled)
    Q_PROPERTY(bool left MEMBER m_left)
public:
    QString scheduledArrivalTime() const { return getFormatedTime(m_scheduledArrivalTime); }
    QString scheduledDepartureTime() const { return getFormatedTime(m_scheduledDepartureTime); }
    int arrivalDelay() const { return m_arrivalDelay / 60; }
    int departureDelay() const { return m_departureDelay / 60; }
    QString getFormatedTime(int unixTime) const
    {
        QDateTime date;
        date.setTime_t(unixTime);
        return date.time().toString("hh:mm");
    }

    QString m_station;
    int m_scheduledArrivalTime;
    int m_scheduledDepartureTime;
    int m_platform;
    int m_arrivalDelay;
    int m_departureDelay;
    bool m_arrivalCanceled;
    bool m_departureCanceled;
    bool m_left;
};

class Train : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel *stops READ stops)
public:
    Train(ResourceManager *resourceManager);
    ~Train();
    QAbstractItemModel *stops() { return m_stops; }
signals:
    void modelUpdated();
public slots:
    void getData(QString trainId);
    void prepareModel(const QByteArray &data, const QString &etag);
private:
    ResourceManager *m_resourceManager;
    QString m_id;
    QString m_etag;
    QAbstractItemModel *m_stops;
};

#endif // TRAIN_H
