#pragma once
#include <QObject>
#include <qnetworkaccessmanager.h>

struct Parameter;

class ResourceManager : public QObject
{
    Q_OBJECT

public:
    ResourceManager(QObject *parent = nullptr);
    ~ResourceManager();
    void download(QString resource, const QString &etag, const QList<Parameter> params);
    void download(QString resource, const QString &etag);
signals:
    void stationsDownloaded(const QByteArray &data, const QString &etag);
    void trainDownloaded(const QByteArray &data, const QString &etag);
    void liveboardDownloaded(const QByteArray &data, const QString &etag);
    void connectionsDownloaded(const QByteArray &data, const QString &etag);

private:
    QNetworkAccessManager m_manager;

    const QString apiUrl = "https://api.irail.be";

    QString prepareUrl(const QString &resource, const QList<Parameter> params);
    QString prepareUrl(const QString &resource);
};

struct Parameter
{
    QString param;
    QString value;
};
