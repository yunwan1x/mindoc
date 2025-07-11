package models

import "github.com/beego/beego/v2/client/orm"

type Dashboard struct {
	BookNumber       int64 `json:"book_number"`
	DocumentNumber   int64 `json:"document_number"`
	MemberNumber     int64 `json:"member_number"`
	CommentNumber    int64 `json:"comment_number"`
	AttachmentNumber int64 `json:"attachment_number"`
	LabelNumber      int64 `json:"label_number"`
	ItemsetsNumber   int64 `json:"itemsets_number"`
}

func NewDashboard() *Dashboard {
	return &Dashboard{}
}

func (m *Dashboard) Query() *Dashboard {
	o := orm.NewOrm()

	book_number, _ := o.QueryTable(NewBook().TableNameWithPrefix()).Count()

	m.BookNumber = book_number

	document_count, _ := o.QueryTable(NewDocument().TableNameWithPrefix()).Count()
	m.DocumentNumber = document_count

	member_number, _ := o.QueryTable(NewMember().TableNameWithPrefix()).Count()
	m.MemberNumber = member_number

	//comment_number,_ := o.QueryTable(NewComment().TableNameWithPrefix()).Count()
	m.CommentNumber = 0

	attachment_number, _ := o.QueryTable(NewAttachment().TableNameWithPrefix()).Count()

	m.AttachmentNumber = attachment_number
	labelnumber, _ := o.QueryTable(NewLabel().TableNameWithPrefix()).Count()
	m.LabelNumber = labelnumber
	itemsnumber, _ := o.QueryTable(NewItemsets().TableNameWithPrefix()).Count()
	m.ItemsetsNumber = itemsnumber
	return m
}
