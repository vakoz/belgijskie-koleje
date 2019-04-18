#include "sqlfavtrainmodel.h"
#include <QSqlRecord>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

SqlFavTrainModel::SqlFavTrainModel(QObject *parent)
    : QSqlTableModel(parent)
{
    createTable();
    setTable("FavTrain");
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QVariant SqlFavTrainModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);
    const QSqlRecord route = record(index.row());
    return route.value(role - Qt::UserRole);
}

QHash<int, QByteArray> SqlFavTrainModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole    ] = "trainId";
    names[Qt::UserRole + 1] = "stationFrom";
    names[Qt::UserRole + 2] = "stationTo";
    names[Qt::UserRole + 3] = "departureTime";
    names[Qt::UserRole + 4] = "arrivalTime";
    return names;
}

void SqlFavTrainModel::addTrain(QString trainId, QString stationFrom, QString stationTo, QString departureTime, QString arrivalTime)
{
    QSqlRecord newTrain = record();
    newTrain.setValue("trainId", trainId);
    newTrain.setValue("stationFrom", stationFrom);
    newTrain.setValue("stationTo", stationTo);
    newTrain.setValue("departureTime", departureTime);
    newTrain.setValue("arrivalTime", arrivalTime);
    if (!insertRecord(rowCount(), newTrain)) {
        qWarning() << "Train insertion failed" << lastError().text();
        return;
    }
    submitAll();
}

void SqlFavTrainModel::removeTrain(int index)
{
    removeRow(index);
    submitAll();
}

int SqlFavTrainModel::isInDatabase(QString trainId)
{
    for (int row = 0; row < rowCount(); ++row) {
        QSqlRecord data = record(row);
        if (trainId == data.value(0))
            return row;
    }
    return -1;
}

void SqlFavTrainModel::createTable()
{
    if (QSqlDatabase::database().tables().contains("FavTrain"))
        return;
    QSqlQuery query;
    if (!query.exec("CREATE TABLE 'FavTrain' ("
                    "'trainId' TEXT NOT NULL,"
                    "'stationFrom' TEXT NOT NULL,"
                    "'stationTo' TEXT NOT NULL,"
                    "'departureTime' TEXT NOT NULL,"
                    "'arrivalTime' TEXT NOT NULL)"))
        qWarning() << "Cannot create 'FavRoute' table " << query.lastError().text();
}

