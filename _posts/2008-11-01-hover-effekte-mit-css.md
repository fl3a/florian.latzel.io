---
tags:
- XHTML
- snippet
- Internet
- CSS
nid: 644
layout: post
title: Hover-Effekte mit CSS
created: 1225565724
---
Hover-Effekt ohne HTML-Event-Handler und JavaScript.<br />
Das HTML Snippet:

```
<div class="email-hover">
  <a href="/contact">
    <img src="/assets/imgs/floh-at-netzaffe-punkt-de.gif" alt="floh-at-netzaffe-punkt-de" height="12" width="114"><
   </a>
</div>
```
Das CSS-Snippet:

```
div.email-hover a{
  background: url(img/floh-at-netzaffe-punkt-de-hover.gif);
  background-repeat: no-repeat;
  display:block;
  width: 114px;
  height: 12px;
}
div.email-hover img{
  width: 114px;
  height: 12px;
  border:0;
}
div.email-hover a:hover img{
  visibility : hidden;
}
div.email-hover a:hover {/* IE FIX */
  border:0;
}
* html div.email-hover a{
  margin-right:0px
}
* html div.email-hover a:hover {
  width: 114px;
  margin-right:0; /* IE Fix */
}
```
Und so siehts aus:
<br />
<div class="email-hover">  <a href="/kontakt.html"><img src="/assets/imgs/floh-at-netzaffe-punkt-de.gif" alt="floh-at-netzaffe-punkt-de" height="12" width="114" /></a></div>
<br />
<!--break-->
