var tabs = [
	"#staff",
	"#police",
	"#nhs",
	"#members"
]

var btns = [
	"#btn1",
	"#btn2",
	"#btn3",
	"#btn4",
]

var currentTab;
var scrollbars = [];

// setup scrollbar
$('.js-pscroll').each(function(){
	var ps = new PerfectScrollbar(this);
	scrollbars.push(ps);

	$(window).on('resize', function() {
		ps.update();
	})
});

openTab(3);
$(".limiter").css("display", "none") // hide initially

function goLeft() {
	if (currentTab == 0) openTab(tabs.length-1);
	else openTab(currentTab-1);
}

function goRight() {
	if (currentTab == tabs.length-1) openTab(0);
	else openTab(currentTab+1);
}

function openTab(index) {
	currentTab = index;

	btn = btns[index];
	tab = tabs[index];

	for (var i=0; i<tabs.length; i++) {
		selector = tabs[i];

		if (selector == tab) {
			$(selector).css("display", "");
		}
		else {
			$(selector).css("display", "none");
		}
	}

	for (var i=0; i<btns.length; i++) {
		selector = btns[i];

		if (selector == btn) {
			$(selector).addClass("active");
		}
		else {
			$(selector).removeClass("active");
		}
	}

	// update scrollbars
	scrollbars.forEach(sb => {
		sb.update();
	});
}

function sanitize(string) {
	string = ""+string; // convert to string
	const map = {
		'&': '&amp;',
		'<': '&lt;',
		'>': '&gt;',
		'"': '&quot;',
		"'": '&#x27;',
		"/": '&#x2F;',
		"`": '&grave'
	};
	const reg = /[&<>"'/`]/ig;
	return string.replace(reg, (match)=>(map[match]));
  }

function getRow(player) {
	return `<tr class="row100 body">
	<td class="cell100 column1">${sanitize(player.id)}</td> 
	<td class="cell100 column2">${sanitize(player.name)}</td>
	<td class="cell100 column3">${sanitize(player.job)}</td>
	<td class="cell100 column4">${sanitize(player.timePlayed)}</td>
	</tr>`;
}

function sortObj(list, key) {
    function compare(a, b) {
        a = a[key];
		b = b[key];
		
        var type = (typeof(a) === 'string' || typeof(b) === 'string') ? 'string' : 'number';
        var result;
		
		if (type === 'string') result = a.localeCompare(b);
        else result = a - b;
		
		return result;
	}
	
    return list.sort(compare);
}

window.addEventListener('message', (event) => {
	data = event.data;

	if (data.switch != null) {
		if (data.switch) {
			goRight();
		}
		else {
			goLeft();
		}
	}

	if (!data.show) {
		$(".limiter").css("display", "none")
	}
	else {	
		$(".limiter").css("display", "")
	}

	if (data.players == null) return;

	// clear rows
	for (var i=0; i<tabs.length; i++) {
		$(tabs[i]).empty();
	}

	// insert data

	var playerCount = 0;
	for (let [group, players] of Object.entries(data.players)) {
		selector = $("#" + group);
		
		players = sortObj(players, "id");

		for (var i=0; i<players.length; i++) {
			selector.append(getRow(players[i]));
			playerCount ++;
		}
	}

	// update scrollbars
	scrollbars.forEach(sb => {
		sb.update();
	});

	$("#playercount").html(`${playerCount} Online`);
});