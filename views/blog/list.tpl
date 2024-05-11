<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{i18n .Lang "blog.blog_list"}} - Powered by MinDoc</title>
    <meta name="keywords" content="汪云的个人文档管理系统">
    <meta name="description" content="书籍，文章，图表，书签和超赞列表">
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">

    <style type="text/css">
        .footer{margin-top: 0;}
        .label {
            background-color: #00b5ad!important;
            border-color: #00b5ad!important;
            color: #fff!important;
            font-weight: 400;
        }
    </style>
</head>
<body>
<div class="manual-reader manual-container manual-search-reader">
{{template "widgets/header.tpl" .}}
    <div class="container manual-body">
        <div class="m-box" style="margin-top: 10px;padding-left: 10px;padding-right: 10px">
            <div class="box-head">
                <strong class="box-title">{{i18n .Lang "blog.blog_list"}}</strong>
                &nbsp;
                <a href="{{urlfor "BlogController.ManageSetting"}}" class="btn btn-success btn-sm pull-right">{{i18n .Lang "blog.add_blog"}}</a>
            </div>
            <div class="tag-container-outer">
                <span class="tags">
                    {{range  $index,$item := .Tags}}
                    <a href="/blogs?tag={{$item.LabelName}}">{{$item.LabelName}}<span class="detail">{{$item.BookNumber}}</span></a>
                    {{else}}
                    <div class="text-center">暂无标签</div>
                    {{end}}
                </span>
            </div>
            
        </div>
        <div class="row">
            <div class="manual-list">
            {{range $index,$item := .Lists}}
                <div class="search-item">
                    <div class="title"> <a style="display: block;" href="{{urlfor "BlogController.Index" ":id" $item.BlogId}}" title="{{$item.BlogTitle}}">{{if eq $item.BlogStatus "password"}}<i class="fa fa-expeditedssl" aria-hidden="true"></i>{{else}}<i class="fa fa-newspaper-o" aria-hidden="true"></i>{{end}}&nbsp;{{$item.BlogTitle}}</a> </div>
                    <div class="description">
                    {{$item.BlogExcerpt}}
                    </div>
                    {{/*<div class="site">{{urlfor "BlogController.Index" ":id" $item.BlogId}}</div>*/}}
                    <div class="source">
                        <span class="item"><i class="fa fa-user" aria-hidden="true"></i>&nbsp;{{$item.CreateName}}</span>
                        <span class="item"><i class="fa fa-calendar" aria-hidden="true"></i>&nbsp;{{date_format  $item.Modified "2006-01-02 15:04:05"}}</span>
                    </div>
                </div>
            {{else}}
                <div class="search-empty">
                    <img src="{{cdnimg "/static/images/search_empty.png"}}" class="empty-image">
                    <span class="empty-text">{{i18n $.Lang "blog.no_blog"}}</span>
                </div>
            {{end}}
                <nav class="pagination-container">
                {{.PageHtml}}
                </nav>
                <div class="clearfix"></div>
            </div>
        </div>
    </div>
{{template "widgets/footer.tpl" .}}
</div>
<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}"></script>
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}"></script>
{{.Scripts}}
</body>
</html>