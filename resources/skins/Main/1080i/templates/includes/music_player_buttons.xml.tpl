            <control type="group" id="421">
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <control type="button" id="401">
                    <hitrect x="28" y="28" w="69" h="45" />
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <onup>500</onup>
                    <onright condition="!String.IsEmpty(Window.Property(pq.isremote))">422</onright>
                    <onright>402</onright>
                    <onleft>411</onleft>
                    <font>font12</font>
                    <texturefocus>script.plex/transparent-6px.png</texturefocus>
                    <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                    <label> </label>
                </control>
                <control type="group">
                    <visible>!Control.HasFocus(401)</visible>
                    <control type="image">
                        <visible>!Playlist.IsRepeatOne + !Playlist.IsRepeat + String.IsEmpty(Window.Property(pq.repeat))</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}repeat.png</texture>
                    </control>
                    <control type="image">
                        <visible>Playlist.IsRepeat | !String.IsEmpty(Window.Property(pq.repeat))</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}repeat.png</texture>
                    </control>
                    <control type="image">
                        <visible>Playlist.IsRepeatOne</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}repeat-one.png</texture>
                    </control>
                </control>
                <control type="group">
                    <visible>Control.HasFocus(401)</visible>
                    <control type="image">
                        <visible>!Playlist.IsRepeatOne + !Playlist.IsRepeat + String.IsEmpty(Window.Property(pq.repeat))</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat{{ theme.assets.buttons.focusSuffix }}.png</texture>
                    </control>
                    <control type="image">
                        <visible>Playlist.IsRepeat | !String.IsEmpty(Window.Property(pq.repeat))</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat{{ theme.assets.buttons.focusSuffix }}.png</texture>
                    </control>
                    <control type="image">
                        <visible>Playlist.IsRepeatOne</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat-one{{ theme.assets.buttons.focusSuffix }}.png</texture>
                    </control>
                </control>
            </control>

            <control type="togglebutton" id="402">
                <visible>String.IsEmpty(Window.Property(pq.isremote))</visible>
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft>401</onleft>
                <onright condition="MusicPlayer.HasPrevious | !String.IsEmpty(Window.Property(pq.hasprev))">404</onright>
                <onright>406</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle.png</texturenofocus>
                <usealttexture>Playlist.IsRandom</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}shuffle.png</alttexturenofocus>
                <onclick>PlayerControl(RandomOn)</onclick>
                <altclick>PlayerControl(RandomOff)</altclick>
                <label> </label>
            </control>

            <control type="group" id="432">
                <visible>!String.IsEmpty(Window.Property(pq.isremote))</visible>
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <control type="button" id="422">
                    <hitrect x="28" y="28" w="69" h="45" />
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <onup>500</onup>
                    <onright condition="MusicPlayer.HasPrevious | !String.IsEmpty(Window.Property(pq.hasprev))">404</onright>
                    <onright>406</onright>
                    <onleft>401</onleft>
                    <font>font12</font>
                    <texturefocus>script.plex/transparent-6px.png</texturefocus>
                    <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                    <label> </label>
                </control>
                <control type="group">
                    <visible>String.IsEmpty(Window.Property(pq.shuffled))</visible>
                    <control type="image">
                        <visible>!Control.HasFocus(422)</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle.png</texture>
                    </control>
                    <control type="image">
                        <visible>Control.HasFocus(422)</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texture>
                    </control>
                </control>
                <control type="group">
                    <visible>!String.IsEmpty(Window.Property(pq.shuffled))</visible>
                    <control type="image">
                        <visible>!Control.HasFocus(422)</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}shuffle.png</texture>
                    </control>
                    <control type="image">
                        <visible>Control.HasFocus(422)</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>125</width>
                        <height>{{ vscale(101) }}</height>
                        <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texture>
                    </control>
                </control>
            </control>

            <control type="button" id="404">
                <visible>MusicPlayer.HasPrevious | !String.IsEmpty(Window.Property(pq.hasprev))</visible>
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft condition="!String.IsEmpty(Window.Property(pq.isremote))">422</onleft>
                <onleft>402</onleft>
                <onright>406</onright>
                <font>font12</font>
                <texturefocus flipx="true"{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus flipx="true"{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>
            <control type="button" id="424">
                <enable>false</enable>
                <visible>!MusicPlayer.HasPrevious + String.IsEmpty(Window.Property(pq.hasprev))</visible>
                <posx>30</posx>
                <posy>0</posy>
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <font>font12</font>
                <texturefocus flipx="true" colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturefocus>
                <texturenofocus flipx="true" colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>
            <control type="togglebutton" id="406">
                <hitrect x="28" y="28" w="69" h="45" />
                {% if theme.buttons.zoomPlayButton %}
                    <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(406)">Conditional</animation>
                {% endif %}
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft condition="MusicPlayer.HasPrevious | !String.IsEmpty(Window.Property(pq.hasprev))">404</onleft>
                <onleft condition="!String.IsEmpty(Window.Property(pq.isremote))">422</onleft>
                <onleft>402</onleft>
                <onright>407</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}pause{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pause.png</texturenofocus>
                <usealttexture>Player.Paused | Player.Forwarding | Player.Rewinding</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}play{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}play.png</alttexturenofocus>
                <!-- <enable>Player.PauseEnabled</enable> -->
                <onclick>PlayerControl(Play)</onclick>
                <label> </label>
            </control>
            <control type="button" id="407">
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft>406</onleft>
                <onright condition="MusicPlayer.HasNext | !String.IsEmpty(Window.Property(pq.hasnext))">409</onright>
                <onright>410</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}stop{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}stop.png</texturenofocus>
                <onclick>PlayerControl(Stop)</onclick>
                <label> </label>
            </control>
            <control type="button" id="409">
                <visible>MusicPlayer.HasNext | !String.IsEmpty(Window.Property(pq.hasnext))</visible>
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft>407</onleft>
                <onright>410</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>
            <control type="button" id="419">
                <enable>false</enable>
                <visible>!MusicPlayer.HasNext + String.IsEmpty(Window.Property(pq.hasnext))</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <texturefocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturefocus>
                <texturenofocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>

            <control type="button" id="410">
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft condition="MusicPlayer.HasNext | !String.IsEmpty(Window.Property(pq.hasnext))">409</onleft>
                <onleft>407</onleft>
                <onright>411</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}pqueue{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pqueue.png</texturenofocus>
                <label> </label>
                <onclick>Close</onclick>
            </control>
            <control type="button" id="411">
                <hitrect x="28" y="28" w="69" h="45" />
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>500</onup>
                <onleft>410</onleft>
                <onright>401</onright>
                <font>font12</font>
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}more{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}more.png</texturenofocus>
                <label> </label>
            </control>
