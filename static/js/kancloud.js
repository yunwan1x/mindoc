var events = function () {
    var articleOpen = function (event, $param) {
        //当打开文档时，将文档ID加入到本地缓存。
        window.sessionStorage && window.sessionStorage.setItem("MinDoc::LastLoadDocument:" + window.book.identify, $param.$id);
        var prevState = window.history.state || {};
        if ('pushState' in history) {

            if ($param.$id) {
                prevState.$id === $param.$id || window.history.pushState($param, $param.$id, $param.$url);
            } else {
                window.history.pushState($param, $param.$id, $param.$url);
                window.history.replaceState($param, $param.$id, $param.$url);
            }
        } else {
            window.location.hash = $param.$url;
        }

        initHighlighting();
        $(window).resize();

        $(".manual-right").scrollTop(0);
        //使用layer相册功能查看图片
        layer.photos({photos: "#page-content"});
        //添加复制按钮
        addCopyFunc()
    };

    return {
        data: function ($key, $value) {
            $key = "MinDoc::Document:" + $key;
            if (typeof $value === "undefined") {
                return $("body").data($key);
            } else {
                return $('body').data($key, $value);
            }
        },
        trigger: function ($e, $obj) {
            if ($e === "article.open") {
                articleOpen($e, $obj);
            } else {
                $('body').trigger('article.open', $obj);
            }
        }
    }

}();
var  paths = location.pathname.split("/")
var bookid = paths[2]
var identify = paths[3] || 0
var getbookinfo_url  = `/docs/info/${bookid}/${identify}`
$.ajax({
    url : getbookinfo_url,
    type : "GET",
    success : function (res) {
        if (res.errcode === 0) {
            
            events.trigger('article.open', { $url : location.href, $id : res.data.document_id });
        } else if (res.errcode === 6000) {
            window.location.href = "/";
        } else {
            layer.msg("加载失败");
        }
    },
    complete : function () {
        NProgress.done();
    },
    error : function () {
        layer.msg("加载失败");
    }
});

/***
 * 加载文档到阅读区
 * @param $url
 * @param $id
 * @param $callback
 */
function loadDocument($url, $id, $callback) {
    $.ajax({
        url : $url,
        type : "GET",
        beforeSend : function (xhr) {
            var data = events.data($id);
            if(data) {
                if (typeof $callback === "function") {
                    data.body = $callback(data.body);
                }else if(data.version && data.version != $callback){
                    return true;
                }
                $("#page-content").html(data.body);
                $("title").text(data.title);
                $("#article-title").text(data.doc_title);
                $("#article-info").text(data.doc_info);
                $("#view_count").text("阅读次数：" + data.view_count);

                events.trigger('article.open', {$url: $url, $id: $id});

                return false;

            }

            NProgress.start();
        },
        success : function (res) {
            if (res.errcode === 0) {
                var body = res.data.body;
                var doc_title = res.data.doc_title;
                var title = res.data.title;
                var doc_info = res.data.doc_info;
                var view_count = res.data.view_count;

                $body = body;
                if (typeof $callback === "function" ) {
                    $body = $callback(body);
                }
                $("#page-content").html($body);
                $("title").text(title);
                $("#article-title").text(doc_title);
                $("#article-info").text(doc_info);
                $("#view_count").text("阅读次数：" + view_count);

                events.data($id, res.data);

                events.trigger('article.open', { $url : $url, $id : $id });
            } else if (res.errcode === 6000) {
                window.location.href = "/";
            } else {
                layer.msg("加载失败");
            }
        },
        complete : function () {
            NProgress.done();
        },
        error : function () {
            layer.msg("加载失败");
        }
    });
}

/**
 * 初始化代码高亮
 */
function initHighlighting() {
    try {
        $('pre,pre.ql-syntax').each(function (i, block) {
            if ($(this).hasClass('prettyprinted')) {
                return;
            }
            hljs.highlightBlock(block);
        });
        // hljs.initLineNumbersOnLoad();
    }catch (e){
        console.log(e);
    }
}




