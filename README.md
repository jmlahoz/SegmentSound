LICENSE
(C) 2025 José María Lahoz-Bengoechea.
This file is part of SegmentSound, a bundle of scripts for Praat
(Praat is a software developed by Paul Boersma and David Weenink).
SegmentSound is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License
as published by the Free Software Foundation
either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY, without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
For more details, you can find the GNU General Public License here:
http://www.gnu.org/licenses/gpl-3.0.en.html

Suggested citation:

Lahoz-Bengoechea, José María (2025). SegmentSound for Praat (1.0) [Computer software]. https://github.com/jmlahoz/SegmentSound

------------------------------------------------------------------------------------------
SegmentSound includes a new command for Praat, 
which is installed under the Praat menu. 
It takes a Sound and a TextGrid with one single tier named ortho 
and creates phones, syll, and words tiers properly aligned to the sound. 
This is currently optimized for Spanish. 

SegmentSound is an alternative to EasyAlign that draws from Praat native interval aligner. 
It is not so accurate as EasyAlign but it runs on all operating systems supported by Praat 
(not just Windows, as is the case with EasyAlign).

How to install SegmentSound as a Praat plugin in a permanent fashion:
1. Go to your Praat preferences folder.
   This is always under your user folder, but the location varies depending on your operating system.
   (In each case, change user_name for your actual user name).
   --On Windows, go to C:\Users\user_name\Praat
   --On Mac, go to /Users/user_name/Library/Preferences/Praat Prefs/ (You may need to make invisible folders visible by pressing Command+Shift+Period)
   --On Linux, go to /home/user_name/.praat-dir
2. Create a subfolder named plugin_SegmentSound
   (this is case-sensitive).
3. Copy all the SegmentSound files into that subfolder.
   You are ready to go.
   Next time you open Praat, the SegmentSound command will appear under the Praat menu.
