// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"

// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "topbar"
import mermaid from "mermaid"
import Cookies from "js-cookie"
import Sortable from "sortablejs"
import domtoimage from "dom-to-image"

const COOKIE_PREFIX = 'b_'

let Hooks = {}
Hooks.reorder = {
    mounted(){

    const id = this.el.dataset.category_uuid;

    Sortable.create(document.getElementById(id), {
     group: 'shared',
     handle: '.burnlist-handle', // handle's class
     animation: 150,
     onEnd: (evt) => {
        window.dispatchEvent(new CustomEvent(id, {detail : evt}), false)
    }
    });

    window.addEventListener(id, e => {
        const toCategoryUid = e.detail.to.dataset.category_uuid;
        const itemUid = e.detail.item.dataset.item_uuid;
        const oldIndex = e.detail.oldIndex;
        const newIndex = e.detail.newIndex;

        this.pushEvent("reorder", {to_category_id: toCategoryUid, old_index: oldIndex, new_index: newIndex, item_uid: itemUid})
       }, false)
    }
}

Hooks.downloadSummary = {
    mounted() {
        this.el.addEventListener('click', () => {
            const downloadActionsDiv = document.getElementById('downloadActions');

                downloadActionsDiv.style.display = "none"

                domtoimage.toJpeg(document.getElementById('summary-modal-box'), { quality: 0.95 })
                  .then(function (dataUrl) {
                      var link = document.createElement('a');
                      link.download = 'goal.jpeg';
                      link.href = dataUrl;
                      link.click();
                  })
                  .then((res) => downloadActionsDiv.style.display = "flex");
        });
    }
}

Hooks.renderTimeLine = {
    mounted(){
        mermaid.initialize({ startOnLoad: false });

        function drawTimeLine() {
           var element = document.querySelector("#timeline");
           var insertSvg = function(svgCode, bindFunctions){
                element.innerHTML = svgCode;
            };

            var graphDefinition = element.dataset.board;
            var graph = mermaid.render('graphDiv', graphDefinition, insertSvg);
        }

//      Draw the timeline on mount
        drawTimeLine();

        window.addEventListener('resize', () => {
             drawTimeLine();
        });

        document.querySelector("#timelineBtn").addEventListener('click', () => {
            drawTimeLine();
        });

    }
}

Hooks.storeBoard = {
    mounted(){
        try {
            const name = this.el.dataset.boardName;
//            Cookie expires a year from when set
            Cookies.set(COOKIE_PREFIX + name, name, { expires: 365 });
        } catch (error) {
            console.log("Couldn't save cookie");
        }
    }
}

Hooks.loadBoards = {
    mounted(){
        try {
            const theme = this.el.dataset.theme;
            const res = Object.keys(Cookies.get()).filter( entry => entry.startsWith(COOKIE_PREFIX)).map(board => buildHtmlComponent(board, theme) );
            this.el.innerHTML = res.join('');
        } catch(error) {
            console.log("Couldn't read cookies");
        }

        function buildHtmlComponent(name, theme) {
            const board = name.slice(COOKIE_PREFIX.length);
            return `<li class="step step-primary"><a href='/backcast/${encodeURI(board)}?theme=${theme}' class="link">${board}</a></li>`;
        }
    }
}

Hooks.removeOldCookie = {
    mounted() {
        const name = this.el.dataset.boardName;
        this.el.addEventListener('click', () => {
             Cookies.remove(COOKIE_PREFIX + name);
        });
    }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
