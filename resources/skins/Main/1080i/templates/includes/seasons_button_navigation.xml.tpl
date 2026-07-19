<onup>200</onup>
<ondown>400</ondown>
{% if id in (302, 2302, 2303, 2304, 2305) %}
<onleft>noop</onleft>
<onright>301</onright>
{% elif id == 301 %}
<onleft condition="Control.IsVisible(302)">302</onleft>
<onleft condition="!Control.IsVisible(302) + Control.IsVisible(2302)">2302</onleft>
<onleft condition="!Control.IsVisible(302) + Control.IsVisible(2303)">2303</onleft>
<onleft condition="!Control.IsVisible(302) + Control.IsVisible(2304)">2304</onleft>
<onleft condition="!Control.IsVisible(302) + Control.IsVisible(2305)">2305</onleft>
<onright condition="Control.IsVisible(308)">308</onright>
<onright condition="!Control.IsVisible(308) + Control.IsVisible(309)">309</onright>
<onright condition="!Control.IsVisible(308) + !Control.IsVisible(309) + Control.IsVisible(303)">303</onright>
<onright condition="!Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(303)">304</onright>
{% elif id in (308, 309) %}
<onleft>301</onleft>
<onright condition="Control.IsVisible(303)">303</onright>
<onright condition="!Control.IsVisible(303)">304</onright>
{% elif id == 303 %}
<onleft condition="Control.IsVisible(308)">308</onleft>
<onleft condition="!Control.IsVisible(308) + Control.IsVisible(309)">309</onleft>
<onleft condition="!Control.IsVisible(308) + !Control.IsVisible(309)">301</onleft>
<onright>304</onright>
{% elif id == 304 %}
<onleft condition="Control.IsVisible(303)">303</onleft>
<onleft condition="!Control.IsVisible(303) + Control.IsVisible(308)">308</onleft>
<onleft condition="!Control.IsVisible(303) + !Control.IsVisible(308) + Control.IsVisible(309)">309</onleft>
<onleft condition="!Control.IsVisible(303) + !Control.IsVisible(308) + !Control.IsVisible(309)">301</onleft>
<onright>noop</onright>
{% endif %}
