---
title: Archiv
layout: page
permalink: archiv.html
---
<section class="archive-post-list">

   {% for post in site.posts %}
       {% assign currentDate = post.date | date: "%Y" %}
       {% if currentDate != myDate %}
           {% unless forloop.first %}</ul>{% endunless %}
           <h2>{{ currentDate }}</h2>
           <ul>
           {% assign myDate = currentDate %}
       {% endif %}
       <li><span class="title"><a href="{{ post.url }}">{{ post.title }}</a></span><hr><time class="dt-published" datetime="{{ post.date | date: "%Y-%m-%dT%H:%M:%S"}}">{{ post.date | date: "%Y-%m-%d"  }}</time></li>
       {% if forloop.last %}</ul>{% endif %}
   {% endfor %}

</section> 
