#ifndef SQLFAVTRAINMODEL_H
#define SQLFAVTRAINMODEL_H

#include <QSqlTableModel>

class SqlFavTrainModel : public QSqlTableModel
{
    Q_OBJECT
public:
    SqlFavTrainModel(QObject *parent = Q_NULLPTR);
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void addTrain(QString trainId, QString stationFrom, QString stationTo, QString departureTime, QString arrivalTime);
    Q_INVOKABLE void removeTrain(int index);
    Q_INVOKABLE int isInDatabase(QString trainId);
private:
    void createTable();
};

#endif // SQLFAVTRAINMODEL_H
