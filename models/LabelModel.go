package models

import (
	"strings"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
	"github.com/mindoc-org/mindoc/conf"
)

type Label struct {
	LabelId    int    `orm:"column(label_id);pk;auto;unique;" json:"label_id"`
	LabelName  string `orm:"column(label_name);size(50);unique" json:"label_name"`
	BookNumber int    `orm:"column(book_number)" json:"book_number"`
}

// TableName 获取对应数据库表名.
func (m *Label) TableName() string {
	return "label"
}

// TableEngine 获取数据使用的引擎.
func (m *Label) TableEngine() string {
	return "INNODB"
}

func (m *Label) TableNameWithPrefix() string {
	return conf.GetDatabasePrefix() + m.TableName()
}

func NewLabel() *Label {
	return &Label{}
}

func (m *Label) FindFirst(field string, value interface{}) (*Label, error) {
	o := orm.NewOrm()

	err := o.QueryTable(m.TableNameWithPrefix()).Filter(field, value).One(m)

	return m, err
}

// 插入或更新标签.
func (m *Label) InsertOrUpdate(labelName string) error {
	o := orm.NewOrm()

	err := o.QueryTable(m.TableNameWithPrefix()).Filter("label_name", labelName).One(m)
	if err != nil && err != orm.ErrNoRows {
		return err
	}
	count, _ := o.QueryTable(NewBook().TableNameWithPrefix()).Filter("label__icontains", labelName).Count()
	m.BookNumber = int(count)
	m.LabelName = labelName

	if err == orm.ErrNoRows {
		err = nil
		m.LabelName = labelName
		_, err = o.Insert(m)
	} else {
		_, err = o.Update(m)
	}
	return err
}

// 批量插入或更新标签.
func (m *Label) InsertOrUpdateMulti(labels string) {
	if labels != "" {
		labelArray := strings.Split(labels, ",")

		for _, label := range labelArray {
			if label != "" {
				NewLabel().InsertOrUpdate(label)
			}
		}
	}
}

func (m *Label) GetAllLabelName() (string, error) {
	o := orm.NewOrm()
	var labels []string
	_, err := o.Raw("select  label_name from md_label").QueryRows(&labels)
	if err != nil {
		return "", err
	}
	return strings.Join(labels, ","), err
}

// 删除标签
func (m *Label) Delete() error {
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM "+m.TableNameWithPrefix()+" WHERE label_id= ?", m.LabelId).Exec()
	_, err1 := o.Raw("DELETE FROM md_label_relation where label_id = ?", m.LabelId).Exec()
	if err1 != nil {
		return err1
	}

	if err != nil {
		return err
	}
	return nil
}

// 分页查找标签.
func (m *Label) FindToPager(pageIndex, pageSize int) (labels []*Label, totalCount int, err error) {
	o := orm.NewOrm()

	count, err := o.QueryTable(m.TableNameWithPrefix()).Count()

	if err != nil {
		return
	}
	totalCount = int(count)
	_, err = o.Raw("select * from (select  count(b.resource_id) as book_number,a.label_id,a.label_name from md_label a left join  md_label_relation b on a.label_id = b.label_id group by  a.label_id order by  book_number desc) where book_number >0").QueryRows(&labels)

	if err == orm.ErrNoRows {
		logs.Info("没有查询到标签 ->", err)
		err = nil
		return
	}
	return
}
