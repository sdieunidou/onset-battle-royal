function SetServerName(name) {
    name = XBBCODE.process({
		text: name,
		removeMisalignedTags: false,
		addInLineBreaks: false
    }).html;

	$('#servername').html(name);
}

function SetPlayerCount(count, max) {
	$('#playercount').text(count + " / " + max);
}

function RemovePlayers() {
	$('.player').remove();
}

function AddPlayer(id, name, ping, kills) {
	$('#playertable').append('<tr class="player"><td>'+name+'</td><td>'+kills+'</td><td>'+ping+'</td></tr>');
}