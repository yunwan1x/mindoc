package controllers

import (
	"github.com/mindoc-org/mindoc/utils"
	"math"
	"strconv"
	"strings"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
	"github.com/mindoc-org/mindoc/conf"
	"github.com/mindoc-org/mindoc/models"
	"github.com/mindoc-org/mindoc/utils/pagination"
)

type LabelController struct {
	BaseController
}

func (c *LabelController) Prepare() {
	c.BaseController.Prepare()

	//如果没有开启你们访问则跳转到登录
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login"), 302)
		return
	}
}

func (c *LabelController) List() {
	c.Prepare()
	c.TplName = "label/list.tpl"

	pageIndex, _ := c.GetInt("page", 1)
	pageSize := 200

	labels, totalCount, err := models.NewLabel().FindToPager(pageIndex, pageSize)

	if err != nil && err != orm.ErrNoRows {
		c.ShowErrorPage(500, err.Error())
	}
	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, conf.PageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}
	c.Data["TotalPages"] = int(math.Ceil(float64(totalCount) / float64(pageSize)))

	c.Data["Labels"] = labels
}

func (c *LabelController) Index() {
	c.Prepare()
	c.TplName = "search/label_index.tpl"
	//重写controlName 标签卡不会 被选中
	c.Data["ControllerName"] = ""
	//如果没有开启你们访问则跳转到登录
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login"), 302)
		return
	}

	keyword := c.Ctx.Input.Param(":key")
	pageIndex, _ := c.GetInt("page", 1)

	c.Data["BaseUrl"] = c.BaseUrl()

	if keyword != "" {
		c.Data["Label"] = keyword
		memberId := 0
		if c.Member != nil {
			memberId = c.Member.MemberId
		}
		searchResult, totalCount, err := models.NewDocumentSearchResult().FindByLabelToPager(keyword, pageIndex, conf.PageSize, memberId)
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
		if len(searchResult) > 0 {
			keywords := strings.Split(keyword, " ")

			for _, item := range searchResult {
				for _, word := range keywords {
					item.DocumentName = strings.Replace(item.DocumentName, word, "<em>"+word+"</em>", -1)
					if item.Description != "" {
						src := item.Description

						r := []rune(utils.StripTags(item.Description))

						if len(r) > 100 {
							src = string(r[:100])
						} else {
							src = string(r)
						}
						item.Description = strings.Replace(src, word, "<em>"+word+"</em>", -1)
					}
				}
				if item.Identify == "" {
					item.Identify = strconv.Itoa(item.DocumentId)
				}
				if item.ModifyTime.IsZero() {
					item.ModifyTime = item.CreateTime
				}
			}
		}
		c.Data["Lists"] = searchResult
	}
}
