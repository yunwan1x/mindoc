<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{i18n .Lang "project.prj_space_list"}} - Powered by MinDoc</title>
    <meta name="keywords" content="汪云的个人文档管理系统">
    <meta name="description" content="书籍，文章，图表，书签和超赞列表">
    <meta name="author" content="Minho" />
    <meta name="site" content="" />
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">

    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">

</head>
<body>
<div class="manual-reader manual-container manual-search-reader">
{{template "widgets/header.tpl" .}}
    <div class="container manual-body">
        <div class="search-head">
            <strong class="search-title">{{i18n .Lang "project.prj_space_list"}}</strong>
        </div>
        <div class="row">
            <div class="hide tag-container-outer" style="border: 0;margin-top: 0;padding: 5px 15px;min-height: 200px;">
                <div class="attach-list" id="ItemsetsList">
                {{range $index,$item := .Lists}}
                    <a href="{{urlfor "ItemsetsController.List" ":key" $item.ItemKey}}" class="ui-card" title="{{$item.ItemName}}">
                    <div class="header">{{$item.ItemName}}</div>
                        <div class="description">{{i18n $.Lang "project.prj_amount"}}：{{$item.BookNumber}} &nbsp; {{i18n $.Lang "project.creator"}}：{{$item.CreateName}}<br/> {{i18n $.Lang "project.create_time"}}：{{$item.CreateTimeString}}</div>
                    </a>
                {{else}}
                    <div class="search-empty">
                        <img src="{{cdnimg "/static/images/search_empty.png"}}" class="empty-image">
                        <span class="empty-text">{{i18n .Lang "project.no_projct_space"}}</span>
                    </div>
                {{end}}
                </div>
            </div>

            <nav class="pagination-container">
            {{if gt .TotalPages 1}}
                {{.PageHtml}}
                {{end}}
                <div class="clearfix"></div>
            </nav>
        </div>
    </div>
{{template "widgets/footer.tpl" .}}
</div>
<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}" type="text/javascript"></script>
{{.Scripts}}
</body>
</html>