#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqmlcontext.h>
#include <qtimer.h>
#include <qdebug.h>
#include <QDir>
#include <QStandardPaths>
#include <QSqlError>

#include "resourcemanager.h"
#include "stations.h"
#include "connections.h"
#include "liveboard.h"
#include "train.h"
#include "sqlfavroutemodel.h"
#include "sqlfavtrainmodel.h"

void connectToDb()
{
    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isValid()) {
        db = QSqlDatabase::addDatabase("QSQLITE");
        if (!db.isValid())
            qDebug() << "Cannot add database: " << db.lastError().text();
    }
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) {
        qDebug() << "There is no " + dir.absolutePath() + " directory";
        if (!dir.mkdir(dir.absolutePath()))
            qDebug() << "Cannot create dir " << dir.absolutePath();
    }
    QString dbName = dir.absolutePath() + "/database.sqlite3";
    db.setDatabaseName(dbName);
    if (!db.open())
        qDebug() << "Cannot open database: " << db.lastError().text();
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    connectToDb();
    // Te wszystkie Connection { id: xx } co idą na stos daj im końcówkę View
    // żeby się z modelami przypadkiem nie waliło
    ResourceManager manager;
    Stations stations(&manager);
    engine.rootContext()->setContextProperty("stations", &stations);

    SqlFavRouteModel favRoutes;
    engine.rootContext()->setContextProperty("favRoutes", &favRoutes);
    SqlFavTrainModel favTrains;
    engine.rootContext()->setContextProperty("favTrains", &favTrains);

    Connections connections(&manager);
    engine.rootContext()->setContextProperty("connections", &connections);

    Liveboard liveboard(&manager);
    engine.rootContext()->setContextProperty("liveboard", &liveboard);

    Train train(&manager);
    engine.rootContext()->setContextProperty("train", &train);

    //
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));    
    //QTimer::singleShot(5000, &connections, SLOT(forTimer()));
    return app.exec();
}
