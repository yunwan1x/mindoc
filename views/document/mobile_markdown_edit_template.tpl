<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content="Gitalk description"/>
    <script  src="https://cdn.jsdelivr.net/npm/vditor@3.8.5/dist/index.min.js"></script>
    <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/vditor@3.8.5/dist/index.css"/>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios@0.21.1/dist/axios.min.js"></script>

    <style>
        body {
            margin: 0
        }

        .vditor {
            --toolbar-background-color: white !important;
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

        @keyframes spinner-border {
            to {
                transform: rotate(360deg) /* rtl:ignore */;
            }
        }
    </style>
</head>
<script>
    const queryHash = (search = window.location.hash) => {
        if (!search) return {}
        const queryString = search[0] === '#' ? search.substring(1) : search
        const query = {}
        queryString
            .split('&')
            .forEach(queryStr => {
                const [key, value] = queryStr.split('=')
                /* istanbul ignore else */
                if (key) query[decodeURIComponent(key)] = decodeURIComponent(value)
            })

        return query
    }
    const {repo="yunwan1x.github.io"} =queryHash()
    window.GT_CONFIG = {
        clientID: "762b2d245adbd42c27a5",
        clientSecret: "f6fa4d544e092ac6fac95bf9bcd0a78ab9f1eb5b",
        repo: repo,
        owner: 'yunwan1x',
        admin: 'yunwan1x'
    }
</script>
<div id="vditor"></div>
<div id="spinner-border"></div>
<div class="vditor-tip vditor-tip--show" style="display:none;">
    <div class="vditor-tip__content">
        <div class="vditor-tip__content">
            <div style="background: #dc3545;color: white;padding: 0.5em 1em;border-radius: 3px"></div>
        </div>
    </div>
    <script src="{{cdnjs "/static/js/vditor_markdown.js"}}" type="text/javascript"></script>
</div>