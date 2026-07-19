<onup>200</onup>
<ondown>400</ondown>
{% if id == 302 %}
<onleft>noop</onleft>
<onright>301</onright>
{% elif id == 301 %}
<onleft>302</onleft>
<onright>303</onright>
{% elif id == 303 %}
<onleft>301</onleft>
<onright>304</onright>
{% elif id == 304 %}
<onleft>303</onleft>
<onright>noop</onright>
{% endif %}
