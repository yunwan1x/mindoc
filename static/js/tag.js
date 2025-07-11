(function($){
    $.fn.tags = function(option){

        var defaultSetting = { states:['网络','Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
                'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
                'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
                'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
                'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
                'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
                'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
                'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
                'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
            ],readonly:true ,border:false}
        var setting = $.extend(defaultSetting,option)
        var {states,readonly,border} = setting
        return this.each(function (index,e) {

            var $this = $(this)
            if(readonly&&!$this.val()){
                $this.hide()
                return
            }
            $(this).tagsinput({
                trimValue: true,
                maxChars: 50,
                freeInput: true,
                tagClass: function(item,a) {
                    return 'label label-primary';
                },
            });
            var inputElm = $(this).tagsinput('input');
            if(!border){
                inputElm.parent().css(  {paddingLeft: 0,border: "none",borderRadius: 0,paddingBottom: "2px"})
            }
            // $(document).keydown(function (e) {
            //
            //     if(e.keyCode==13 && e.originalEvent.target == inputElm.get(0)){
            //         console.log(e)
            //         e.stopPropagation()
            //     }
            // })
            inputElm.attr("type",'search').attr("name","hidden-tags").attr("autocomplete","off").attr("role","presentation")

            inputElm.after("<input type='text' name='hidden-o'  style='width: 0;flex-grow: 0' />")



            $(this).on('itemAdded', function (event) {
                hideTip()
                $this.data("add",false)
            });

            var bootstarpTag = inputElm.parent();

            bootstarpTag.wrap('<div class="tag_container">')
            var container = bootstarpTag.parent();
            container.append("<div class='tip'></div>")

            if(readonly){
                container.find('span[data-role="remove"]').hide();
                inputElm.hide()
                container.find('span.tag').css("paddingRight","6px")
            }
            var tip = container.find('.tip');
            inputElm.on('input', function (val) {
                var q = val.currentTarget.value;
                var matches, substringRegex;
                matches = [];
                substrRegex = new RegExp(q, 'i');
                var tipData = q ? states.filter(value => substrRegex.test(value)) : [];
                tipData && showTip(tipData)
            }).keydown(function(e) {
                if(e.keyCode==40){
                    // tip.find('.dataitem').first().focus(function (){
                    // })
                    //
                    // tip.find('.dataitem').first().focus();
                }
                if(e.keyCode == 13){
                    $this.data("add",true)
                }
            }).focusout(function () {
                hideTip()
            });

            $(this).on('beforeItemAdd', function(event) {
                if(event.item&& event.item.length<2){
                    event.cancel =true
                    return
                }
                event.cancel = $this.data("add")?false:true
            });
            tip.on('click', '.dataitem', function () {
                var data = $(this).text();
                $this.data("add",true)
                $this.tagsinput('add', data);
                $this.data("add",false)
                hideTip()
            })

            container.find('.tip').keydown(function(e) {
                if(e.keyCode==40){
                    container.find('.dataitem:focus').next(".dataitem").focus()
                    //向上
                }else if(e.keyCode==38){
                    container.find('.dataitem:focus').prev(".dataitem").focus()
                }
            })



            function showTip(data) {
                var str = data.reduce((p, c,index) => p + `<div class="dataitem" tabindex="${index+1}">${c}</div>`, "")
                tip.html(str).slideDown();
            }

            function hideTip() {
                tip.slideUp()
            }
            return this;
        })

    }
})(jQuery);



