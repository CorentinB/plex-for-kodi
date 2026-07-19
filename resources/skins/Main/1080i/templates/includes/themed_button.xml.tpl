{% if preplay_style or episode_style or library_style or playlist_style or music_artist_style or seasons_style %}
<control type="group">
    {% if visible %}<visible{% if allowhiddenfocus %} allowhiddenfocus="true"{% endif %}>{{ visible }}</visible>{% endif %}
    {% if name in ("play", "play_plus") %}
    <animation effect="zoom" start="100" end="106" time="110" center="89,{{ vscale(39) }}" reversible="true" condition="Control.HasFocus({{ id }})">Conditional</animation>
    <width>178</width>
    <height>{{ vscale(78) }}</height>
    <control type="image">
        <posx>5</posx>
        <posy>{{ vscale(7) }}</posy>
        <width>168</width>
        <height>{{ vscale(64) }}</height>
        <texture>script.plex/indicators/circle-152.png</texture>
        <colordiffuse>{% if light_plate %}26FFFFFF{% else %}78000000{% endif %}</colordiffuse>
    </control>
    <control type="image">
        <visible>Control.HasFocus({{ id }})</visible>
        <posx>5</posx>
        <posy>{{ vscale(7) }}</posy>
        <width>168</width>
        <height>{{ vscale(64) }}</height>
        <texture>script.plex/indicators/circle-152.png</texture>
        <colordiffuse>F2FFFFFF</colordiffuse>
    </control>
    <control type="image">
        <visible>!Control.HasFocus({{ id }})</visible>
        <posx>5</posx>
        <posy>{{ vscale(1) }}</posy>
        <width>78</width>
        <height>{{ vscale(76) }}</height>
        <texture colordiffuse="CCFFFFFF">{{ theme.assets.buttons.base }}{{ name }}.png</texture>
    </control>
    <control type="image">
        <visible>Control.HasFocus({{ id }})</visible>
        <posx>5</posx>
        <posy>{{ vscale(1) }}</posy>
        <width>78</width>
        <height>{{ vscale(76) }}</height>
        <texture colordiffuse="FF111111">{{ theme.assets.buttons.base }}{{ name }}.png</texture>
    </control>
    <control type="label">
        <visible>!Control.HasFocus({{ id }})</visible>
        <posx>69</posx>
        <posy>0</posy>
        <width>94</width>
        <height>{{ vscale(78) }}</height>
        <font>font12</font>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$LOCALIZE[208]</label>
    </control>
    <control type="label">
        <visible>Control.HasFocus({{ id }})</visible>
        <posx>69</posx>
        <posy>0</posy>
        <width>94</width>
        <height>{{ vscale(78) }}</height>
        <font>font12</font>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>FF111111</textcolor>
        <label>$LOCALIZE[208]</label>
    </control>
    <control type="button" id="{{ id }}">
        {% if enable %}<enable>{{ enable }}</enable>{% endif %}
        {% if preplay_style %}
            {% include "includes/preplay_button_navigation.xml.tpl" %}
        {% elif episode_style %}
            {% include "includes/episode_button_navigation.xml.tpl" %}
        {% elif playlist_style %}
            {% include "includes/playlist_button_navigation.xml.tpl" %}
        {% elif music_artist_style %}
            {% include "includes/music_artist_button_navigation.xml.tpl" %}
        {% elif seasons_style %}
            {% include "includes/seasons_button_navigation.xml.tpl" %}
        {% else %}
            {% include "includes/library_button_navigation.xml.tpl" %}
        {% endif %}
        <width>178</width>
        <height>{{ vscale(78) }}</height>
        <texturefocus>script.plex/transparent-6px.png</texturefocus>
        <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
        <label> </label>
    </control>
    {% else %}
    <animation effect="zoom" start="100" end="106" time="110" center="39,{{ vscale(39) }}" reversible="true" condition="Control.HasFocus({{ id }})">Conditional</animation>
    <width>78</width>
    <height>{{ vscale(78) }}</height>
    <control type="image">
        <posx>7</posx>
        <posy>{{ vscale(7) }}</posy>
        <width>64</width>
        <height>{{ vscale(64) }}</height>
        <texture>script.plex/indicators/circle-152.png</texture>
        <colordiffuse>{% if light_plate %}26FFFFFF{% else %}78000000{% endif %}</colordiffuse>
    </control>
    <control type="image">
        <visible>Control.HasFocus({{ id }})</visible>
        <posx>7</posx>
        <posy>{{ vscale(7) }}</posy>
        <width>64</width>
        <height>{{ vscale(64) }}</height>
        <texture>script.plex/indicators/circle-152.png</texture>
        <colordiffuse>F2FFFFFF</colordiffuse>
    </control>
    <control type="image">
        <visible>!Control.HasFocus({{ id }})</visible>
        <width>78</width>
        <height>{{ vscale(78) }}</height>
        <texture colordiffuse="CCFFFFFF">{{ theme.assets.buttons.base }}{{ name }}.png</texture>
    </control>
    <control type="image">
        <visible>Control.HasFocus({{ id }})</visible>
        <width>78</width>
        <height>{{ vscale(78) }}</height>
        <texture colordiffuse="FF111111">{{ theme.assets.buttons.base }}{{ name }}.png</texture>
    </control>
    <control type="button" id="{{ id }}">
        {% if enable %}<enable>{{ enable }}</enable>{% endif %}
        {% if preplay_style %}
            {% include "includes/preplay_button_navigation.xml.tpl" %}
        {% elif episode_style %}
            {% include "includes/episode_button_navigation.xml.tpl" %}
        {% elif playlist_style %}
            {% include "includes/playlist_button_navigation.xml.tpl" %}
        {% elif music_artist_style %}
            {% include "includes/music_artist_button_navigation.xml.tpl" %}
        {% elif seasons_style %}
            {% include "includes/seasons_button_navigation.xml.tpl" %}
        {% else %}
            {% include "includes/library_button_navigation.xml.tpl" %}
        {% endif %}
        <width>78</width>
        <height>{{ vscale(78) }}</height>
        <texturefocus>script.plex/transparent-6px.png</texturefocus>
        <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
        <label> </label>
    </control>
    {% endif %}
