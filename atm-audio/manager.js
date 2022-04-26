const audio = [
  { name: "headshot", file: "headshot.ogg", volume: 1.00 },
  { name: "bodyshot", file: "bodyshot.ogg", volume: 1.00 },
  { name: "zipper", file: "zipper.ogg", volume: 0.650 },
  { name: "armour", file: "armour.ogg", volume: 1.00 },
  { name: "houseraid", file: "houseraid.ogg", volume: 0.050 },
  { name: "bankhiest", file: "bankhiest.ogg", volume: 1.00 },
  { name: "purchase", file: "purchase.ogg", volume: 1.00 },
  { name: "caralarm", file: "caralarm.ogg", volume: 1.00 },
  { name: "handcuff", file: "handcuff.ogg", volume: 1.00 },
]

var audioPlayer = null;
  
window.addEventListener('message', function (event) {
    if (findAudioToPlay(event.data.transactionType)) {
      let audio = findAudioToPlay(event.data.transactionType)
      if (audioPlayer != null) {
        audioPlayer.pause();
      }
      audioPlayer = new Audio("./sounds/" + audio.file);
      audioPlayer.volume = audio.volume;
      audioPlayer.play();
    }
});
  
function findAudioToPlay(name) {
    for (a of audio) {
      if (a.name == name) {
        return a
      }
    }
    return false
}