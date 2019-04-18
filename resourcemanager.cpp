#include "resourcemanager.h"
#include <qnetworkaccessmanager.h>
#include <qnetworkreply.h>

ResourceManager::ResourceManager(QObject *parent)
    : QObject(parent)
    , m_manager(this)
{
    connect(&m_manager, &QNetworkAccessManager::finished, this,
        [this](QNetworkReply *reply) {
        if (reply->error()) {
            qDebug() << reply->errorString();
            return;
        }
        if (!reply->hasRawHeader("etag"))
            qDebug() << "etag header is missing in reply from server";
        QByteArray etag = reply->rawHeader("etag");
        const QByteArray &data = reply->readAll();
        QString url = reply->url().path();
        if (url.startsWith("/vehicle"))
            emit trainDownloaded(data, etag);
        if (url.startsWith("/stations"))
            emit stationsDownloaded(data, etag);
        if (url.startsWith("/liveboard"))
            emit liveboardDownloaded(data, etag);
        if (url.startsWith("/connections"))
            emit connectionsDownloaded(data, etag);
    });
}

ResourceManager::~ResourceManager()
{
}

void ResourceManager::download(QString resource, const QString &etag, const QList<Parameter> params)
{
    QString url = prepareUrl(resource, params);
    QNetworkRequest request(url);
    if (!etag.isNull())
        request.setRawHeader("If-None-Match", etag.toLatin1());
    qDebug() << request.rawHeader("If-None-Match");
    m_manager.get(request);
}

void ResourceManager::download(QString resource, const QString &etag)
{
    QString url = prepareUrl(resource);
    QNetworkRequest request(url);
    if (!etag.isNull())
        request.setRawHeader("If-None-Match", etag.toLatin1());
    qDebug() << request.rawHeader("If-None-Match");
    m_manager.get(request);
}

QString ResourceManager::prepareUrl(const QString &resource, const QList<Parameter> params)
{
    QString url = prepareUrl(resource);
    int i = 0;
    url += QString("?%1=%2").arg(params[i].param, params[i].value).replace(' ', "%20");
    for (++i; i != params.count(); ++i)
        url += QString("&%1=%2").arg(params[i].param, params[i].value).replace(' ', "%20");
    return url;
}

QString ResourceManager::prepareUrl(const QString &resource)
{
    return apiUrl + '/' + resource + '/';
}
