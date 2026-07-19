<onup>200</onup>
<ondown>101</ondown>
{% if id == 301 %}
<onleft>210</onleft>
<onright condition="Control.IsVisible(302)">302</onright>
<onright condition="!Control.IsVisible(302) + Control.IsVisible(303)">303</onright>
<onright condition="!Control.IsVisible(302) + !Control.IsVisible(303)">304</onright>
{% elif id == 302 %}
<onleft>301</onleft>
<onright condition="Control.IsVisible(303)">303</onright>
<onright condition="!Control.IsVisible(303)">304</onright>
{% elif id == 303 %}
<onleft condition="Control.IsVisible(302)">302</onleft>
<onleft condition="!Control.IsVisible(302)">301</onleft>
<onright>304</onright>
{% elif id == 304 %}
<onleft condition="Control.IsVisible(303)">303</onleft>
<onleft condition="!Control.IsVisible(303) + Control.IsVisible(302)">302</onleft>
<onleft condition="!Control.IsVisible(303) + !Control.IsVisible(302)">301</onleft>
<onright>600</onright>
{% endif %}
