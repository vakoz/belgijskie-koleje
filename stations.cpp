#include "stations.h"
#include "resourcemanager.h"
#include <qdom.h>
#include <qtconcurrentrun.h>
#include <QtWidgets>

Stations::Stations(ResourceManager *resourceManager)
    : m_resourceManager(resourceManager)
{
    connect(m_resourceManager,&ResourceManager::stationsDownloaded,
            this, &Stations::prepareModel);
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    QString etag = NULL;
    if (!dir.exists())
        qDebug() << "There is no " + dir.absolutePath() + " directory";
    QFile file(dir.absolutePath() + "/stations.txt");
    if (!file.exists())
        qDebug() << "There is no " + file.fileName() + " file";
    if (file.open(QIODevice::ReadOnly))
        etag = file.readLine();
    else
        qDebug() << "Cannot open " + file.fileName() + " file";
    etag = etag.simplified();
    m_resourceManager->download("stations", etag);
}

void Stations::prepareModel(const QByteArray &data, const QString &etag)
{
    if (!data.isEmpty()) {
        m_etag = etag;
        createStationsModel(data);
    }
    else
        readStationsFromFile();
    emit modelChanged();
}

void Stations::readStationsFromFile()
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    QFile file(dir.absolutePath() + "/stations.txt");
    if (!file.open(QIODevice::ReadOnly))
        qDebug() << "Cannot open " + file.fileName() + " file";
    QTextStream in(&file);
    in.readLine();//omitting first line, cause it's an etag
    while (!in.atEnd())
        m_model.append(in.readLine());
}

void Stations::saveStationsToFile()
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) {
        qDebug() << "There is no " + dir.absolutePath() + " directory";
        if (!dir.mkdir(dir.absolutePath()))
            qDebug() << "Cannot create dir " << dir.absolutePath();
    }
    QFile file(dir.absolutePath() + "/stations.txt");
    if (file.open(QIODevice::WriteOnly)) {
        QTextStream stream(&file);
        stream << m_etag;
        for (int i = 0; i < m_model.count(); ++i)
            stream << endl << m_model[i];
    }
    else
        qDebug() << "Cannot open " + file.fileName() << +" file for writing" << endl;
}

void Stations::createStationsModel(const QByteArray &data)
{
    QDomDocument document;
    document.setContent(data);
    QDomElement root = document.firstChildElement();
    QDomElement station = root.firstChildElement();
    for (; !station.isNull(); station = station.nextSiblingElement()) {
        QString name = station.text(); //name
        m_model.append(name.split('/'));
    }
    m_model.sort();
    QFuture<void> f = QtConcurrent::run(this, &Stations::saveStationsToFile);
}
