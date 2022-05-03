<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>{{.SITE_NAME}} - Powered by MinDoc</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta name="author" content="Minho" />
    <meta name="site" content="https://www.iminho.me" />
    <meta name="keywords" content="MinDoc,文档在线管理系统,WIKI,wiki,wiki在线,文档在线管理,接口文档在线管理,接口文档管理">
    <meta name="description" content="MinDoc文档在线管理系统 {{.site_description}}">
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">
    <link rel="manifest" href="/static/manifest.json" />

</head>
<body>
<div class="manual-reader manual-container">
    {{template "widgets/header.tpl" .}}
    <div class="container manual-body">
        <div class="row">
             <div class="manual-list">
                {{range $index,$item := .Lists}}
                    <div class="list-item">
                        <dl class="manual-item-standard">
                            <dt>
                                {{if eq  $item.Cover "/static/images/book.jpg"}}
                                <a style="background: #ddd;overflow: hidden;padding: 1em;font-size: 20px;color: #0a001f;height: 100%"  href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}">
                                    {{$item.BookName}}
                                </a>
                                {{else}}
{{/*                                    <a style="background: #ddd;overflow: hidden;font-size: 20px;color: #0a001f;height: 100%"  href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}">*/}}
{{/*                                        <img src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}-{{$item.CreateName}}" onerror="this.src='{{cdnimg "static/images/book.jpg"}}';">*/}}
{{/*                                    </a>*/}}
                                    <a style="background: #ddd;overflow: hidden;padding: 1em;font-size: 20px;color: #0a001f;height: 100%"  href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}">
                                        {{$item.BookName}}
                                    </a>
                                {{end}}

                            </dt>
{{/*                            <dd>*/}}
{{/*                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="name" title="{{$item.BookName}}-{{$item.CreateName}}">{{$item.BookName}}</a>*/}}
{{/*                            </dd>*/}}
                            <dd>
                            <span class="author">
                                <span class="text-muted">{{i18n $.Lang "blog.author"}}</span>
                                <span class="text-muted">-</span>
                                <span class="text-muted">{{if eq $item.RealName "" }}{{$item.CreateName}}{{else}}{{$item.RealName}}{{end}}</span>
                            </span>
                            </dd>
                        </dl>
                    </div>
                {{else}}
                    <div class="text-center" style="height: 200px;margin: 100px;font-size: 28px;">{{i18n $.Lang "message.no_project"}}</div>
                {{end}}
                <div class="clearfix"></div>
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