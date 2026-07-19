<control type="button" id="{{ id }}">
    <visible{% if index == 0 %} allowhiddenfocus="true"{% endif %}>!String.IsEmpty(Window.Property(button.{{ index }}))</visible>
    <enable>String.IsEmpty(Window.Property(delay_buttons)) | !String.IsEmpty(Window.Property(enable_buttons))</enable>
    <animation effect="zoom" start="100" end="104" time="110" center="auto" reversible="true">Focus</animation>
    <width>196</width>
    <height>{{ vscale(64) }}</height>
    <font>font10</font>
    <align>center</align>
    <aligny>center</aligny>
    <texturefocus colordiffuse="FFF5F5F5" border="22">script.plex/white-square-rounded.png</texturefocus>
    <texturenofocus colordiffuse="24FFFFFF" border="22">script.plex/white-square-rounded.png</texturenofocus>
    <textcolor>E6FFFFFF</textcolor>
    <focusedcolor>FF111111</focusedcolor>
    <disabledcolor>66FFFFFF</disabledcolor>
    <pulseonselect>false</pulseonselect>
    <label>$INFO[Window.Property(button.{{ index }})]</label>
</control>
