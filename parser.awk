#!/bin/gawk -f 
#
# Molcas/Slapaf data extractor V0.2
#
# @2012 Angel Alvarez <angel at uah dot es>, Felipe Zapata 
# 
#
# MolcaS(tm) Slapaf module prints internal coordinates of the molecule, this  code scans for them and generates a dialog(1)
# driven script to allow the user select individual geometry parts consisting in bonds, angles, dihedrals
# and outofplane components.
# 
# Dialog script must be ran separately and renders a dialog.out file with choosen info consisting on 
# double quoted geometry components, in the form "<tag> <type> <Atom> <Atom> ..."
# All extracted geometry components are in commented form in the generated dialog script source.
#   
#

############# Main Patterns ##################

# dialog building blocks
function shebang()                    { print "#!/bin/sh\n# slapaf selector dialog V 0.2\n"}
function dialog_checklist_start()     { print "\ndialog --backtitle 'ResMol Tools 2012' --title 'Slapaf: Coordenadas Internas' --checklist 'Marca los elementos' 0 0 20 \\" }
function dialog_checklist_items()     { for (a=0; a < length(lin); a++ ) printf "'%s' '' OFF ", lin[a]}
function dialog_checklist_end()       { print " 2> dialog.out\n# end ...\n" }
function dialog_msgbox()              { print "\ndialog --backtitle 'ResMol Tools 2012' --title 'Slapaf: Coordenadas Internas' --msgbox 'no se han encontrado coordenadas internas' 0 0 "}
function debug_items()                { for (a=0; a < length(lin); a++ ) printf "#%s\n", lin[a]}
function dialog_checklist()           { debug_items() ; dialog_checklist_start(); dialog_checklist_items() ; dialog_checklist_end() }
function process()                    { length(lin) > 0 ? dialog_checklist() : dialog_msgbox() }

############# Main Patterns ##################

# Initialisation, Flag marks slapaf section start/finish, idx accounts for components seen so far
BEGIN { Flag=0 ; idx=0 }
# Slapaf Coord Info ahead, check flag to indicate patterns can start looking for geom info
/Primitive Internal Coordinates:/ { Flag=1; next}
# Slapf finished , uncheck flag so patterns get a rest 
/Internal Coordinates:/           { Flag=0 ; next}

# Look for bonds, angle, dihedrals et al, ONLY while we are on a slapaf section (see flag)
Flag==1 ? /^[[:alpha:]][[:digit:]]+ = Bond [[:alnum:]]+ [[:alnum:]]+/ :  noop                                { lin[idx] = $1" "$3" "$4" "$5; idx++ ; next}
Flag==1 ? /^[[:alpha:]][[:digit:]]+ = Angle [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+/ :  noop                  { lin[idx] = $1" "$3" "$4" "$5" "$6 ; idx++ ; next }
Flag==1 ? /^[[:alpha:]][[:digit:]]+ = Dihedral [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+/ :  noop  { lin[idx] = $1" "$3" "$4" "$5" "$6" "$7 ; idx++ ;  next }
Flag==1 ? /^[[:alpha:]][[:digit:]]+ = Outofp   [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+/ :  noop  { lin[idx] = $1" "$3" "$4" "$5" "$6" "$7 ; idx++ ; next }

# Thats all folks, print required script parts and we are off
END  { shebang(); process() }

