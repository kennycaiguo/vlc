/*****************************************************************************
 * macosx.m: Mac OS X module for vlc
 *****************************************************************************
 * Copyright (C) 2001-2006 the VideoLAN team
 * $Id$
 *
 * Authors: Colin Delacroix <colin@zoy.org>
 *          Eugenio Jarosiewicz <ej0@cise.ufl.edu>
 *          Florian G. Pflug <fgp@phlo.org>
 *          Jon Lech Johansen <jon-vl@nanocrew.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

/*****************************************************************************
 * Preamble
 *****************************************************************************/
#include <stdlib.h>                                      /* malloc(), free() */
#include <string.h>

#include <vlc/vlc.h>

/*****************************************************************************
 * External prototypes
 *****************************************************************************/
int  E_(OpenIntf)     ( vlc_object_t * );
void E_(CloseIntf)    ( vlc_object_t * );

int  E_(OpenVideoQT)  ( vlc_object_t * );
void E_(CloseVideoQT) ( vlc_object_t * );

int  E_(OpenVideoGL)  ( vlc_object_t * );
void E_(CloseVideoGL) ( vlc_object_t * );

/*****************************************************************************
 * Module descriptor
 *****************************************************************************/
#define EMBEDDED_TEXT N_("Embedded video output")
#define EMBEDDED_LONGTEXT N_( "Display the video in the controller window instead of a in separate window.")

#define VDEV_TEXT N_("Video device")
#define VDEV_LONGTEXT N_("Number of the screen to use by default to display " \
                         "videos in 'fullscreen'. The screen number correspondance can be found in "\
                         "the video device selection menu.")

#define OPAQUENESS_TEXT N_("Opaqueness")
#define OPAQUENESS_LONGTEXT N_( "Set the transparency of the video output. 1 is non-transparent (default) " \
                                "0 is fully transparent.")

#define STRETCH_TEXT N_("Stretch video to fill window")
#define STRETCH_LONGTEXT N_("Stretch the video to fill the entire window when "\
                            "resizing the video instead of keeping the aspect ratio and "\
                            "displaying black borders.")

#define BLACK_TEXT N_("Black screens in fullscreen")
#define BLACK_LONGTEXT N_("In fullscreen mode, keep screen where there is no " \
                          "video displayed black" )

#define BACKGROUND_TEXT N_("Use as Desktop Background")
#define BACKGROUND_LONGTEXT N_("Use the video as the Desktop Background " \
                               "Desktop icons cannot be interacted with in this mode." )

#define FSPANEL_TEXT N_("Show Fullscreen controller")
#define FSPANEL_LONGTEXT N_("Shows a lucent controller when moving the mouse " \
                            "in fullscreen mode.")

#define AUTOPLAY_OSX_TEST N_("Auto-playback of new items")
#define AUTOPLAY_OSX_LONGTEXT N_("Start playback of new items immediately " \
                                 "once they were added." )

#define RECENT_ITEMS_TEXT N_("Keep Recent Items")
#define RECENT_ITEMS_LONGTEXT N_("By default, VLC keeps a list of the last 10 items. " \
                                 "This feature can be disabled here.")

#define EQ_KEEP_TEXT N_("Keep current Equalizer settings")
#define EQ_KEEP_LONGTEXT N_("By default, VLC keeps the last equalizer settings before " \
                            "termination. This feature can be disabled here.")

vlc_module_begin();
    set_description( _("Mac OS X interface") );
    set_capability( "interface", 100 );
    set_callbacks( E_(OpenIntf), E_(CloseIntf) );
    set_category( CAT_INTERFACE );
    set_subcategory( SUBCAT_INTERFACE_MAIN );
    add_bool( "macosx-embedded", 1, NULL, EMBEDDED_TEXT, EMBEDDED_LONGTEXT,
              VLC_FALSE );
    add_bool( "macosx-autoplay", 1, NULL, AUTOPLAY_OSX_TEST, AUTOPLAY_OSX_LONGTEXT,
              VLC_FALSE );
    add_bool( "macosx-recentitems", 1, NULL, RECENT_ITEMS_TEXT, RECENT_ITEMS_LONGTEXT,
              VLC_FALSE );
    add_bool( "macosx-eq-keep", 1, NULL, EQ_KEEP_TEXT, EQ_KEEP_LONGTEXT,
              VLC_FALSE );
    add_bool( "macosx-fspanel", 1, NULL, FSPANEL_TEXT, FSPANEL_LONGTEXT,
              VLC_FALSE );

    add_submodule();
        set_description( _("Quartz video") );
        set_capability( "video output", 100 );
        set_category( CAT_VIDEO);
        set_subcategory( SUBCAT_VIDEO_VOUT );
        set_callbacks( E_(OpenVideoQT), E_(CloseVideoQT) );

        add_integer( "macosx-vdev", 0, NULL, VDEV_TEXT, VDEV_LONGTEXT,
                     VLC_FALSE );
        add_bool( "macosx-stretch", 0, NULL, STRETCH_TEXT, STRETCH_LONGTEXT,
                  VLC_FALSE );
        add_float_with_range( "macosx-opaqueness", 1, 0, 1, NULL,
                              OPAQUENESS_TEXT, OPAQUENESS_LONGTEXT, VLC_TRUE );
        add_bool( "macosx-black", 1, NULL, BLACK_TEXT, BLACK_LONGTEXT,
                  VLC_FALSE );
        add_bool( "macosx-background", 0, NULL, BACKGROUND_TEXT, BACKGROUND_LONGTEXT,
                  VLC_FALSE );
    add_submodule();
        set_description( "Mac OS X OpenGL" );
        set_capability( "opengl provider", 100 );
        set_category( CAT_VIDEO);
        set_subcategory( SUBCAT_VIDEO_VOUT );
        set_callbacks( E_(OpenVideoGL), E_(CloseVideoGL) );
vlc_module_end();

