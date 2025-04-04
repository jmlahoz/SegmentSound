# Segment sound
# José María Lahoz-Bengoechea (jmlahoz@ucm.es)
# Version 2025-04-01

# LICENSE
# (C) 2025 José María Lahoz-Bengoechea
# This file is part of the plugin_SegmentSound.
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation
# either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more details, you can find the GNU General Public License here:
# http://www.gnu.org/licenses/gpl-3.0.en.html
# This file runs on Praat, a software developed by Paul Boersma
# and David Weenink at University of Amsterdam.

# This script takes a Sound and a TextGrid with one single tier named ortho
# and creates phones, syll, and words tiers properly aligned to the sound.
# This is currently optimized for Spanish.

include auxiliary.praat

##{ Get selected objects and apply native alignment
nso = numberOfSelected ("Sound")
ntg = numberOfSelected ("TextGrid")
if nso!=1 or ntg!=1
exit Select one Sound and one TextGrid
endif

so = selected ("Sound")
tg = selected ("TextGrid")
name$ = selected$ ("TextGrid")
View & Edit
select tg
ntier = Get number of tiers
tier$ = Get tier name... 1
if ntier != 1 or tier$ != "ortho"
exit The TextGrid must consist of one single tier named ortho
endif
nint = Get number of intervals... 1
for int from 1 to nint
lab$ = Get label of interval... 1 int
if lab$ = "-" or lab$ = "_" or lab$ = " "
Set interval text... 1 int 
endif
ini = Get start time of interval... 1 int
editor TextGrid 'name$'
Move cursor to... ini
if int = 1
if praatVersion >= 6036
Alignment settings: "Spanish (Spain)", "yes", "yes", "yes"
else
Alignment settings: "Spanish", "yes", "yes", "yes"
endif
endif
Align interval
if int = nint
Close
endif
endeditor
endfor
##}

##{ Adapt tier names and order to EasyAlign output
call findtierbyname "orthophon" 1 1
phonesTID = findtierbyname.return
Duplicate tier... 'phonesTID' 1 phones
call findtierbyname "orthophon" 1 1
phonesTID = findtierbyname.return
Remove tier... 'phonesTID'

call findtierbyname "orthoword" 1 1
wordTID = findtierbyname.return
Duplicate tier... 'wordTID' 2 words
call findtierbyname "orthoword" 1 1
wordTID = findtierbyname.return
Remove tier... 'wordTID'

call findtierbyname "phones" 1 1
phonesTID = findtierbyname.return
call findtierbyname "words" 1 1
wordsTID = findtierbyname.return
##}

##{ Adapt native aligner output to SAMPA
Replace interval text... phonesTID 0 0 tʃ tS Literals
Replace interval text... phonesTID 0 0 θ T Literals
Replace interval text... phonesTID 0 0 β B Literals
Replace interval text... phonesTID 0 0 ð D Literals
Replace interval text... phonesTID 0 0 ɣ G Literals
Replace interval text... phonesTID 0 0 b B Literals
Replace interval text... phonesTID 0 0 d D Literals
Replace interval text... phonesTID 0 0 ɡ G Literals
Replace interval text... phonesTID 0 0 ʎ jj Literals
Replace interval text... phonesTID 0 0 ɲ J Literals
Replace interval text... phonesTID 0 0 ŋ n Literals
Replace interval text... phonesTID 0 0 ɾ 4 Literals
Replace interval text... phonesTID 0 0 ɛ e Literals
Replace interval text... phonesTID 0 0 ɔ o Literals
Replace interval text... phonesTID 0 0 ɪ j Literals
Replace interval text... phonesTID 0 0 ʊ w Literals
##}

##{ Adapt native aligner output to Spanish phonotactics

##{ Properly interpret güe, güi as /Gwe, Gwi/
nword = Get number of intervals... 'wordsTID'
for iword from 1 to nword
word$ = Get label of interval... 'wordsTID' iword
if index(word$,"ü") != 0
ini = Get start time of interval... 'wordsTID' iword
end = Get end time of interval... 'wordsTID' iword
pho1 = Get high interval at time... 'phonesTID' ini
pho2 = Get low interval at time... 'phonesTID' end
for ipho from pho1 to pho2
pho$ = Get label of interval... 'phonesTID' ipho
if pho$ = "u"
prevpho$ = Get label of interval... 'phonesTID' ipho-1
nextpho$ = Get label of interval... 'phonesTID' ipho+1
if prevpho$ = "G" and (nextpho$ = "e" or nextpho$ = "i")
Set interval text... 'phonesTID' ipho w
endif
endif
endfor ; from pho1 to pho2
endif
endfor ; to nword
##}

##{ Diphthongs and triphthongs
nint = Get number of intervals... 'phonesTID'
for int from 1 to nint
lab$ = Get label of interval... 'phonesTID' int
if lab$ = "aw" or lab$ = "ew" or lab$ = "ow" or lab$ = "aj" or lab$ = "ej" or lab$ = "oj"
# Bisegmental, not monosegmental diphthongs
nucleus$ = left$(lab$,1)
paravowel$ = right$(lab$,1)
ini = Get start time of interval... 'phonesTID' int
end = Get end time of interval... 'phonesTID' int
mid = (ini+end)/2
Insert boundary... 'phonesTID' mid
Set interval text... 'phonesTID' int 'nucleus$'
if paravowel$ = "j"
Set interval text... 'phonesTID' int+1 j
elsif paravowel$ = "w"
Set interval text... 'phonesTID' int+1 w
endif
int = int+1
nint = nint+1
elsif lab$ = "i" or lab$ = "u"
ini = Get start time of interval... 'phonesTID' int
iword = Get interval at time... 'wordsTID' ini
word$ = Get label of interval... 'wordsTID' iword
prev1lab$ = "#"
prev2lab$ = "#"
if int > 2
prev1lab$ = Get label of interval... 'phonesTID' int-1
prev2lab$ = Get label of interval... 'phonesTID' int-2
if prev1lab$ = ""
prev1lab$ = "_"
endif
if prev2lab$ = ""
prev2lab$ = "_"
endif
endif
if (index("eao",prev1lab$) != 0 and index("jw",prev2lab$) != 0)
... or (index("eao",prev1lab$) != 0 and index(word$,"í") = 0 and index(word$,"ú") = 0)
# rising + falling sonority forms a triphthong
# ortho éáó + iu forms a diphthong
if lab$ = "i"
Set interval text... 'phonesTID' int j
elsif lab$ = "u"
Set interval text... 'phonesTID' int w
endif
endif
endif
endfor ; to nint
##}