$(function () {
    $(".view-backtop").on("click", function () {
        $('.manual-right').animate({ scrollTop: '0px' }, 200);
    });
    $(".manual-right").scroll(function () {
        try {
            var top = $(".manual-right").scrollTop();
            if (top > 100) {
                $(".view-backtop").addClass("active");
            } else {
                $(".view-backtop").removeClass("active");
            }
        }catch (e) {
            console.log(e);
        }

        try{
            var scrollTop = $("body").scrollTop();
            var oItem = $(".markdown-heading").find(".reference-link");
            var oName = "";
            $.each(oItem,function(){
                var oneItem = $(this);
                var offsetTop = oneItem.offset().top;

                if(offsetTop-scrollTop < 100){
                    oName = "#" + oneItem.attr("name");
                }
            });
            $(".markdown-toc-list a").each(function () {
                if(oName === $(this).attr("href")) {
                    $(this).parents("li").addClass("directory-item-active");
                }else{
                    $(this).parents("li").removeClass("directory-item-active");
                }
            });
            if(!$(".markdown-toc-list li").hasClass('directory-item-active')) {
                $(".markdown-toc-list li:eq(0)").addClass("directory-item-active");
            }
        }catch (e) {
            console.log(e);
        }
    }).on("click",".markdown-toc-list a", function () {
        var $this = $(this);
        setTimeout(function () {
            $(".markdown-toc-list li").removeClass("directory-item-active");
            $this.parents("li").addClass("directory-item-active");
        },10);
    }).find(".markdown-toc-list li:eq(0)").addClass("directory-item-active");


    $(window).resize(function (e) {
        var h = $(".manual-catalog").innerHeight() - 20;
        $(".markdown-toc").height(h);
    }).resize();

    window.isFullScreen = false;

    initHighlighting();
    window.jsTree = $("#sidebar").jstree({
        'plugins' : ["wholerow", "types"],
        "types": {
            "default" : {
                "icon" : false  // 删除默认图标
            }
        },
        'core' : {
            'check_callback' : true,
            "multiple" : false,
            'animation' : 0
        }
    }).on('select_node.jstree', function (node, selected) {
        //如果是空目录则直接出发展开下一级功能
        if (selected.node.a_attr && selected.node.a_attr.disabled) {
            selected.instance.toggle_node(selected.node);
            return false
        }
        $(".m-manual").removeClass('manual-mobile-show-left');
        if(screen.availWidth<520){
            $('.manual-left').css("left","-360px")
        }
        loadDocument(selected.node.a_attr.href, selected.node.id,selected.node.a_attr['data-version']);
    }).on("ready.jstree",function () {
        $("#sidebar").show()
    });

    $("#slidebar,#book-title").on("click", function () {
        $(".m-manual").addClass('manual-mobile-show-left')
        $('.manual-left').css("left","0px");
    });
    $(".manual-mask").on("click", function () {
        $('.manual-left').css("left","-360px")
        $(".m-manual").removeClass('manual-mobile-show-left');
    });

    /**
     * 关闭侧边栏
     */
    $(".manual-fullscreen-switch").on("click", function () {
        isFullScreen = !isFullScreen;
        if (isFullScreen) {
            $(".m-manual").addClass('manual-fullscreen-active');
        } else {
            $(".m-manual").removeClass('manual-fullscreen-active');
        }
    });

    $(".navg-item[data-mode]").on("click", function () {
        var mode = $(this).data('mode');
        $(this).siblings().removeClass('active').end().addClass('active');
        $(".m-manual").removeClass("manual-mode-view manual-mode-collect manual-mode-search").addClass("manual-mode-" + mode);
    });

    /**
     * 项目内搜索
     */
    $("#searchForm").ajaxForm({
        beforeSubmit : function () {
            var keyword = $.trim($("#searchForm").find("input[name='keyword']").val());
            if (keyword === "") {
                $(".search-empty").show();
                $("#searchList").html("");
                return false;
            }
            $("#btnSearch").attr("disabled", "disabled").find("i").removeClass("fa-search").addClass("loading");
            window.keyword = keyword;
        },
        success : function (res) {
            var html = "";
            if (res.errcode === 0) {
                for(var i in res.data) {
                    var item = res.data[i];
                    html += '<li><a href="javascript:;" title="' + item.doc_name + '" data-id="' + item.doc_id + '"> ' + item.doc_name + ' </a></li>';
                }
            }
            if (html !== "") {
                $(".search-empty").hide();
            } else {
                $(".search-empty").show();
            }
            $("#searchList").html(html);
        },
        complete : function () {
            $("#btnSearch").removeAttr("disabled").find("i").removeClass("loading").addClass("fa-search");
        }
    });

    window.onpopstate = function (e) {
        var $param = e.state;
        if (!$param) return;
        if($param.hasOwnProperty("$url")) {
            window.jsTree.jstree().deselect_all();

            if ($param.$id) {
                window.jsTree.jstree().select_node({ id : $param.$id });
            }else{
                window.location.assign($param.$url);
            }
            // events.trigger('article.open', $param);
        } else {
            console.log($param);
        }
    };
});