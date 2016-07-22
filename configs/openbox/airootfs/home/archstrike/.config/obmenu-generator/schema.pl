#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

item: add an item into the menu

    {item => ["command", "label", "icon"]}


cat: add a category into the menu

    {cat => ["name", "label", "icon"]}


begin_cat: begin of a category

    {begin_cat => ["name", "icon"]}


end_cat: end of a category

    {end_cat => undef}


sep: horizontal line separator

    {sep => undef}
    {sep => "label"}


exit: default "Exit" action

    {exit => ["label", "icon"]}


pipe: a pipe menu entry

    {pipe => ["command", "label", "icon"]}


raw: any valid Openbox XML string

    {raw => q(xml string)},


obgenmenu: menu entry provided by obmenu-generator

    {obgenmenu => ["label", "icon"]}

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require '/home/archstrike/.config/obmenu-generator/config.pl';

our $SCHEMA = [
    #          COMMAND             LABEL                ICON
    {item => ['spacefm',       'File Manager',      'file-manager']},
    {item => ['terminator',    'Terminal',          'terminal']},
    {item => ['firefox',       'Web Browser',       'web-browser']},
    {item => ['dmenu',         'Run command',       'system-run']},
    {item => ['terminator -e "sudo /usr/bin/archstrike-installer;bash"', 'Install ArchStrike', 'install archstrike']},
    #{item => ['pidgin',        'Instant messaging', 'system-users']},

    {sep => 'Applications'},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Other',       'applications-other']},
    {cat => ['settings',    'Settings',    'applications-accessories']},
    {cat => ['system',      'System',      'applications-system']},

    #{cat => ['qt',          'QT Applications',    'qtlogo']},
    #{cat => ['gtk',         'GTK Applications',   'gnome-applications']},
    #{cat => ['x_xfce',      'XFCE Applications',  'applications-other']},
    #{cat => ['gnome',       'GNOME Applications', 'gnome-applications']},
    #{cat => ['consoleonly', 'CLI Applications',   'applications-utilities']},

    #                  LABEL          ICON
    #{begin_cat => ['My category',  'cat-icon']},
    #             ... some items ...
    #{end_cat   => undef},

    #            COMMAND     LABEL        ICON
    #{pipe => ['obbrowser', 'Disk', 'drive-harddisk']},

    {raw => q(<menu execute="~/.config/openbox/pipemenus/obpipemenu-places ~/" id="places" label="Places"/>)},
    {raw => q(<menu execute="~/.config/openbox/pipemenus/obrecent.sh ~/" id="recent" label="Recent Files"/>)},
    #{raw => q(<menu execute="~/.config/openbox/pipemenus/obkeypipe" id="keybinds" label="Openbox Keys"/>)},
    {raw => q(<menu execute="~/.config/openbox/pipemenus/fehpipe" id="fehback" label="Wallpapers"/>)},

    {raw => q(<menu id="Preferences" label="Preferences">)},
   	    {raw => q(<menu id="Screenshot" label="Take Screenshot">)},
  		{raw => q(<item label="Now"><action name="Execute"><execute>scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/ &amp; gpicview ~/$f'</execute></action></item>)},
       		{raw => q(<item label="In 10 Seconds..."><action name="Execute"><execute>scrot -d 10 '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/ &amp; gpicview ~/$f'</execute></action></item>)},
		{raw => q(<item label="Selected Area... click &amp; drag mouse"><action name="Execute"><execute>scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/ &amp; gpicview ~/$f'</execute></action></item>)},
   {raw => q(</menu>)},
   {item => ['obkey',   'Edit Key Bindings',   undef]},
   {obgenmenu => 'Openbox Settings'},
   {raw => q(</menu>)}, 

   {sep       => undef},
	{raw => q(<item label="Exit"><action name="Execute"><execute>oblogout</execute></action></item>)},

]