##}

##{ Remove punctuation from words tier
nword = Get number of intervals... 'wordsTID'
for iword from 1 to nword
word$ = Get label of interval... 'wordsTID' iword
if word$ != ""
call removepunct 'word$'
word$ = removepunct.arg$
call removespaces 1 1 1 'word$'
word$ = removespaces.arg$
Set interval text... 'wordsTID' iword 'word$'
endif
endfor ; to nword
##}

##{ Create syll tier
execute Syllabify.praat
call findtierbyname "phones" 1 1
phonesTID = findtierbyname.return
call findtierbyname "syll" 1 1
syllTID = findtierbyname.return
call findtierbyname "words" 1 1
wordsTID = findtierbyname.return
##}

##{ Add stress to IPA transcription

##{ Define vowel inventory
nacvowel$[1] = "i"
nacvowel$[2] = "e"
nacvowel$[3] = "a"
nacvowel$[4] = "o"
nacvowel$[5] = "u"
nacvowel$[6] = "I"
nacvowel$[7] = "E"
nacvowel$[8] = "A"
nacvowel$[9] = "O"
nacvowel$[10] = "U"
acvowel$[1] = "í"
acvowel$[2] = "é"
acvowel$[3] = "á"
acvowel$[4] = "ó"
acvowel$[5] = "ú"
acvowel$[6] = "Í"
acvowel$[7] = "É"
acvowel$[8] = "Á"
acvowel$[9] = "Ó"
acvowel$[10] = "Ú"
##}

# Define instrinsically unstressed words
clitics = Read Table from comma-separated file... clitics.csv
nclit = Get number of rows

select tg
nword = Get number of intervals... 'wordsTID'
for iword from 1 to nword
word$ = Get label of interval... 'wordsTID' iword

# Check if this is an unstressed word
isclitic = 0
for iclit from 1 to nclit
select clitics
iclitmay$ = Get value... iclit nacmay
iclitmin$ = Get value... iclit nacmin
if word$ = iclitmay$ or word$ = iclitmin$
isclitic = 1
iclit = nclit
endif
endfor ; to nclit
select tg

if isclitic = 0
# Get number of syllables in the word
ini = Get start time of interval... 'wordsTID' iword
end = Get end time of interval... 'wordsTID' iword
firstsyll = Get high interval at time... 'syllTID' ini
lastsyll = Get low interval at time... 'syllTID' end
lastsyll2 = Get high interval at time... 'syllTID' end
if lastsyll = lastsyll2
lastsyll = lastsyll - 1 ; this prevents miscalculations in case of resyllabification
endif
nsyll = lastsyll - firstsyll + 1

# Monosyllabic words
if nsyll = 1
stressposition = 1

# Plurisyllabic words
elsif nsyll > 1
ac = 0
vow$ = ""
# Check if word has stress mark
for ivow from 1 to 10
ac = ac + index(word$,acvowel$[ivow])
if ac > 0
vow$ = acvowel$[ivow]
ivow = 10
endif
endfor ; ivow to 10

# Spanish general rule of stress
if ac = 0
if index("aeiouns",right$(word$,1)) != 0
stressposition = 2
else
stressposition = 1
endif

# Get number of syllables from stress mark to word end
elsif ac > 0
stressposition = 1
tmp$ = mid$(word$,ac+1,length(word$)-ac)
if left$(tmp$,1) = "i" or left$(tmp$,1) = "u"
tmp$ = mid$(tmp$,2,length(tmp$)-1)
endif
@getnextvow
while nextvow > 0
if nextvow != 1 or (vow$ = "í" or vow$ = "ú" or vow$ = "Í" or vow$ = "Ú") or ((vow$ = "a" or vow$ = "e" or vow$ = "o") and (nextvow$ = "a" or nextvow$ = "e" or nextvow$ = "o"))
stressposition = stressposition + 1
endif
tmp$ = mid$(tmp$,nextvow+1,length(tmp$)-nextvow)
vow$ = nextvow$
@getnextvow
endwhile

endif ; there is not stress mark, otherwise there is

endif ; monosyllabic words, otherwise plurisyllabic

# Transcribe stress in corresponding syllable
stressedsyll = lastsyll - stressposition + 1
stressedsyll$ = Get label of interval... 'syllTID' stressedsyll
if stressedsyll$ != "" and stressedsyll$ != "_"
stressedsyll$ = "'" + stressedsyll$
endif
Set interval text... 'syllTID' stressedsyll 'stressedsyll$'

endif ; isclitic = 0
endfor ; to nword

select clitics
Remove
select tg
##}

call toipa phones
call toipa syll

select so
plus tg

procedure getnextvow
nextvow = 0
nextvow$ = ""
for ivow from 1 to 10
nextvow = nextvow + index(tmp$,nacvowel$[ivow])
if nextvow > 0
nextvow$ = nacvowel$[ivow]
ivow = 10
endif
endfor ; ivow to 10
endproc
