#include "liveboard.h"
#include "resourcemanager.h"
#include <qdom.h>

Liveboard::Liveboard(ResourceManager *resourceManager)
    : QObject(Q_NULLPTR)
    , m_resourceManager(resourceManager)
    , m_arrivals(new QStandardItemModel(this))
    , m_departures(new QStandardItemModel(this))
{
    m_arrivals->insertColumn(0);
    m_departures->insertColumn(0);
    connect(m_resourceManager, &ResourceManager::liveboardDownloaded, this, &Liveboard::prepareModel);
}

Liveboard::~Liveboard()
{
}

void Liveboard::getData(QString stationId, int type)
{
    m_stationId = stationId;
    if (type == InfoType::Arrivals)
        m_resourceManager->download("liveboard", m_etag,
            QList<Parameter>({ { "id", m_stationId }, { "arrdep", "arrival" } }));
    else
        m_resourceManager->download("liveboard", m_etag, QList<Parameter>({ { "id", m_stationId } }));
}

void Liveboard::prepareModel(const QByteArray &data, const QString &etag)
{
    m_etag = etag;
    QDomDocument document;
    document.setContent(data);
    QDomElement root = document.firstChildElement();
    QDomElement arrdeps = root.lastChildElement(); //arrivals or departur; we don't know
    InfoType type = arrdeps.tagName() == "departures" ? InfoType::Departures : InfoType::Arrivals;

    if (type == InfoType::Departures) //clear old data
        m_departures->removeRows(0, m_departures->rowCount());
    else
        m_arrivals->removeRows(0, m_arrivals->rowCount());

    QDomElement arrdep = arrdeps.firstChildElement();
    for (; !arrdep.isNull(); arrdep = arrdep.nextSiblingElement()) {
        LiveData liveData;
        liveData.m_delay = arrdep.attribute("delay").toInt(); //delay
        liveData.m_canceled = arrdep.attribute("canceled").toInt(); //canceled
        liveData.m_left = arrdep.attribute("left").toInt(); //left
        liveData.m_station = arrdep.firstChildElement("station").text(); //station
        liveData.m_plaform = arrdep.firstChildElement("platform").text().toInt(); //platform
        liveData.m_time = arrdep.firstChildElement("time").text().toInt(); //time
        QDomElement trainElement = arrdep.firstChildElement("vehicle");
        QString trainId = trainElement.attribute("URI");
        int lastSlash = trainId.lastIndexOf('/');
        trainId = trainId.right(trainId.size() - (lastSlash + 1));
        liveData.m_trainId = trainId; //trainId
        if (type == InfoType::Departures) {
            int newIndex = m_departures->rowCount();
            m_departures->insertRow(newIndex);
            m_departures->setData(m_departures->index(newIndex,0)
                                , QVariant::fromValue(liveData), Qt::EditRole);
        }
        else {
            int newIndex = m_arrivals->rowCount();
            m_arrivals->insertRow(newIndex);
            m_arrivals->setData(m_arrivals->index(newIndex,0)
                                , QVariant::fromValue(liveData), Qt::EditRole);
        }
    }
    if (type == InfoType::Departures)
        emit modelUpdated(InfoType::Departures);
    else
        emit modelUpdated(InfoType::Arrivals);
}
