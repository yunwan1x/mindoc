<div class="footer">
    <div class="container">
        <div class="row text-center border-top">
            <span><a href="https://yunwan1x.github.io/playground/" target="_blank">游乐园</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://www.vs2010wy.top/" target="_blank">开源</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://github.com/yunwan1x/mindoc" target="_blank">{{i18n .Lang "common.source_code"}}</a></span>
            <span>&nbsp;·&nbsp;</span>
            <span><a href="https://doc.gsw945.com/docs/mindoc-docs/mindoc-summary.md" target="_blank">{{i18n .Lang "common.manual"}}</a></span>
        </div>
        {{if .site_beian}}
        <div class="row text-center">
            <a href="https://beian.miit.gov.cn/" target="_blank">{{.site_beian}}</a>
        </div>
        {{end}}
    </div>
</div>
