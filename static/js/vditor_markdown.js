
function vditorEditor ({
                           openLastSelectedNode,saveDocument,isBook
                       }) {
    if(window.editor){
        return window.editor
    }




    const queryParse = (search = window.location.search) => {
        if (!search) return {}
        const queryString = search[0] === '?' ? search.substring(1) : search
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
    const cacheState={
        none:"#586069",
        cached:"#39c911",
    }
    const clearCache = {
        name: "clear",
        tip: "清空缓存",
        hotkey: '⌘D',
        icon:'<svg t="1630746420909" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="6134" xmlns:xlink="http://www.w3.org/1999/xlink" width="16" height="16"><defs><style type="text/css"></style></defs><path d="M871.9104 240.64v648.1152c0 59.776-54.784 108.0576-122.3424 108.0576H260.5824c-67.584 0-122.3424-48.384-122.3424-108.0576V240.64h733.6704zM390.144 422.912h-61.44v417.92h61.44V422.912z m294.912 0h-61.44v417.92h61.44V422.912zM660.48 25.6l61.4656 58.8032H906.24a30.72 30.72 0 0 1 30.72 30.72v56.192a30.72 30.72 0 0 1-30.72 30.72H107.52a30.72 30.72 0 0 1-30.72-30.72V115.1232a30.72 30.72 0 0 1 30.72-30.72h184.2944L353.2544 25.6H660.48z" p-id="6135" id="wy_cache" fill="#586069"></path></svg>',
        async click(element, vditor) {

        },
    }
    const saveButton = {
        name: "save",
        tip: "保存",
        icon:'<svg  t="1629634645921" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="12174" width="32" height="32" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><style type="text/css"></style></defs><path d="M959.937 903.937c0 30.913-25.081 55.996-55.996 55.996L119.996 959.933C89.081 959.933 64 934.85 64 903.937l0-783.94C64 89.082 89.081 64 119.996 64l541.293 0c30.915 0 73.49 17.495 95.659 39.662l163.323 163.323c22.169 22.168 39.665 64.744 39.665 95.658L959.936 903.937zM885.273 885.27 885.273 362.644c0-11.079-9.916-34.998-17.494-42.583L703.874 156.157c-8.168-8.167-30.916-17.496-42.585-17.496l0 242.65c0 30.914-25.081 55.996-55.996 55.996L269.318 437.307c-30.915 0-55.996-25.082-55.996-55.996l0-242.65-74.662 0L138.66 885.27l74.662 0L213.322 642.626c0-30.917 25.081-55.996 55.996-55.996l485.3 0c30.913 0 55.996 25.079 55.996 55.996L810.614 885.27 885.273 885.27zM735.951 885.27 735.951 661.29 287.984 661.29 287.984 885.27 735.951 885.27zM586.629 157.328c0-9.918-8.748-18.667-18.666-18.667L455.971 138.661c-9.917 0-18.665 8.748-18.665 18.667l0 186.652c0 9.919 8.748 18.665 18.665 18.665l111.992 0c9.918 0 18.666-8.746 18.666-18.665L586.629 157.328z" p-id="12175" id="wy_save" fill="#586069"></path></svg>',
        hotkey: '⌘S',
        async click(element, vditor) {
            saveDocument(false,()=>{
                $('#wy_save').attr('fill',cacheState.none)
            })
        },
    }
    const bookmark = {
        name: "bookmark",
        tip: "目录",
        icon:'<svg t="1648995610752" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2750" width="32" height="32"><path d="M902.779659 795.440467c-6.179746-6.181793-14.304797-9.577123-22.950711-9.577123L129.341299 785.863345c-17.945721 0-32.540114 14.59644-32.540114 32.525788 0 17.962094 14.594393 32.555463 32.540114 32.555463l750.487649 0c17.931395 0 32.525788-14.594393 32.525788-32.555463C912.354735 809.745265 908.959406 801.61919 902.779659 795.440467" p-id="2751" fill="#586069"></path><path d="M879.828948 461.055724 129.341299 461.055724c-17.945721 0-32.525788 14.594393-32.525788 32.541137 0 17.930371 14.580067 32.525788 32.525788 32.525788l750.487649 0c17.931395 0 32.525788-14.594393 32.525788-32.525788 0-8.647961-3.39533-16.800641-9.575076-22.980387C896.599913 464.436728 888.474862 461.055724 879.828948 461.055724" p-id="2752" fill="#586069"></path><path d="M902.779659 154.426115c-6.179746-6.179746-14.304797-9.574053-22.950711-9.574053L129.341299 144.852062c-17.945721 0-32.540114 14.594393-32.540114 32.540114 0 17.946744 14.594393 32.525788 32.540114 32.525788l750.487649 0c17.931395 0 32.525788-14.579043 32.525788-32.525788C912.354735 168.745239 908.959406 160.606885 902.779659 154.426115" p-id="2753" fill="#586069"></path></svg>',
        hotkey: '⌘l',
        async click(element, vditor) {
            $('#manualCategory,#manual-mask').toggle();

        },
    }
    const back = {
        name: "back",
        tip: "返回",
        icon:'<svg t="1648995784294" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3645" width="32" height="32"><path d="M888 462.4L544 142.4c-19.2-17.6-48-17.6-65.6 0l-344 320c-9.6 9.6-16 22.4-16 35.2v355.2c0 27.2 22.4 49.6 49.6 49.6h683.2c27.2 0 49.6-22.4 49.6-49.6V497.6c3.2-12.8-3.2-25.6-12.8-35.2z m-32 392c0 1.6-1.6 1.6-1.6 1.6h-240V657.6c0-56-46.4-102.4-102.4-102.4-56 0-102.4 46.4-102.4 102.4v198.4h-240c-1.6 0-1.6-1.6-1.6-1.6V497.6l344-320 344 320v356.8z" p-id="3646" fill="#586069"></path></svg>',
        hotkey: '⌘b',
        async click(element, vditor) {
            if(document.referrer && document.referrer != window.location.href){
                window.location.href = document.referrer;
            }else {
                window.location = window.location.origin
            }
        },
    }
    const pasterButton={
        name: 'paste url',
        tip: "paster url",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" width="16" height="16" ><path d="M128 184c0-30.879 25.122-56 56-56h136V56c0-13.255-10.745-24-24-24h-80.61C204.306 12.89 183.637 0 160 0s-44.306 12.89-55.39 32H24C10.745 32 0 42.745 0 56v336c0 13.255 10.745 24 24 24h104V184zm32-144c13.255 0 24 10.745 24 24s-10.745 24-24 24-24-10.745-24-24 10.745-24 24-24zm184 248h104v200c0 13.255-10.745 24-24 24H184c-13.255 0-24-10.745-24-24V184c0-13.255 10.745-24 24-24h136v104c0 13.2 10.8 24 24 24zm104-38.059V256h-96v-96h6.059a24 24 0 0 1 16.97 7.029l65.941 65.941a24.002 24.002 0 0 1 7.03 16.971z" fill="#586069"/></svg>',
        hotkey: '⌘P',

        async click(element){
            let text=""
            try {
                text = await navigator.clipboard.readText();
            } catch (e) {
            }
            if(text.startsWith("http")){
                const title=text.split('.').length>1&&text.split('.')[1]
                vditor.insertValue(`[${title}](${text})`)
            }else {
                text&&vditor.insertValue(text)
            }
        }
    }


    const config = {
        toolbarConfig: {
            pin: true,
        },


        height: window.innerHeight,
        outline: {
            enable: true
        },

        input: (value)=>{

            // $('#wy_save').attr('fill',cacheState.cached)
        },

        mode: "sv",

        cache: {

            enable: false
        },
        async after() {
            $('#manual-mask').click(()=>$('#manualCategory,#manual-mask').toggle())
            setTimeout(()=>{
                openLastSelectedNode&&openLastSelectedNode()
            },2000)

        },
        toolbar: isBook?[bookmark, back, saveButton,pasterButton,clearCache]:[back, saveButton,pasterButton,clearCache]
    }
    const vditor = new Vditor('vditor', config)







    vditor.getPreviewedHTML = ()=>{
        return vditor.getHTML()
    }

    vditor.getMarkdown = ()=>{
        return vditor.getValue();
    }



























    return vditor
}

