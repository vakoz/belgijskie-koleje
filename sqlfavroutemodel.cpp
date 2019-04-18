#include "sqlfavroutemodel.h"
#include <QSqlRecord>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

SqlFavRouteModel::SqlFavRouteModel(QObject *parent)
    : QSqlTableModel(parent)
{
    createTable();
    setTable("FavRoute");
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QVariant SqlFavRouteModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);
    const QSqlRecord route = record(index.row());
    return route.value(role - Qt::UserRole);
}

QHash<int, QByteArray> SqlFavRouteModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole    ] = "stationFrom";
    names[Qt::UserRole + 1] = "stationTo";
    return names;
}

void SqlFavRouteModel::addRoute(QString stationFrom, QString stationTo)
{
    QSqlRecord newRoute = record();
    newRoute.setValue("stationFrom", stationFrom);
    newRoute.setValue("stationTo", stationTo);
    if (!insertRecord(rowCount(), newRoute)) {
        qWarning() << "Route insertion failed" << lastError().text();
        return;
    }
    submitAll();
}

void SqlFavRouteModel::removeRoute(int index)
{
    removeRow(index);
    submitAll();
}

int SqlFavRouteModel::isInDatabase(QString stationFrom, QString stationTo)
{
    for (int row = 0; row < rowCount(); ++row) {
        QSqlRecord data = record(row);
        if (stationFrom == data.value(0) || stationFrom == data.value(1))
            if (stationTo == data.value(0) || stationTo == data.value(1))
                return row;
    }
    return -1;
}

void SqlFavRouteModel::createTable()
{
    if (QSqlDatabase::database().tables().contains("FavRoute"))
        return;
    QSqlQuery query;
    if (!query.exec("CREATE TABLE 'FavRoute' ("
                    "'stationFrom' TEXT NOT NULL,"
                    "'stationTo' TEXT NOT NULL)"))
        qWarning() << "Cannot create 'FavRoute' table " << query.lastError().text();
}
