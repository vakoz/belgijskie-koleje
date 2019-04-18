#ifndef SQLFAVRouteMODEL_H
#define SQLFAVRouteMODEL_H
#include <QSqlTableModel>

class SqlFavRouteModel : public QSqlTableModel
{
    Q_OBJECT
public:
    SqlFavRouteModel(QObject *parent = Q_NULLPTR);
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void addRoute(QString stationFrom, QString stationTo);
    Q_INVOKABLE void removeRoute(int rowid);
    Q_INVOKABLE int isInDatabase(QString stationFrom, QString stationTo);
private:
    void createTable();
};

#endif // SQLFAVRouteMODEL_H
