<onup>200</onup>
<ondown>400</ondown>
{% if id in (302, 2302, 2303, 2304, 2305) %}
<onleft>noop</onleft>
<onright>304</onright>
{% elif id == 304 %}
<onleft condition="String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(unavailable))">302</onleft>
<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) + !String.IsEmpty(Window.Property(wl_availability_checking))">2302</onleft>
<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + !String.IsEmpty(Window.Property(wl_availability_multiple))">2303</onleft>
<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + String.IsEmpty(Window.Property(wl_availability_multiple)) + !String.IsEmpty(Window.Property(wl_availability))">2304</onleft>
<onleft condition="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + String.IsEmpty(Window.Property(wl_availability_multiple)) + String.IsEmpty(Window.Property(wl_availability))">2305</onleft>
<onright condition="Control.IsVisible(303)">303</onright>
<onright condition="!Control.IsVisible(303) + Control.IsVisible(308)">308</onright>
<onright condition="!Control.IsVisible(303) + !Control.IsVisible(308) + Control.IsVisible(309)">309</onright>
<onright condition="!Control.IsVisible(303) + !Control.IsVisible(308) + !Control.IsVisible(309) + Control.IsVisible(307)">307</onright>
<onright condition="!Control.IsVisible(303) + !Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(307) + Control.IsVisible(305)">305</onright>
<onright condition="!Control.IsVisible(303) + !Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(307) + !Control.IsVisible(305) + Control.IsVisible(306)">306</onright>
{% elif id == 303 %}
<onleft>304</onleft>
<onright condition="Control.IsVisible(308)">308</onright>
<onright condition="!Control.IsVisible(308) + Control.IsVisible(309)">309</onright>
<onright condition="!Control.IsVisible(308) + !Control.IsVisible(309) + Control.IsVisible(307)">307</onright>
<onright condition="!Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(307) + Control.IsVisible(305)">305</onright>
<onright condition="!Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(307) + !Control.IsVisible(305) + Control.IsVisible(306)">306</onright>
{% elif id in (308, 309) %}
<onleft condition="Control.IsVisible(303)">303</onleft>
<onleft condition="!Control.IsVisible(303)">304</onleft>
<onright condition="Control.IsVisible(307)">307</onright>
<onright condition="!Control.IsVisible(307) + Control.IsVisible(305)">305</onright>
<onright condition="!Control.IsVisible(307) + !Control.IsVisible(305) + Control.IsVisible(306)">306</onright>
{% elif id == 307 %}
<onleft condition="Control.IsVisible(308)">308</onleft>
<onleft condition="!Control.IsVisible(308) + Control.IsVisible(309)">309</onleft>
<onleft condition="!Control.IsVisible(308) + !Control.IsVisible(309) + Control.IsVisible(303)">303</onleft>
<onleft condition="!Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(303)">304</onleft>
<onright condition="Control.IsVisible(305)">305</onright>
<onright condition="!Control.IsVisible(305) + Control.IsVisible(306)">306</onright>
{% elif id == 305 %}
<onleft condition="Control.IsVisible(307)">307</onleft>
<onleft condition="!Control.IsVisible(307) + Control.IsVisible(308)">308</onleft>
<onleft condition="!Control.IsVisible(307) + !Control.IsVisible(308) + Control.IsVisible(309)">309</onleft>
<onleft condition="!Control.IsVisible(307) + !Control.IsVisible(308) + !Control.IsVisible(309) + Control.IsVisible(303)">303</onleft>
<onleft condition="!Control.IsVisible(307) + !Control.IsVisible(308) + !Control.IsVisible(309) + !Control.IsVisible(303)">304</onleft>
<onright>306</onright>
{% elif id == 306 %}
<onleft>305</onleft>
<onright>noop</onright>
{% endif %}
