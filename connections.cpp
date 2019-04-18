#include "connections.h"
#include "resourcemanager.h"
#include <qdom.h>
#include <QStandardItemModel>
#include <QDebug>

Connections::Connections(ResourceManager *resourceManager)
    : QObject(Q_NULLPTR)
    , m_resourceManager(resourceManager)
    , m_model(new QStandardItemModel(this))
    , m_viasModel(new QStandardItemModel(this))
{
    m_model->insertColumn(0);
    m_viasModel->insertColumn(0);
    connect(m_resourceManager, &ResourceManager::connectionsDownloaded, this, &Connections::prepareModel);

}

//Connections::~Connections()
//{
//}

void Connections::getData(QString stationFrom, QString stationTo,
                          QString date, QString time, bool isDeparture)
{
    m_stationFrom = stationFrom;
    m_stationTo = stationTo;
    m_date = date;
    m_time = time;
    QList<Parameter> args({ {"from", m_stationFrom}, {"to", m_stationTo}, {"time", m_time},
        {"date", m_date} });
    if (!isDeparture)
        args.append({ "timeSel", "arrival" });
    m_resourceManager->download("connections", m_etag, args);
}

void Connections::getData(QString stationFrom, QString stationTo)
{
    m_stationFrom = stationFrom;
    m_stationTo = stationTo;
    QList<Parameter> args({ {"from", m_stationFrom}, {"to", m_stationTo} });
    m_resourceManager->download("connections", m_etag, args);
}

QString Connections::formatDate(QString dateFromQML)
{
    qDebug() << "Data: " << dateFromQML;
    QString months[] = {"sty", "lut", "mar", "kwi", "maj", "cze", "lip", "sie", "wrz",
                       "paź", "lis", "gru"};
    QList<QString> partsOfDate = dateFromQML.split(" ");
    int dayInt = partsOfDate[0].toInt();
    QString day = dayInt > 10 ? partsOfDate[0] : QString("0%1").arg(dayInt);
    QString month;
    for (int i = 0; i < 12; ++i)
        if (partsOfDate[1].startsWith(months[i])) {
            ++i;
            month = i < 10 ? QString("0%1").arg(i) : QString::number(i);
            break;
        }
    QString year = partsOfDate[2].right(2);
    return day + month + year;
}

QString Connections::formatTime(QString timeFromQML)
{
    QList<QString> timeData = timeFromQML.split(" ");
    QString hour = timeData[0].toInt() > 10 ? timeData[0] : QString("0%1").arg(timeData[0]);
    QString minutes = timeData[1].toInt() > 10 ? timeData[1] : QString("0%1").arg(timeData[1]);
    return hour + minutes;
}

