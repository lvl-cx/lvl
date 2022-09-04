var player;
function DoMusic(song) {
    var vid = song
    if (player) {
        player.loadVideoById(vid,(song == 1 ? 50 : 1));
        player.seekTo(-30);
        player.playVideo();
    } else {
        player = new YT.Player('player', {
            videoId: song,
            loop: true,
            events: {
                onReady: function (e) {
                    e.target.playVideo();
                }
            }
        });
    }
}


$(document).ready(function(){


    window.addEventListener('message', function (event) {
        if (event.data.type == "playMusic") {
            DoMusic(event.data.song);
        } else if (event.data.type == "stopMusic") {
            player.pauseVideo();
        }
    });
});

// DJ Music:

window.addEventListener("message", function(event){ 
    if(event.data.type == "djPlay"){
        djMusic(event.data.song, event.data.volume)
    };
    if(event.data.type == "djStop"){
        djStop()
    };
    if(event.data.type == "djVolume"){
        djVolume(event.data.volume)
    };
    if(event.data.type == "djSkipAhead"){
        djSkipAhead()
    };
    if(event.data.type == "djSkipBack"){
        djSkipBack()
    };
    if(event.data.type == "requestProgress"){
        djRequestProgress()
    };
    if(event.data.type == "skipTo"){
        djSkipTo(event.data.time)
    };
});

function djMusic(song, volume) {
    try {
        var vid = song
        var skip = false
        if (player){
            player.stopVideo();
        }
        if (player) {
            player.loadVideoById(vid,(song == 1 ? 50 : 1));
            player.seekTo(-30);
            player.playVideo();
        } else {
            player = new YT.Player('player', {
                videoId: song,
                loop: false,
                events: {
                    onReady: function (e) {
                        e.target.playVideo();
                        e.target.setVolume(volume);
                        if (skip)
                        {
                            e.target.seekTo(50);
                        }
                    }
                }
            });
        }
    }
    catch(err){
        console.log(err)
    }
}

function djStop() {
    try {
        if (player){
            player.stopVideo();
    
        }
    }
    catch(err){

    }
    
}

function djSkipAhead() {
    try {
        if (player){
            var time = player.getCurrentTime();
            player.seekTo(time + 2, true);
        }
    }
    catch(err){

    }
    
}

function djSkipBack() {
    try {
        if (player){
            var time = player.getCurrentTime();
            if (!((time - 2) < 0)) {
                player.seekTo(time - 2, true);
            }
        }
    }
    catch(err){

    }
    
}

function onPlayerReady(event) {
    player = event.target;
}

function djVolume(volume){
    try {
        if (player){
            player.setVolume(volume)
        }
    }
    catch(err){

    }
}

function djRequestProgress(){
    try {
        if (player){
            var time = player.getCurrentTime();
            $.post('http://arma/returnProgress', JSON.stringify({
                progress: time})
            );
        }
    }
    catch(err){

    }
}

function djSkipTo(time){
    try {
        if (player){
            player.seekTo(time, true);
        }
    }
    catch(err){

    }
}


// Warning System
let f10Open = false
let crosshair = false
window.addEventListener("message", function (event) {
    let data = event.data;
    if (data.type == "showF10") {
        /*
            <tr>
                <th scope="row">1</th>
                <td>01/01/21</td>
                <td>24</td>
                <td>1</td>
                <td>Mass VDM</td>
                <td>Arthur</td>
            </tr>
        */
        showF10(true)
    } else if (data.type == "hideF10") {
        showF10(false);
    } else if (data.type == "sendWarnings") {
        let warnings = JSON.parse(data.warnings);
        let warningsHtml = ""
        for (const warning of warnings) {
            let newWarningHtml = "<tr>"
            newWarningHtml += `<th scope="row">${warning.warning_id}</th>\n`
            newWarningHtml += `<td class="text-center">${warning.warning_date}</td>\n`
            newWarningHtml += `<td class="text-center">${warning.duration}</td>\n`
            newWarningHtml += `<td class="text-center">${warning.duration/24}</td>\n`
            newWarningHtml += `<td class="text-center">${warning.reason}</td>\n`
            newWarningHtml += `</tr>\n`
            warningsHtml += `${newWarningHtml}\n`
        }
        var elem = document.getElementById("myBar");
        elem.style.width = data.points * 10 + "%";
        document.getElementById("points").innerText = `${data.points} points`
        if (data.points >= 0 && data.points <= 3) {
            elem.style.backgroundColor = "#69B34C"
            document.getElementById("points").style.color = "#69B34C"
        } else if (data.points > 3 && data.points <= 5) {
            elem.style.backgroundColor = "#ACB334"
            document.getElementById("points").style.color = "#ACB334"
        } else if (data.points > 5 && data.points <= 7) {
            elem.style.backgroundColor = "#FAB733"
            document.getElementById("points").style.color = "#FAB733"
        } else if (data.points > 7 && data.points <= 9) {
            elem.style.backgroundColor = "#FF4E11"
            document.getElementById("points").style.color = "#FF4E11"
        } else {
            elem.style.backgroundColor = "#FF0D0D"
            document.getElementById("points").style.color = "#FF0D0D"
        }
        this.document.getElementById("warningstablebody").innerHTML = warningsHtml
    }
    if (event.data.crosshair == true) {
        if (!crosshair) {
            $(".crosshair").addClass('fadeIn');
            crosshair = !crosshair;
        }
        $(".crosshair").css("display","block");
    }
    if (event.data.crosshair == false) {
        $(".crosshair").removeClass('fadeIn');
        crosshair = !crosshair;
        $(".crosshair").css("display","none");
    }
});

function showF10(bool) {
    if (bool) {
        $("#warningscontainer").fadeIn();
    } else {
        // document.getElementById("warningscontainer").style.visibility = "hidden";
        $("#warningscontainer").fadeOut();
    }
    f10Open = bool
}
