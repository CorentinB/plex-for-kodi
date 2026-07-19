<onup>200</onup>
<ondown>400</ondown>
{% if id in (301, 306) %}
<onleft>noop</onleft>
<onright>304</onright>
{% elif id == 304 %}
<onleft condition="Control.IsVisible(301)">301</onleft>
<onleft condition="!Control.IsVisible(301) + Control.IsVisible(306)">306</onleft>
<onright>305</onright>
{% elif id == 305 %}
<onleft>304</onleft>
<onright>303</onright>
{% elif id == 303 %}
<onleft>305</onleft>
<onright>302</onright>
{% elif id == 302 %}
<onleft>303</onleft>
<onright>noop</onright>
{% elif id in (1301, 1306) %}
<onleft>noop</onleft>
<onright>1304</onright>
{% elif id == 1304 %}
<onleft condition="Control.IsVisible(1301)">1301</onleft>
<onleft condition="!Control.IsVisible(1301) + Control.IsVisible(1306)">1306</onleft>
<onright>1307</onright>
{% elif id == 1307 %}
<onleft>1304</onleft>
<onright>1305</onright>
{% elif id == 1305 %}
<onleft>1307</onleft>
<onright>1303</onright>
{% elif id == 1303 %}
<onleft>1305</onleft>
<onright>1302</onright>
{% elif id == 1302 %}
<onleft>1303</onleft>
<onright>noop</onright>
{% endif %}