void Connections::prepareModel(const QByteArray &data, const QString &etag)
{
    if (m_etag == etag)
        return;
    m_etag = etag;
    m_connections.clear();
    QDomDocument document;
    document.setContent(data);
    QDomElement root = document.firstChildElement();
    QDomElement connection = root.firstChildElement();
    int conIndex = 0;
    for (; !connection.isNull(); connection = connection.nextSiblingElement()) {
        Connection *con = new Connection;
        con->m_index = conIndex++;
        m_connections.append(con);
        QDomElement connectionMember = connection.firstChildElement();
        for (; !connectionMember.isNull(); connectionMember = connectionMember.nextSiblingElement()) {
            QString tagName = connectionMember.tagName();
            if (tagName == "duration")
                con->m_duration = connectionMember.text().toInt(); //duration
            else if (tagName == "departure" || tagName == "arrival") {
                ArrDep *ad;
                if (tagName.startsWith('d')) {
                    con->m_departure.m_left = connectionMember.attribute("left").toInt(); //left
                    ad = &con->m_departure;
                }
                else {
                    con->m_arrival.m_arrived =  connectionMember.attribute("arrived").toInt(); //arrived
                    ad = &con->m_arrival;
                }
                ad->m_delay = connectionMember.attribute("delay").toInt(); //delay
                ad->m_walking = connectionMember.attribute("walking").toInt(); //walking
                ad->m_canceled = connectionMember.attribute("canceled").toInt(); //canceled
                ad->m_station =  connectionMember.firstChildElement("station").text(); //station
                ad->m_time =  connectionMember.firstChildElement("time").text().toInt(); //time
                ad->m_plaform = connectionMember.firstChildElement("platform").text().toInt(); //platform
                QDomElement trainElement = connectionMember.firstChildElement("vehicle");
                QString trainId = trainElement.text();
                int lastSlash = trainId.lastIndexOf('.');
                trainId = trainId.right(trainId.size() - (lastSlash + 1));
                ad->m_trainId = trainId; //trainId
            }
            else if (tagName == "vias") {
                QDomElement viaDomEl = connectionMember.firstChildElement();
                for (; !viaDomEl.isNull(); viaDomEl = viaDomEl.nextSiblingElement()) {
                    Via *via = new Via;
                    con->m_vias.append(via);
                    //timeBetween
                    via->m_timeBetween = viaDomEl.firstChildElement("timeBetween").text().toInt();
                    via->m_departure.m_station = via->m_arrival.m_station
                        = viaDomEl.firstChildElement("station").text(); //station, for both same
                    qDebug() << viaDomEl.firstChildElement("station").text();
                    //Arrival
                    QDomElement arrival = viaDomEl.firstChildElement("arrival");
                    via->m_arrival.m_delay = arrival.attribute("delay").toInt(); //arrDelay
                    via->m_arrival.m_arrived = arrival.attribute("arrived").toInt(); //arrArrived
                    via->m_arrival.m_walking = arrival.attribute("walking").toInt(); //arrWalking
                    via->m_arrival.m_canceled = arrival.attribute("canceled").toInt(); //arrCanceled
                    via->m_arrival.m_time = arrival.firstChildElement("time").text().toInt(); //arrTime
                    //arrPlatform
                    via->m_arrival.m_plaform = arrival.firstChildElement("platform").text().toInt();
                    QDomElement arrTrainElement = arrival.firstChildElement("vehicle");
                    QString arrTrain = arrTrainElement.text();
                    int lastSlash = arrTrain.lastIndexOf('.');
                    arrTrain = arrTrain.right(arrTrain.size() - (lastSlash + 1));
                    via->m_arrival.m_trainId = arrTrain; //arrTrain

                    //Departure
                    QDomElement departure = viaDomEl.firstChildElement("departure");
                    via->m_departure.m_delay = departure.attribute("delay").toInt(); //depDelay
                    via->m_departure.m_left = departure.attribute("left").toInt(); //depLeft
                    via->m_departure.m_walking = departure.attribute("walking").toInt(); //depWalking
                    via->m_departure.m_canceled = departure.attribute("canceled").toInt(); //depCanceled
                    via->m_departure.m_time = departure.firstChildElement("time").text().toInt(); //depTime
                        //depPlatform
                    via->m_departure.m_plaform = departure.firstChildElement("platform").text().toInt();
                    QDomElement depTrainElement = departure.firstChildElement("vehicle");
                    QString depTrain = depTrainElement.text();
                    lastSlash = depTrain.lastIndexOf('.');
                    depTrain = depTrain.right(depTrain.size() - (lastSlash + 1));
                    via->m_departure.m_trainId = depTrain; //depTrain
                }
            }
        }
    }
    for (int i = 0; i < m_connections.count(); ++i) {
        Connection connection = *(m_connections[i]);
        m_model->insertRow(i);
        m_model->setData(m_model->index(i,0), QVariant::fromValue(connection), Qt::EditRole);

    }
    emit modelUpdated();
}

void Connections::setViasModel(int idx)
{
    m_viasModel->removeRows(0, m_viasModel->rowCount());
    QVariant v  = m_model->index(idx, 0).data(Qt::EditRole);
    Connection con = v.value<Connection>();
    Via via;
    via.m_departure = con.m_departure;
    via.m_arrival = con.m_vias[0]->m_arrival;
    via.m_timeBetween = con.m_vias[0]->m_timeBetween;
    m_viasModel->insertRow(0);
    m_viasModel->setData(m_viasModel->index(0, 0), QVariant::fromValue(via), Qt::EditRole);
    int i = 0;
    for (; i < con.m_vias.count() - 1; ++i) {
        Via via;
        via.m_departure = con.m_vias[i]->m_departure;
        via.m_arrival = con.m_vias[i + 1]->m_arrival;
        via.m_timeBetween = con.m_vias[i + 1]->m_timeBetween;
        m_viasModel->insertRow(i + 1);
        m_viasModel->setData(m_viasModel->index(i + 1, 0), QVariant::fromValue(via), Qt::EditRole);
    }
    Via viaEnding;
    viaEnding.m_departure = con.m_vias[i]->m_departure;
    viaEnding.m_arrival = con.m_arrival;
    viaEnding.m_timeBetween = - 1;
    m_viasModel->insertRow(i + 1);
    m_viasModel->setData(m_viasModel->index(i + 1, 0), QVariant::fromValue(viaEnding), Qt::EditRole);

}

int Connections::getDeparturePlatform(int index)
{
    QVariant v  = m_viasModel->index(index, 0).data(Qt::EditRole);
    Via via = v.value<Via>();
    return via.m_departure.m_plaform;
}

void Connections::forTimer()
{
    getData("Hasselt", "Brugge", "220818", "1209", true);
}

/*
ok, czyli arrival i departure w via, to jest przyjazd i odjazd ze stacji pośredniej.
Pociągi oraz kierunki, które jadą będą się różnić oczywiście.
Czyli z normalnego departure numer pociągu i kierunek są takie same jak arrival z pierwszego via,
z normalnego arrival pokrywa się departure ostatniego via

godzina odjazdu | nazwa stacji | peron | opóźnienie || trainId
Czas na przesiadkę:
godzina przyjazdu | nazwa stacji | peron | opóźnienie ||trainId
kliknięcie da trainView a tam pierdoły typu direction etc już są
*/
