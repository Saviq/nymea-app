#ifndef LOGSMODEL_H
#define LOGSMODEL_H

#include <QAbstractListModel>

#include "types/logentry.h"

class LogsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(QString deviceId READ deviceId WRITE setDeviceId NOTIFY deviceIdChanged)
    Q_PROPERTY(QString typeId READ typeId WRITE setTypeId NOTIFY typeIdChanged)
    Q_PROPERTY(QDateTime startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(QDateTime endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)

public:
    enum Roles {
        RoleValue
    };
    explicit LogsModel(QObject *parent = nullptr);

    bool busy() const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString deviceId() const;
    void setDeviceId(const QString &deviceId);

    QString typeId() const;
    void setTypeId(const QString &typeId);

    QDateTime startTime() const;
    void setStartTime(const QDateTime &startTime);

    QDateTime endTime() const;
    void setEndTime(const QDateTime &endTime);

    Q_INVOKABLE LogEntry* get(int index) const;

signals:
    void busyChanged();
    void countChanged();
    void deviceIdChanged();
    void typeIdChanged();
    void startTimeChanged();
    void endTimeChanged();

public slots:
    virtual void update();

private slots:
    virtual void logsReply(const QVariantMap &data);

protected:
    QList<LogEntry*> m_list;
    QString m_deviceId;
    QString m_typeId;
    QDateTime m_startTime = QDateTime::currentDateTime().addDays(-1);
    QDateTime m_endTime = QDateTime::currentDateTime();
    bool m_busy = false;

};

#endif // LOGSMODEL_H