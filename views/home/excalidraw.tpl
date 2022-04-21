<!DOCTYPE html>
<html>
<head>
    <title>Excalidraw in browser</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <script src="https://cdn.jsdelivr.net/npm/react@16.14.0/umd/react.production.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/react-dom@16.13.1/umd/react-dom.production.min.js"></script>
    <link href="https://cdn.bootcdn.net/ajax/libs/pretty-checkbox/3.0.3/pretty-checkbox.min.css" rel="stylesheet">
    <link rel="preload" href="https://anhoder.github.io/media/excalidraw/FG_Virgil.woff2" as="font" type="font/woff2" crossorigin="anonymous">
    <link rel="preload" href="https://anhoder.github.io/media/excalidraw/Cascadia.woff2" as="font" type="font/woff2" crossorigin="anonymous">
    <script  src="https://cdn.jsdelivr.net/npm/@excalidraw/excalidraw-next@0.11.0-3840e2f/dist/excalidraw.production.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@excalidraw/excalidraw-next@0.11.0-3840e2f/dist/excalidraw-assets/i18n-zh-CN-json-9290d72a8c442bde9b39.js"></script>
    <style>
        body, html{
            margin-top: 0;
        }

        /* http://www.eaglefonts.com/fg-virgil-ttf-131249.htm */
        @font-face {
            font-family: "Virgil";
            src: url("https://anhoder.github.io/media/excalidraw/FG_Virgil.woff2");
            font-display: swap;
        }

        /* https://github.com/microsoft/cascadia-code */
        @font-face {
            font-family: "Cascadia";
            src: url("https://anhoder.github.io/media/excalidraw/Cascadia.woff2");
            font-display: swap;
        }
        .excalidraw {
            --color-primary: green ;
        }
        .App {
            font-family: sans-serif;
            text-align: center;
        }

        .button-wrapper button {
            z-index: 1;
            height: 40px;
            max-width: 200px;
            margin: 10px;
            padding: 5px;
        }

        .excalidraw .App-menu_top .buttonList {
            display: flex;
        }

        .excalidraw-wrapper {
            height: calc(100vh - 1em );
            margin: 0  0em 0em 0em  ;
        }
        .marktext{
            font-size: .5em;
            color: var(--keybinding-color);
            font-family: var(--ui-font);
            -webkit-user-select: none;
            user-select: none;
        }

        :root[dir="ltr"] .excalidraw .layer-ui__wrapper .zen-mode-transition.App-menu_bottom--transition-left {
            transform: none
        }

        .excalidraw .panelColumn {
            text-align: left;
        }

        .export-wrapper {
            display: flex;
            flex-direction: column;
            margin: 50px;


        }
    </style>

</head>

<body>
<div class="container">
    <div id="app"></div>
</div>
<script>
    const  { useEffect, useState, useRef, useCallback } = React;
    const App = () => {
        const excalidrawRef = React.useRef(null);
        const excalidrawWrapperRef = React.useRef(null);

        const [viewModeEnabled, setViewModeEnabled] = React.useState(false);
        const [zenModeEnabled, setZenModeEnabled] = React.useState(false);
        const [gridModeEnabled, setGridModeEnabled] = React.useState(false);
        useEffect(() => {
            const onHashChange = () => {
                const hash = new URLSearchParams(window.location.hash.slice(1));
                const libraryUrl = hash.get("addLibrary");
                if (libraryUrl) {
                    excalidrawRef.current.importLibrary(libraryUrl, hash.get("token"));
                }
            };
            window.addEventListener("hashchange", onHashChange, false);
            return () => {
                window.removeEventListener("hashchange", onHashChange);
            };
        }, []);

        return React.createElement(
            React.Fragment,
            null,

            React.createElement(
                "div",
                {
                    className: "excalidraw-wrapper",
                    ref: excalidrawWrapperRef,
                },
                React.createElement(ExcalidrawLib.Excalidraw, {
                    // onChange: (elements, state) =>
                    //     console.log("Elements :", elements, "State : ", state),
                    // onPointerUpdate: (payload) => console.log(payload),
                    onCollabButtonClick: () => window.alert("You clicked on collab button"),
                    renderTopRightUI: (isMobile,appState)=>{

                      return   isMobile ? null: React.createElement(
                          "div",
                          { className: "button-wrapper" },

                          React.createElement(
                              "label",
                              { className: "marktext"},
                              React.createElement("input", {
                                  type: "checkbox",
                                  checked: viewModeEnabled,
                                  onChange: () => setViewModeEnabled(!viewModeEnabled),
                              }),
                              "View mode",
                          ),


                          // React.createElement(
                          //     "label",
                          //     null,
                          //     React.createElement("input", {
                          //         type: "checkbox",
                          //         checked: zenModeEnabled,
                          //         onChange: () => setZenModeEnabled(!zenModeEnabled),
                          //     }),
                          //     "Zen mode",
                          // ),
                          React.createElement(
                              "label",
                              { className: "marktext"},
                              React.createElement("input", {
                                  type: "checkbox",
                                  checked: gridModeEnabled,
                                  onChange: () => setGridModeEnabled(!gridModeEnabled),
                              }),
                              "Grid mode",
                          ),
                      )


                    },
                    renderFooter:(isMobile,appState)=>{
                        console.log(appState)
                        // return React.createElement("a",null,"首页")

                    },
                    langCode: "zh-CN",
                    viewModeEnabled: viewModeEnabled,
                    zenModeEnabled: zenModeEnabled,
                    gridModeEnabled: gridModeEnabled,
                }),
            ),
        );
    };
    const excalidrawWrapper = document.getElementById("app");
    const {serializeAsJSON,restoreAppState,restoreElements,restore,FONT_FAMILY} = ExcalidrawLib
    ReactDOM.render(React.createElement(App), excalidrawWrapper);
</script>
</body>
</html>