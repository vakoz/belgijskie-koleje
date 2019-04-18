#pragma once

#include <QObject>
class ResourceManager;

class Stations : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList model READ model NOTIFY modelChanged)
public:
    Stations(ResourceManager *resourceManager);
    ~Stations() {}
    QStringList model() const { return m_model; }
public slots:
    void prepareModel(const QByteArray &data, const QString &etag);
signals:
    void modelChanged();
private:
    void readStationsFromFile();
    void saveStationsToFile();
    void createStationsModel(const QByteArray &data);

    ResourceManager *m_resourceManager;
    QStringList m_model;
    QString m_etag;
};