</control>
{% else %}
<control type="button" id="{{ id }}">
    {% if visible %}<visible{% if allowhiddenfocus %} allowhiddenfocus="true"{% endif %}>{{ visible }}</visible>{% endif %}
    <hitrect x="{{ hitrect.x|default(40) }}" y="{{ hitrect.y|default(40)|vscale }}" w="{{ hitrect.w|default(96) }}" h="{{ hitrect.h|default(60)|vscale }}" />
    {% if enable %}<enable>{{ enable }}</enable>{% endif %}
    {% if elements %}{% spaceless %} {# simple key/value elements #}
        {% for var, value in elements %}<{{ var }}>{{ value }}</{{ var }}>{% endfor %}{% endspaceless %}
    {% endif %}
    {% if name == "play" and theme.buttons.zoomPlayButton %}
        <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus({{ id }})">Conditional</animation>
    {% endif %}
    {% for direction in ("onleft", "onright", "onup", "ondown") %}{% spaceless %}
        {% if resolve("direction") %}<{{ direction }}>{{ resolve("direction") }}</{{ direction }}>{% endif %}
    {% endspaceless %}{% endfor %}
    <posx>{{ attr.posx|default(0) }}</posx>
    <posy>{{ attr.posy|default(0)|vscale }}</posy>
    <width>{{ attr.width }}</width>
    <height>{{ attr.height|vscale }}</height>
    <font>{{ font|default("font12") }}</font>
    <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFE5A00D") }}"{% endif %}>{{ theme.assets.buttons.base }}{{ name }}{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
    <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}{{ name }}.png</texturenofocus>
    <label> </label>
    {% if xml %}{% spaceless %} {# complex elements #}
        {% for element in xml %}
            <{{ element.type}}{% if element.attrs %} {% for name, value in attrs %}{{ name }}="{{ value }}"{% if not loop.is_last %} {% endif %}{% endfor %}{% endif %}>{{ element.value }}</{{ element.type }}>
        {% endfor %}
    {% endspaceless %}{% endif %}
</control>
{% endif %}
