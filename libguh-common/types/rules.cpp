#include "rules.h"
#include "rule.h"

Rules::Rules(QObject *parent) : QAbstractListModel(parent)
{

}

void Rules::clear()
{
    beginResetModel();
    qDeleteAll(m_list);
    m_list.clear();
    endResetModel();
    emit countChanged();
}

int Rules::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_list.count();
}

QVariant Rules::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case RoleName:
        return m_list.at(index.row())->name();
    case RoleId:
        return m_list.at(index.row())->id();
    case RoleEnabled:
        return m_list.at(index.row())->enabled();
    case RoleActive:
        return m_list.at(index.row())->active();
    }
    return QVariant();
}

QHash<int, QByteArray> Rules::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleName, "name");
    roles.insert(RoleId, "id");
    roles.insert(RoleEnabled, "enabled");
    roles.insert(RoleActive, "active");
    return roles;
}

void Rules::insert(Rule *rule)
{
    rule->setParent(this);
    beginInsertRows(QModelIndex(), m_list.count(), m_list.count());
    m_list.append(rule);
    endInsertRows();
    emit countChanged();
}

void Rules::remove(const QUuid &ruleId)
{
    for (int i = 0; i < m_list.count(); i++) {
        if (m_list.at(i)->id() == ruleId) {
            beginRemoveRows(QModelIndex(), i, i);
            m_list.takeAt(i)->deleteLater();
            endRemoveRows();
            emit countChanged();
            return;
        }
    }
}

Rule *Rules::get(int index) const
{
    if (index < 0 || index >= m_list.count()) {
        return nullptr;
    }
    return m_list.at(index);
}

Rule *Rules::getRule(const QUuid &ruleId) const
{
    foreach (Rule *rule, m_list) {
        if (rule->id() == ruleId) {
            return rule;
        }
    }
    return nullptr;
}
