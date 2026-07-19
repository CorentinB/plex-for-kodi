{% for nav_shift in range(-512, 644, 4) %}
<animation effect="slide" end="{{ nav_shift }},0" time="1" reversible="true" condition="!String.IsEmpty(ListItem.Property(nav.offset.{{ nav_shift }}))">Conditional</animation>
{% endfor %}
