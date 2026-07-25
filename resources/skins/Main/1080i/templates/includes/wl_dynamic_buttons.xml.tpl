{# watchlist dynamic play button #}
    {# checking #}
    {% include template with name="wait" & id=2302 & visible="!String.IsEmpty(Window.Property(disable_playback)) + !String.IsEmpty(Window.Property(wl_availability_checking))" & action_label="$ADDON[script.plexmod 32914]" & action_width=185 & action_label_width=113 %}
    {# available multiple #}
    {% include template with name="play_plus" & id=2303 & visible="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + !String.IsEmpty(Window.Property(wl_availability_multiple))" & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106 %}
    {# available single #}
    {% include template with name="play" & id=2304 & visible="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + String.IsEmpty(Window.Property(wl_availability_multiple)) + !String.IsEmpty(Window.Property(wl_availability))" & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106 %}
    {# not available #}
    {% include template with name="upcoming" & id=2305 & visible="!String.IsEmpty(Window.Property(disable_playback)) + String.IsEmpty(Window.Property(wl_availability_checking)) + String.IsEmpty(Window.Property(wl_availability_multiple)) + String.IsEmpty(Window.Property(wl_availability))" & action_label="$ADDON[script.plexmod 32312]" & action_width=250 & action_label_width=178 %}
{# /watchlist dynamic play button #}
