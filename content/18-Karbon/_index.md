+++
title = "Karbon"
menuTitle = "18. Karbon"
date = 2018-12-29T17:15:52Z
weight = 18
chapter = true
+++
### Chapter 18

# Karbon - Demo


<style>
.container {
  max-width: 800px;
  margin: 0 auto;
}
.plyr {
  border-radius: 4px;
  margin-bottom: 15px;
}
</style>
<script src="/js/control.js">
</script>

<!--
<video id="plyr-video" poster="" controls>
  <source src="Karbon.mp4" type="video/mp4">
</video> -->

<div class="container">
<video controls crossorigin playsinline poster="karbon-poster.jpg" id="player">
                <!-- Video files -->
                <source src="Karbon.mp4" type="video/mp4">
 </video>

  <div class="actions">
    <button type="button" class="btn js-play">Play</button>
    <button type="button" class="btn js-pause">Pause</button>
    <button type="button" class="btn js-stop">Stop</button>
    <button type="button" class="btn js-rewind">Rewind</button>
    <button type="button" class="btn js-forward">Forward</button>
  </div>
</div>
