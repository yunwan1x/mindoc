<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{{i18n .Lang "blog.edit_title"}} - Powered by MinDoc</title>
    <script src="https://cdn.jsdelivr.net/npm/vditor/dist/index.min.js"></script>
    <script src="{{cdnjs "/static/js/vditor_markdown.js?time=2022040401"}}" ></script>
    <script type="text/javascript">
        window.baseUrl = "{{.BaseUrl}}";
        window.mobile = true

        new vditorEditor()
    </script>

    <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/vditor@3.8.5/dist/index.css"/>
    <style>
        body {
            margin: 0
        }

        .vditor {
            --toolbar-background-color: white !important;
        }
        .vditor-ir pre{
            border: none;

        }
        .vditor-ir__marker--pre{
            padding: 0 !important;
            max-height: 36em;
        }
        ::-webkit-scrollbar{
            width: 0 !important;
        }

        .vditor-tip {
            top: 4em;
        }
        .vditor-emojis{
            max-height: 40vh !important;
        }

        @media screen and (max-width: 520px){
            .vditor-toolbar__item {
                padding: 0 6px !important;
            }
            .vditor-reset {
                font-size: 14px !important;
            }
            .vditor-reset ul, .vditor-reset ol {
                padding-left: 1em !important;
            }
        }

        .vditor-tip__content {
            padding: 0px;
        }
        #manual-mask {
            position: fixed;
            display: none;
            top: 36px;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0.3;
            left: 0;
            z-index: 86
        }

        #spinner-border {
            color: #0d6efd;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            position: fixed;
            margin: auto;
            display: inline-block;
            width: 2rem;
            height: 2rem;
            vertical-align: -.125em;
            border: .25em solid currentColor;
            border-right-color: transparent;
            border-radius: 50%;
            -webkit-animation: .75s linear infinite spinner-border;
            animation: .75s linear infinite spinner-border;
        }
        .vditor-preview,.vditor-preview__action{
            display: none !important;
        }

        @keyframes spinner-border {
            to {
                transform: rotate(360deg) /* rtl:ignore */;
            }
        }
    </style>
</head>
<body>

<div id="vditor"></div>
<div class="vditor-tip vditor-tip--show" style="display:none;">
    <div class="vditor-tip__content">
        <div class="vditor-tip__content">
            <div style="background: #dc3545;color: white;padding: 0.5em 1em;border-radius: 3px"></div>
        </div>
    </div>
</div>





</body>
</html>