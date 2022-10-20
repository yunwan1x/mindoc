package models

import (
	"time"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
)

type HistoryResult struct {
	DocumentId   int    `json:"doc_id"`
	DocumentName string `json:"doc_name"`
	// Identify 文档唯一标识
	Identify     string    `json:"identify"`
	Description  string    `json:"description"`
	Author       string    `json:"author"`
	ModifyTime   time.Time `json:"modify_time"`
	CreateTime   time.Time `json:"create_time"`
	BookId       int       `json:"book_id"`
	BookName     string    `json:"book_name"`
	BookIdentify string    `json:"book_identify"`
	SearchType   string    `json:"search_type"`
}

func NewHistoryResult() *HistoryResult {
	return &HistoryResult{}
}

//分页全局搜索.
func (m *HistoryResult) FindToPager(pageIndex, pageSize, memberId int) (searchResult []*HistoryResult, totalCount int, err error) {
	o := orm.NewOrm()

	offset := (pageIndex - 1) * pageSize

	if memberId <= 0 {

		sql2 := `SELECT *
FROM (
       SELECT
         doc.document_id,
         doc.modify_time,
         doc.create_time,
         doc.document_name,
         doc.identify,
         doc.content    AS description,
         book.identify  AS book_identify,
         book.book_name,
         rel.member_id,
         member.account AS author,
         'document'     AS search_type
       FROM md_documents AS doc
         LEFT JOIN md_books AS book ON doc.book_id = book.book_id
         LEFT JOIN md_relationship AS rel ON book.book_id = rel.book_id AND rel.role_id = 0
         LEFT JOIN md_members AS member ON rel.member_id = member.member_id
       WHERE book.privately_owned = 0 


       UNION ALL
       SELECT
         blog.blog_id AS document_id,
         blog.modify_time,
         blog.create_time,
         blog.blog_title as document_name,
         blog.blog_identify,
         blog.blog_release,
         blog.blog_identify,
         blog.blog_title as book_name,
         blog.member_id,
         member.account,
         'blog' AS search_type
       FROM md_blogs AS blog
         LEFT JOIN md_members AS member ON blog.member_id = member.member_id
       WHERE blog.blog_status = 'public' 
     ) AS union_table
ORDER BY modify_time DESC
LIMIT ?, ?;`

		sql1 := `  SELECT count(*)
FROM (
       SELECT
         doc.document_id,
         doc.modify_time,
         doc.create_time,
         doc.document_name,
         doc.identify,
         doc.content    AS description,
         book.identify  AS book_identify,
         book.book_name,
         rel.member_id,
         member.account AS author,
         'document'     AS search_type
       FROM md_documents AS doc
         LEFT JOIN md_books AS book ON doc.book_id = book.book_id
         LEFT JOIN md_relationship AS rel ON book.book_id = rel.book_id AND rel.role_id = 0
         LEFT JOIN md_members AS member ON rel.member_id = member.member_id
       WHERE book.privately_owned = 0 


       UNION ALL
       SELECT
         blog.blog_id AS document_id,
         blog.modify_time,
         blog.create_time,
         blog.blog_title as document_name,
         blog.blog_identify,
         blog.blog_release,
         blog.blog_identify,
         blog.blog_title as book_name,
         blog.member_id,
         member.account,
         'blog' AS search_type
       FROM md_blogs AS blog
         LEFT JOIN md_members AS member ON blog.member_id = member.member_id
       WHERE blog.blog_status = 'public' 
     ) AS union_table`
		err = o.Raw(sql1).QueryRow(&totalCount)
		_, err = o.Raw(sql2, offset, pageSize).QueryRows(&searchResult)
		if err != nil {
			logs.Error("查询搜索结果失败 -> ", err)
			return
		}
	} else {

		sql2 := `SELECT *
FROM (
       SELECT
         doc.document_id,
         doc.modify_time,
         doc.create_time,
         doc.document_name,
         doc.identify,
         doc.content    AS description,
         book.identify  AS book_identify,
         book.book_name,
         rel.member_id,
         member.account AS author,
         'document'     AS search_type
       FROM md_documents AS doc
         LEFT JOIN md_books AS book ON doc.book_id = book.book_id
         LEFT JOIN md_relationship AS rel ON book.book_id = rel.book_id AND rel.role_id = 0
         LEFT JOIN md_members AS member ON rel.member_id = member.member_id
         LEFT JOIN md_relationship AS rel1 ON doc.book_id = rel1.book_id AND rel1.member_id = ?
         LEFT JOIN (SELECT *
                    FROM (SELECT
                            book_id,
                            team_member_id,
                            role_id
                          FROM md_team_relationship AS mtr
                            LEFT JOIN md_team_member AS mtm ON mtm.team_id = mtr.team_id AND mtm.member_id = ?
                          ORDER BY role_id DESC) AS t
                    GROUP BY t.role_id, t.team_member_id, t.book_id) AS team
           ON team.book_id = book.book_id
       WHERE (book.privately_owned = 0 OR rel1.relationship_id > 0 OR team.team_member_id > 0) 
       UNION ALL
       SELECT
         blog.blog_id AS document_id, 
         blog.modify_time,
         blog.create_time,
         blog.blog_title as document_name,
         blog.blog_identify as identify,
         blog.blog_release as description,
         blog.blog_identify  AS book_identify,
         blog.blog_title as book_name,
         blog.member_id,
         member.account,
         'blog' AS search_type
       FROM md_blogs AS blog
         LEFT JOIN md_members AS member ON blog.member_id = member.member_id
       WHERE (blog.blog_status = 'public' OR blog.member_id = ?) AND blog.blog_type = 0 
     ) AS union_table
ORDER BY modify_time DESC
LIMIT ?, ?;`

		sql1 := `SELECT count(*)
FROM (
       SELECT
         doc.document_id,
         doc.modify_time,
         doc.create_time,
         doc.document_name,
         doc.identify,
         doc.content    AS description,
         book.identify  AS book_identify,
         book.book_name,
         rel.member_id,
         member.account AS author,
         'document'     AS search_type
       FROM md_documents AS doc
         LEFT JOIN md_books AS book ON doc.book_id = book.book_id
         LEFT JOIN md_relationship AS rel ON book.book_id = rel.book_id AND rel.role_id = 0
         LEFT JOIN md_members AS member ON rel.member_id = member.member_id
         LEFT JOIN md_relationship AS rel1 ON doc.book_id = rel1.book_id AND rel1.member_id = ?
         LEFT JOIN (SELECT *
                    FROM (SELECT
                            book_id,
                            team_member_id,
                            role_id
                          FROM md_team_relationship AS mtr
                            LEFT JOIN md_team_member AS mtm ON mtm.team_id = mtr.team_id AND mtm.member_id = ?
                          ORDER BY role_id DESC) AS t
                    GROUP BY t.role_id, t.team_member_id, t.book_id) AS team
           ON team.book_id = book.book_id
       WHERE (book.privately_owned = 0 OR rel1.relationship_id > 0 OR team.team_member_id > 0) 
       UNION ALL
       SELECT
         blog.blog_id AS document_id, 
         blog.modify_time,
         blog.create_time,
         blog.blog_title as document_name,
         blog.blog_identify as identify,
         blog.blog_release as description,
         blog.blog_identify  AS book_identify,
         blog.blog_title as book_name,
         blog.member_id,
         member.account,
         'blog' AS search_type
       FROM md_blogs AS blog
         LEFT JOIN md_members AS member ON blog.member_id = member.member_id
       WHERE (blog.blog_status = 'public' OR blog.member_id = ?) AND blog.blog_type = 0 
     ) AS union_table`
		err = o.Raw(sql1, memberId, memberId, memberId).QueryRow(&totalCount)
		_, err = o.Raw(sql2, memberId, memberId, memberId, offset, pageSize).QueryRows(&searchResult)
		if err != nil {
			return
		}
	}
	return
}
