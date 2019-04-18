#include "train.h"
#include <resourcemanager.h>
#include <qstandarditemmodel.h>
#include <qdom.h>

Train::Train(ResourceManager *resoruceManager)
    : QObject(Q_NULLPTR)
    , m_resourceManager(resoruceManager)
    , m_stops(new QStandardItemModel(this))
{
    m_stops->insertColumn(0);
    connect(m_resourceManager, &ResourceManager::trainDownloaded, this, &Train::prepareModel);
}

Train::~Train()
{
}

void Train::getData(QString trainId)
{
    m_id = trainId;
    m_resourceManager->download("vehicle", m_etag, QList<Parameter>({ {"id", m_id} }));
}

void Train::prepareModel(const QByteArray &data, const QString &etag)
{
    if (m_etag == etag) //nothing has change
        return;
    m_etag = etag;
    m_stops->removeRows(0, m_stops->rowCount());
    QDomDocument document;
    document.setContent(data);
    QDomElement root = document.firstChildElement();
    QString trainId = root.firstChild().toElement().attribute("shortname"); //id
    QDomNode stops = root.firstChildElement("stops");
    QDomElement stop = stops.firstChildElement("stop");
    for (; !stop.isNull(); stop = stop.nextSiblingElement("stop")) {
        Stop stopData;
        stopData.m_station = stop.firstChildElement("station").text(); //station
        stopData.m_scheduledDepartureTime =
            stop.firstChildElement("scheduledDepartureTime").text().toInt(); //scheduledDepartureTime
        stopData.m_scheduledArrivalTime =
            stop.firstChildElement("scheduledArrivalTime").text().toInt(); //scheduledArrivalTime
        stopData.m_left = stop.attribute("left").toInt(); //left
        stopData.m_platform = stop.firstChildElement("platform").text().toInt(); //platform
        stopData.m_departureDelay =  stop.firstChildElement("departureDelay").text().toInt(); //departureDelay
        stopData.m_departureCanceled = stop.firstChildElement("departureCanceled").text().toInt(); //departureCanceled
        stopData.m_arrivalDelay = stop.firstChildElement("arrivalDelay").text().toInt(); //arrivalDelay
        stopData.m_arrivalCanceled = stop.firstChildElement("arrivalCanceled").text().toInt(); //arrivalCanceled
        int newIndex = m_stops->rowCount();
        m_stops->insertRow(newIndex);
        m_stops->setData(m_stops->index(newIndex,0), QVariant::fromValue(stopData),Qt::EditRole);
    }
    emit modelUpdated();
}

