$(function () {
    var states = ['网络','Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
        'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
        'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
        'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
        'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
        'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
        'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
        'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
        'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
    ];
    var tags = $('#input').tagsinput({
        trimValue: true,
        freeInput: true,
        tagClass: function(item,a) {
            return 'label label-primary';
            // console.log(item)
            // switch (item.continent) {
            //     case 'Europe'   : return 'label label-primary';
            //     case 'America'  : return 'label label-danger label-important';
            //     case 'Australia':
            //     case 'Africa'   : return 'label label-default';
            //     case 'Asia'     : return 'label label-warning';
            // }
        },
    });
    var inputElm = $('#input').tagsinput('input');

    inputElm.attr("type",'search')
    console.log(inputElm)
    $('#input').on('itemAdded', function (event) {
        hideTip()
        $('#input').data("add",false)
    });
    $('#container').append("<div id='tip'></div>")
    inputElm.on('input', function (val) {
        var q = val.currentTarget.value;
        var matches, substringRegex;
        matches = [];
        substrRegex = new RegExp(q, 'i');
        var tipData = q ? states.filter(value => substrRegex.test(value)) : [];
        showTip(tipData)
    }).keydown(function(e) {
        if(e.keyCode == 13){
            $('#input').data("add",true)
        }
    });
    $('#input').on('beforeItemAdd', function(event) {
        event.cancel = $('#input').data("add")?false:true
    });
    $("#tip").on('click', '.dataitem', function () {
        var data = $(this).text();
        $('#input').data("add",true)
        $('#input').tagsinput('add', data);
        $('#input').data("add",false)
        hideTip()
    })

    function showTip(data) {
        var str = data.reduce((p, c) => p + `<div class="dataitem" tabindex="-1">${c}</div>`, "")
        $('#tip').html(str).slideDown();
    }

    function hideTip() {
        $('#tip').slideUp()
    }

})