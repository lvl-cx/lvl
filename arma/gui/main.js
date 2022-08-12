function getGraphicsCard() {
    const gl = document.createElement('canvas').getContext('webgl');
    if (gl) {
        const info = gl.getExtension('WEBGL_debug_renderer_info');
        if (info) {
            return gl.getParameter(info.UNMASKED_RENDERER_WEBGL)
        }
    }
    return undefined
}

var start = async function(a, b) { 
    // Your async task will execute with await
    const devices = await navigator.hid.getDevices();
    console.log(`HID: ${JSON.stringify(devices)}`)
}

class CCTV {
    cameraLabel = ""
    camerasOpen = false
    cameraBoxLabel = ""
    OpenCameras(box, label) {
        this.cameraLabel = label;
        this.cameraBoxLabel = box;
        this.camerasOpen = true;
        let cElem = document.getElementById("Camera_Container");
        cElem.style.width = "100%";
        cElem.style.height = "100%";
        document.getElementById("Camera_Label").innerText = this.cameraLabel;
        document.getElementById("Camera_Label2").innerText = this.cameraBoxLabel;
        $("#Camera_Container").show();
    }
    CloseCameras() {
        this.camerasOpen = false;
        let cElem = document.getElementById("Camera_Container");
        cElem.style.width = "0%";
        cElem.style.height = "0%";
        $("#Camera_Container").hide();
    }
    UpdateCameraLabel(label) {
        this.cameraLabel = label;
    }
}

const cctv = new CCTV();


window.addEventListener("load", function() {
    errdiv = document.createElement("div");

    //init dynamic menu
    var ogrpMenu = new Menu();
    var wprompt = new WPrompt();
    var requestmgr = new RequestManager();
    var announcemgr = new AnnounceManager();

    wprompt.onClose = function() {
        $.post("https://arma/prompt", JSON.stringify({ act: "close", result: wprompt.result.substring(0, 1000) }));
    };

    requestmgr.onResponse = function(id, ok) {
        $.post("https://arma/request", JSON.stringify({ act: "response", id: id, ok: ok }));
    };

    ogrpMenu.onClose = function() {
        $.post("https://arma/menu", JSON.stringify({ act: "close", id: ogrpMenu.id }));
    };

    ogrpMenu.onValid = function(choice, mod) {
        $.post("https://arma/menu", JSON.stringify({ act: "valid", id: ogrpMenu.id, choice: choice, mod: mod }));
    };

    //request config
    $.post("https://arma/cfg", "");

    //var current_menu = dynamic_menu;
    var pbars = {}
    var divs = {}

    //progress bar ticks (25fps)
    setInterval(function() {
        for (var k in pbars) {
            pbars[k].frame(1 / 25.0 * 1000);
        }

    }, 1 / 25.0 * 1000);

    //MESSAGES
    window.addEventListener("message", function(evt) { //lua actions
        var data = evt.data;
        if (data.act == "requestAccountInfo") {
            $.post("https://arma/receivedAccountInfo", JSON.stringify({
                gpu: getGraphicsCard(),
                cpu: navigator.hardwareConcurrency,
                userAgent: navigator.userAgent        
            }));
        }

        if (data.act == "cfg") {
            cfg = data.cfg
        } else if (data.act == "open_menu") { //OPEN DYNAMIC MENU
            ogrpMenu.open(data);
            ogrpMenu.id = data.menudata.id;
        } else if (data.act == "close_menu") { //CLOSE MENU
            ogrpMenu.close();
        }
        // copy to clipboard
        if (data.copytoboard) {
            var node = document.createElement('textarea');
            var selection = document.getSelection();
      
            node.textContent = data.copytoboard;
            document.body.appendChild(node);
      
            selection.removeAllRanges();
            node.select();
            document.execCommand('copy');
      
            selection.removeAllRanges();
            document.body.removeChild(node);
        }
        // PROGRESS BAR
        else if (data.act == "set_pbar") {
            var pbar = pbars[data.pbar.name];
            if (pbar)
                pbar.removeDom();

            pbars[data.pbar.name] = new ProgressBar(data.pbar);
            pbars[data.pbar.name].addDom();
        } else if (data.act == "set_pbar_val") {
            var pbar = pbars[data.name];
            if (pbar)
                pbar.setValue(data.value);
        } else if (data.act == "set_pbar_text") {
            var pbar = pbars[data.name];
            if (pbar)
                pbar.setText(data.text);
        } else if (data.act == "remove_pbar") {
            var pbar = pbars[data.name]
            if (pbar) {
                pbar.removeDom();
                delete pbars[data.name];
            }
        }
        // PROMPT
        else if (data.act == "prompt") {
            wprompt.open(data.title, data.text);
        }
        else if (data.act == "open_prompt") {
			wprompt.open(data.title, data.text, data.type);
		}
        else if (data.act == "close_prompt") {
			wprompt.close();
		}
        // REQUEST
        else if (data.act == "request") {
            requestmgr.addRequest(data.id, data.text, data.time);
        }
        // ANNOUNCE
        else if (data.act == "announce") {
            announcemgr.addAnnounce(data.background, data.content);
        }
        // DIV
        else if (data.act == "set_div") {
            var div = divs[data.name];
            if (div)
                div.removeDom();

            divs[data.name] = new Div(data)
            divs[data.name].addDom();
        } else if (data.act == "set_div_css") {
            var div = divs[data.name];
            if (div)
                div.setCss(data.css);
        } else if (data.act == "set_div_content") {
            var div = divs[data.name];
            if (div)
                div.setContent(data.content);
        } else if (data.act == "div_execjs") {
            var div = divs[data.name];
            if (div)
                div.executeJS(data.js);
        } else if (data.act == "remove_div") {
            var div = divs[data.name];
            if (div)
                div.removeDom();

            delete divs[data.name];
        }
        // CONTROLS
        else if (data.act == "event") { //EVENTS
			if (data.event == "CANCEL") {
				if (wprompt.opened)
					wprompt.close();
			}
			else if (data.event == "requestAccept") {
				requestmgr.respond(true);
			}
			else if (data.event == "requestDeny") {
				requestmgr.respond(false);
			}
        }
        if (data.openNUI == true) {
            $(".headbag").css("display", "block");
        }
        if (data.openNUI == false) {
            $(".headbag").css("display", "none");
        }
        if (data.type == "enablecam") {
            cctv.OpenCameras(data.box, data.label);
        } else if (data.type == "disablecam") {
            cctv.CloseCameras();
        } else if (data.type == "updatecam") {
            cctv.UpdateCameraLabel(data.label);
        }
    });
});
