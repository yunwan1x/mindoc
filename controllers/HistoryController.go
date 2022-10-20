package controllers

import (
	"github.com/mindoc-org/mindoc/utils"
	"strconv"
	"strings"

	"github.com/beego/beego/v2/core/logs"
	"github.com/beego/i18n"
	"github.com/mindoc-org/mindoc/conf"
	"github.com/mindoc-org/mindoc/models"
	"github.com/mindoc-org/mindoc/utils/pagination"
	"github.com/mindoc-org/mindoc/utils/sqltil"
)

type HistoryController struct {
	BaseController
}

//搜索首页
func (c *HistoryController) Index() {
	c.Prepare()
	c.TplName = "search/history.tpl"

	//如果没有开启你们访问则跳转到登录
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login"), 302)
		return
	}

	pageIndex, _ := c.GetInt("page", 1)

	c.Data["BaseUrl"] = c.BaseUrl()

	memberId := 0
	if c.Member != nil {
		memberId = c.Member.MemberId
	}
	searchResult, totalCount, err := models.NewHistoryResult().FindToPager(pageIndex, conf.PageSize, memberId)

	if len(searchResult) > 0 {
		for _, item := range searchResult {
			if item.Description != "" {
				src := item.Description

				r := []rune(utils.StripTags(item.Description))

				if len(r) > 100 {
					src = string(r[:100])
				} else {
					src = string(r)
				}
				item.Description = src
			}
			if item.Identify == "" {
				item.Identify = strconv.Itoa(item.DocumentId)
			}
			if item.ModifyTime.IsZero() {
				item.ModifyTime = item.CreateTime
			}
		}
	}
	if err != nil {
		logs.Error("搜索失败 ->", err)
		return
	}
	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, conf.PageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}
	c.Data["Lists"] = searchResult
}

//搜索用户
func (c *HistoryController) User() {
	c.Prepare()
	key := c.Ctx.Input.Param(":key")
	keyword := strings.TrimSpace(c.GetString("q"))
	if key == "" || keyword == "" {
		c.JsonResult(404, i18n.Tr(c.Lang, "message.param_error"))
	}
	keyword = sqltil.EscapeLike(keyword)

	book, err := models.NewBookResult().FindByIdentify(key, c.Member.MemberId)
	if err != nil {
		if err == models.ErrPermissionDenied {
			c.JsonResult(403, i18n.Tr(c.Lang, "message.no_permission"))
		}
		c.JsonResult(500, i18n.Tr(c.Lang, "message.item_not_exist"))
	}

	//members, err := models.NewMemberRelationshipResult().FindNotJoinUsersByAccount(book.BookId, 10, "%"+keyword+"%")
	members, err := models.NewMemberRelationshipResult().FindNotJoinUsersByAccountOrRealName(book.BookId, 10, "%"+keyword+"%")
	if err != nil {
		logs.Error("查询用户列表出错：" + err.Error())
		c.JsonResult(500, err.Error())
	}
	result := models.SelectMemberResult{}
	items := make([]models.KeyValueItem, 0)

	for _, member := range members {
		item := models.KeyValueItem{}
		item.Id = member.MemberId
		item.Text = member.Account + "[" + member.RealName + "]"
		items = append(items, item)
	}

	result.Result = items

	c.JsonResult(0, "OK", result)
}
