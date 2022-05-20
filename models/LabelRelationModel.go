package models

import (
	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
	"github.com/mindoc-org/mindoc/conf"
)

type LabelRelation struct {
	LabelId    int `orm:"column(label_id);" json:"label_id"`
	ResourceId int `orm:"column(resource_id);" json:"resource_id"`
	//book,blog
	RelationType string `orm:"column(relation_type);size(24)" json:"relation_type"`
}

// TableName 获取对应数据库表名.
func (m *LabelRelation) TableName() string {
	return "label_relation"
}

// TableEngine 获取数据使用的引擎.
func (m *LabelRelation) TableEngine() string {
	return "INNODB"
}

func (m *LabelRelation) TableNameWithPrefix() string {
	return conf.GetDatabasePrefix() + m.TableName()
}

func NewLabelRelation() *LabelRelation {
	return &LabelRelation{}
}

func (m *LabelRelation) SaveLabelRelation() error {
	o := orm.NewOrm()
	err := o.Read(m, "resource_id", "label_id")
	if err != nil {
		_, err1 := o.Insert(m)
		if err1 != nil {
			return err1
		}
	}

	return nil
}

func (m *LabelRelation) DeleteByResourceId(resourceId int, resourceType string) error {
	o := orm.NewOrm()
	_, err := o.Delete(&LabelRelation{ResourceId: resourceId, RelationType: resourceType}, "resource_id", "relation_type")
	return err
}

//分页查找标签.
func (m *LabelRelation) FindToPager(pageIndex, pageSize int) (labels []*Label, totalCount int, err error) {
	o := orm.NewOrm()

	count, err := o.QueryTable(m.TableNameWithPrefix()).Count()

	if err != nil {
		return
	}
	totalCount = int(count)

	offset := (pageIndex - 1) * pageSize

	_, err = o.QueryTable(m.TableNameWithPrefix()).OrderBy("-book_number").Offset(offset).Limit(pageSize).All(&labels)

	if err == orm.ErrNoRows {
		logs.Info("没有查询到标签 ->", err)
		err = nil
		return
	}
	return
}
