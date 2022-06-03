# Copyright © 2021 rdbende <rdbende@gmail.com>

# A stunning light theme for ttk based on Microsoft's Sun Valley visual style 

package require Tk 8.6

namespace eval ttk::theme::r-sun-valley-light {
    variable version 1.0
    package provide ttk::theme::r-sun-valley-light $version

    ttk::style theme create r-sun-valley-light -parent clam -settings {
        proc load_images {imgdir} {
            variable images
            foreach file [glob -directory $imgdir *.png] {
                set images([file tail [file rootname $file]]) \
                [image create photo -file $file -format png]
            }
        }

        load_images [file join [file dirname [info script]] light]

        array set colors {
            -fg             "#202020"
            -bg             "#fafafa"
            -disabledfg     "#a0a0a0"
            -selectfg       "#ffffff"
            -selectbg       "#2f60d8"
        }
        
        ttk::style layout TButton {
            Button.button -children {
                Button.padding -children {
                    Button.label -side left -expand 1
                } 
            }
        }

        ttk::style layout Toolbutton {
            Toolbutton.button -children {
                Toolbutton.padding -children {
                    Toolbutton.label -side left -expand 1
                } 
            }
        }

        ttk::style layout TMenubutton {
            Menubutton.button -children {
                Menubutton.padding -children {
                    Menubutton.label -side left -expand 1
                    Menubutton.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout TOptionMenu {
            OptionMenu.button -children {
                OptionMenu.padding -children {
                    OptionMenu.label -side left -expand 1
                    OptionMenu.indicator -side right -sticky nsew
                }
            }
        }

        ttk::style layout Titlebar.TButton {
            TitlebarButton.button -children {
                TitlebarButton.padding -children {
                    TitlebarButton.label -side left -expand 1
                } 
            }
        }

        ttk::style layout Close.Titlebar.TButton {
            CloseButton.button -children {
                CloseButton.padding -children {
                    CloseButton.label -side left -expand 1
                } 
            }
        }

        ttk::style layout TCheckbutton {
            Checkbutton.button -children {
                Checkbutton.padding -children {
                    Checkbutton.indicator -side left
                    Checkbutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Switch.TCheckbutton {
            Switch.button -children {
                Switch.padding -children {
                    Switch.indicator -side left
                    Switch.label -side right -expand 1
                }
            }
        }

        ttk::style layout Toggle.TButton {
            ToggleButton.button -children {
                ToggleButton.padding -children {
                    ToggleButton.label -side left -expand 1
                } 
            }
        }

        ttk::style layout TRadiobutton {
            Radiobutton.button -children {
                Radiobutton.padding -children {
                    Radiobutton.indicator -side left
                    Radiobutton.label -side right -expand 1
                }
            }
        }

        ttk::style layout Vertical.TScrollbar {
            Vertical.Scrollbar.trough -sticky ns -children {
                Vertical.Scrollbar.uparrow -side top
                Vertical.Scrollbar.downarrow -side bottom
                Vertical.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout Horizontal.TScrollbar {
            Horizontal.Scrollbar.trough -sticky ew -children {
                Horizontal.Scrollbar.leftarrow -side left
                Horizontal.Scrollbar.rightarrow -side right
                Horizontal.Scrollbar.thumb -expand 1
            }
        }

        ttk::style layout TSeparator {
            TSeparator.separator -sticky nsew
        }

        ttk::style layout TCombobox {
            Combobox.field -sticky nsew -children {
                Combobox.padding -expand 1 -sticky nsew -children {
                    Combobox.textarea -sticky nsew
                }
            }
            null -side right -sticky ns -children {
                Combobox.arrow -sticky nsew
            }
        }
        
        ttk::style layout TSpinbox {
            Spinbox.field -sticky nsew -children {
                Spinbox.padding -expand 1 -sticky nsew -children {
                    Spinbox.textarea -sticky nsew
                }
                
            }
            null -side right -sticky nsew -children {
                Spinbox.uparrow -side left -sticky nsew
                Spinbox.downarrow -side right -sticky nsew
            }
        }  
        
        ttk::style layout Card.TFrame {
            Card.field {
                Card.padding -expand 1 
            }
        }

        ttk::style layout TLabelframe {
            Labelframe.border {
                Labelframe.padding -expand 1 -children {
                    Labelframe.label -side left
                }
            }
        }

        ttk::style layout TNotebook {
            Notebook.border -children {
                TNotebook.Tab -expand 1
                Notebook.client -sticky nsew
            }
        }

        ttk::style layout Treeview.Item {
            Treeitem.padding -sticky nsew -children {
                Treeitem.image -side left -sticky {}
                Treeitem.indicator -side left -sticky {}
                Treeitem.text -side left -sticky {}
            }
        }
        
        # Set more BG colours to the default
        # Mike @coolbutuseless 2022-05-19
        ttk::style configure TFrame -background $colors(-bg)
        ttk::style configure TLabel -background $colors(-bg)
        ttk::style configure TLabelframe -background $colors(-bg)
        ttk::style configure TLabelframe.Label -background $colors(-bg)
        ttk::style configure TCheckbutton -background $colors(-bg)
        ttk::style configure TRadiobutton -background $colors(-bg)
        ttk::style configure TScale -background $colors(-bg)
        ttk::style configure TProgressbar -background $colors(-bg)
        
        # More TLabel styles
        ttk::style configure h1.TLabel -background $colors(-bg) -font h1
        ttk::style configure h2.TLabel -background $colors(-bg) -font h2
        ttk::style configure h3.TLabel -background $colors(-bg) -font h3
        ttk::style configure h4.TLabel -background $colors(-bg) -font h4
        ttk::style configure h5.TLabel -background $colors(-bg) -font h5

        # Button
        ttk::style configure TButton -padding {8 4} -anchor center -foreground $colors(-fg)
        ttk::style map TButton -foreground [list disabled #a2a2a2 pressed #636363 active #1a1a1a]

        ttk::style element create Button.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-disabled) \
                disabled $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Toolbutton
        ttk::style configure Toolbutton -padding {8 4} -anchor center

        ttk::style element create Toolbutton.button image \
            [list $images(empty) \
                {selected disabled} $images(button-disabled) \
                selected $images(button-rest) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Menubutton
        ttk::style configure TMenubutton -padding {8 4 0 4}

        ttk::style element create Menubutton.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew 

        ttk::style element create Menubutton.indicator image $images(arrow-down) -width 28 -sticky {}

        # OptionMenu
        ttk::style configure TOptionMenu -padding {8 4 0 4}

        ttk::style element create OptionMenu.button \
            image [list $images(button-rest) \
                disabled $images(button-disabled) \
                pressed $images(button-pressed) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew 

        ttk::style element create OptionMenu.indicator image $images(arrow-down) -width 28 -sticky {}
        
        
        # Guestimates of colours in bootstrap
        # Button    COlour    Text
        #---------------------------------
        # Primary   #0070FF    light
        # Secondary #616A72    light
        # Success   #249D3C     light
        # Danger    #D72F3C    light
        # Warning   #FFB908    dark=#212427
        # Info      #1798AF    light
        # Light     #F7F8F9    dark
        # Dark      #2E3338    light
        
        # Bootstrap style buttons
        ttk::style configure   primary.TButton -padding {8 4} -anchor center -foreground #ffffff -background #0070FF
        ttk::style configure secondary.TButton -padding {8 4} -anchor center -foreground #ffffff -background #616A72
        ttk::style configure   success.TButton -padding {8 4} -anchor center -foreground #ffffff -background #249D3C
        ttk::style configure    danger.TButton -padding {8 4} -anchor center -foreground #ffffff -background #D72F3C
        ttk::style configure   warning.TButton -padding {8 4} -anchor center -foreground #212427 -background #FFB908
        ttk::style configure      info.TButton -padding {8 4} -anchor center -foreground #ffffff -background #1798AF
        ttk::style configure     light.TButton -padding {8 4} -anchor center -foreground #212427 -background #F7F8F9
        ttk::style configure      dark.TButton -padding {8 4} -anchor center -foreground #ffffff -background #2E3338


        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Accent.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout Accent.TButton {
            AccentButton.button -children {
                AccentButton.padding -children {
                    AccentButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure Accent.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map Accent.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create AccentButton.button image \
            [list $images(button-accent-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-accent-disabled) \
                selected $images(button-accent-rest) \
                pressed $images(button-accent-pressed) \
                active $images(button-accent-hover) \
            ] -border 4 -sticky nsew
            
            

        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # primary.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout primary.TButton {
            primaryButton.button -children {
                primaryButton.padding -children {
                    primaryButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure primary.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map primary.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create primaryButton.button image \
            [list $images(button-primary-rest) \
                {selected disabled} $images(button-primary-disabled) \
                disabled $images(button-primary-disabled) \
                selected $images(button-primary-rest) \
                pressed $images(button-primary-pressed) \
                active $images(button-primary-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # secondary.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout secondary.TButton {
            secondaryButton.button -children {
                secondaryButton.padding -children {
                    secondaryButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure secondary.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map secondary.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create secondaryButton.button image \
            [list $images(button-secondary-rest) \
                {selected disabled} $images(button-secondary-disabled) \
                disabled $images(button-secondary-disabled) \
                selected $images(button-secondary-rest) \
                pressed $images(button-secondary-pressed) \
                active $images(button-secondary-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # success.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout success.TButton {
            successButton.button -children {
                successButton.padding -children {
                    successButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure success.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map success.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create successButton.button image \
            [list $images(button-success-rest) \
                {selected disabled} $images(button-success-disabled) \
                disabled $images(button-success-disabled) \
                selected $images(button-success-rest) \
                pressed $images(button-success-pressed) \
                active $images(button-success-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # danger.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout danger.TButton {
            dangerButton.button -children {
                dangerButton.padding -children {
                    dangerButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure danger.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map danger.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create dangerButton.button image \
            [list $images(button-danger-rest) \
                {selected disabled} $images(button-danger-disabled) \
                disabled $images(button-danger-disabled) \
                selected $images(button-danger-rest) \
                pressed $images(button-danger-pressed) \
                active $images(button-danger-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # warning.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout warning.TButton {
            warningButton.button -children {
                warningButton.padding -children {
                    warningButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure warning.TButton -padding {8 4} -anchor center -foreground #212427
        ttk::style map warning.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create warningButton.button image \
            [list $images(button-warning-rest) \
                {selected disabled} $images(button-warning-disabled) \
                disabled $images(button-warning-disabled) \
                selected $images(button-warning-rest) \
                pressed $images(button-warning-pressed) \
                active $images(button-warning-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # info.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout info.TButton {
            infoButton.button -children {
                infoButton.padding -children {
                    infoButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure info.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map info.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create infoButton.button image \
            [list $images(button-info-rest) \
                {selected disabled} $images(button-info-disabled) \
                disabled $images(button-info-disabled) \
                selected $images(button-info-rest) \
                pressed $images(button-info-pressed) \
                active $images(button-info-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # light.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout light.TButton {
            lightButton.button -children {
                lightButton.padding -children {
                    lightButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure light.TButton -padding {8 4} -anchor center -foreground #212427
        ttk::style map light.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create lightButton.button image \
            [list $images(button-light-rest) \
                {selected disabled} $images(button-light-disabled) \
                disabled $images(button-light-disabled) \
                selected $images(button-light-rest) \
                pressed $images(button-light-pressed) \
                active $images(button-light-hover) \
            ] -border 4 -sticky nsew




        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # dark.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style layout dark.TButton {
            darkButton.button -children {
                darkButton.padding -children {
                    darkButton.label -side left -expand 1
                } 
            }
        }
        
        ttk::style configure dark.TButton -padding {8 4} -anchor center -foreground #ffffff
        ttk::style map dark.TButton -foreground [list disabled #ffffff pressed #c1d8ee]

        ttk::style element create darkButton.button image \
            [list $images(button-dark-rest) \
                {selected disabled} $images(button-dark-disabled) \
                disabled $images(button-dark-disabled) \
                selected $images(button-dark-rest) \
                pressed $images(button-dark-pressed) \
                active $images(button-dark-hover) \
            ] -border 4 -sticky nsew



        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # Titlebar.TButton
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        ttk::style configure Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a

        ttk::style map Titlebar.TButton -foreground \
            [list disabled #a0a0a0 \
                pressed #606060 \
                active #191919]

        ttk::style element create TitlebarButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-titlebar-pressed) \
                active $images(button-titlebar-hover) \
            ] -border 4 -sticky nsew

        # Close.Titlebar.TButton
        ttk::style configure Close.Titlebar.TButton -padding {8 4} -anchor center -foreground #1a1a1a

        ttk::style map Close.Titlebar.TButton -foreground \
            [list disabled #a0a0a0 \
                pressed #efc6c2 \
                active #ffffff]

        ttk::style element create CloseButton.button image \
            [list $images(empty) \
                disabled $images(empty) \
                pressed $images(button-close-pressed) \
                active $images(button-close-hover) \
            ] -border 4 -sticky nsew

        # Checkbutton
        ttk::style configure TCheckbutton -padding 4

        ttk::style element create Checkbutton.indicator image \
            [list $images(check-unsel-rest) \
                {alternate disabled} $images(check-tri-disabled) \
                {selected disabled} $images(check-disabled) \
                disabled $images(check-unsel-disabled) \
                {pressed alternate} $images(check-tri-hover) \
                {active alternate} $images(check-tri-hover) \
                alternate $images(check-tri-rest) \
                {pressed selected} $images(check-hover) \
                {active selected} $images(check-hover) \
                selected $images(check-rest) \
                {pressed !selected} $images(check-unsel-pressed) \
                active $images(check-unsel-hover) \
            ] -width 26 -sticky w

        # Switch.TCheckbutton
        ttk::style element create Switch.indicator image \
            [list $images(switch-off-rest) \
                {selected disabled} $images(switch-on-disabled) \
                disabled $images(switch-off-disabled) \
                {pressed selected} $images(switch-on-pressed) \
                {active selected} $images(switch-on-hover) \
                selected $images(switch-on-rest) \
                {pressed !selected} $images(switch-off-pressed) \
                active $images(switch-off-hover) \
            ] -width 46 -sticky w

        # Toggle.TButton
        ttk::style configure Toggle.TButton -padding {8 4 8 4} -anchor center -foreground $colors(-fg)

        ttk::style map Toggle.TButton -foreground \
            [list {selected disabled} #ffffff \
                {selected pressed} #636363 \
                selected #ffffff \
                pressed #c1d8ee \
                disabled #a2a2a2 \
                active #1a1a1a
            ]

        ttk::style element create ToggleButton.button image \
            [list $images(button-rest) \
                {selected disabled} $images(button-accent-disabled) \
                disabled $images(button-disabled) \
                {pressed selected} $images(button-rest) \
                {active selected} $images(button-accent-hover) \
                selected $images(button-accent-rest) \
                {pressed !selected} $images(button-accent-rest) \
                active $images(button-hover) \
            ] -border 4 -sticky nsew

        # Radiobutton
        ttk::style configure TRadiobutton -padding 4

        ttk::style element create Radiobutton.indicator image \
            [list $images(radio-unsel-rest) \
                {selected disabled} $images(radio-disabled) \
                disabled $images(radio-unsel-disabled) \
                {pressed selected} $images(radio-pressed) \
                {active selected} $images(radio-hover) \
                selected $images(radio-rest) \
                {pressed !selected} $images(radio-unsel-pressed) \
                active $images(radio-unsel-hover) \
            ] -width 26 -sticky w

        # Scrollbar
        ttk::style element create Horizontal.Scrollbar.trough image $images(scroll-hor-trough) -sticky ew -border 6
        ttk::style element create Horizontal.Scrollbar.thumb image $images(scroll-hor-thumb) -sticky ew -border 3

        ttk::style element create Horizontal.Scrollbar.rightarrow image $images(scroll-right) -sticky {} -width 12
        ttk::style element create Horizontal.Scrollbar.leftarrow image $images(scroll-left) -sticky {} -width 12

        ttk::style element create Vertical.Scrollbar.trough image $images(scroll-vert-trough) -sticky ns -border 6
        ttk::style element create Vertical.Scrollbar.thumb image $images(scroll-vert-thumb) -sticky ns -border 3

        ttk::style element create Vertical.Scrollbar.uparrow image $images(scroll-up) -sticky {} -height 12
        ttk::style element create Vertical.Scrollbar.downarrow image $images(scroll-down) -sticky {} -height 12

        # Scale
        ttk::style element create Horizontal.Scale.trough image $images(scale-trough-hor) \
            -border 5 -padding 0

        ttk::style element create Vertical.Scale.trough image $images(scale-trough-vert) \
            -border 5 -padding 0

        ttk::style element create Scale.slider \
            image [list $images(scale-thumb-rest) \
                disabled $images(scale-thumb-disabled) \
                pressed $images(scale-thumb-pressed) \
                active $images(scale-thumb-hover) \
            ] -sticky {}

        # Progressbar
        ttk::style element create Horizontal.Progressbar.trough image $images(progress-trough-hor) \
            -border 1 -sticky ew

        ttk::style element create Horizontal.Progressbar.pbar image $images(progress-pbar-hor) \
            -border 2 -sticky ew

        ttk::style element create Vertical.Progressbar.trough image $images(progress-trough-vert) \
            -border 1 -sticky ns

        ttk::style element create Vertical.Progressbar.pbar image $images(progress-pbar-vert) \
            -border 2 -sticky ns

        # Entry
        ttk::style configure TEntry -foreground $colors(-fg)

        ttk::style map TEntry -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style element create Entry.field \
            image [list $images(entry-rest) \
                {focus hover !invalid} $images(entry-focus) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                {focus !invalid} $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding 8 -sticky nsew

        # Combobox
        ttk::style configure TCombobox -foreground $colors(-fg)

        ttk::style configure ComboboxPopdownFrame -borderwidth 1 -relief solid

        ttk::style map TCombobox -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style map TCombobox -selectbackground [list \
            {readonly hover} $colors(-selectbg) \
            {readonly focus} $colors(-selectbg) \
        ] -selectforeground [list \
            {readonly hover} $colors(-selectfg) \
            {readonly focus} $colors(-selectfg) \
        ]

        ttk::style element create Combobox.field \
            image [list $images(entry-rest) \
                {readonly disabled} $images(button-disabled) \
                {readonly pressed} $images(button-pressed) \
                {readonly hover} $images(button-hover) \
                readonly $images(button-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 28 8}
            
        ttk::style element create Combobox.arrow image $images(arrow-down) -width 35 -sticky {}

        # Spinbox
        ttk::style configure TSpinbox -foreground $colors(-fg)

        ttk::style map TSpinbox -foreground \
            [list disabled #0a0a0a \
                pressed #636363 \
                active #626262
            ]

        ttk::style element create Spinbox.field \
            image [list $images(entry-rest) \
                invalid $images(entry-invalid) \
                disabled $images(entry-disabled) \
                focus $images(entry-focus) \
                hover $images(entry-hover) \
            ] -border 5 -padding {8 8 54 8} -sticky nsew

        ttk::style element create Spinbox.uparrow image $images(arrow-up) -width 35 -sticky {}
        ttk::style element create Spinbox.downarrow image $images(arrow-down) -width 35 -sticky {}

        # Sizegrip
        ttk::style element create Sizegrip.sizegrip image $images(sizegrip) \
            -sticky nsew

        # Separator
        ttk::style element create TSeparator.separator image $images(separator)

        # Card
        ttk::style element create Card.field image $images(card) \
            -border 10 -padding 4 -sticky nsew

        # Labelframe
        ttk::style element create Labelframe.border image $images(card) \
            -border 5 -padding 4 -sticky nsew
        
        # Notebook
        ttk::style configure TNotebook -padding 1

        ttk::style element create Notebook.border \
            image $images(notebook-border) -border 5 -padding 5

        ttk::style element create Notebook.client image $images(notebook)

        ttk::style element create Notebook.tab \
            image [list $images(tab-rest) \
                selected $images(tab-selected) \
                active $images(tab-hover) \
            ] -border 13 -padding {16 14 16 6} -height 32

        # Treeview
        ttk::style element create Treeview.field image $images(card) \
            -border 5

        ttk::style element create Treeheading.cell \
            image [list $images(treeheading-rest) \
                pressed $images(treeheading-pressed) \
                active $images(treeheading-hover)
            ] -border 5 -padding 15 -sticky nsew
        
        ttk::style element create Treeitem.indicator \
            image [list $images(arrow-right) \
                user2 $images(empty) \
                user1 $images(arrow-down) \
            ] -width 26 -sticky {}

        ttk::style configure Treeview -foregound #1a1a1a -background $colors(-bg) -rowheight [expr {[font metrics font -linespace] + 2}]
        ttk::style map Treeview \
            -background [list selected #f0f0f0] \
            -foreground [list selected #191919]

        # Panedwindow
        # Insane hack to remove clam's ugly sash
        ttk::style configure Sash -gripcount 0
    }
}