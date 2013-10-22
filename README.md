Slapaf Extractor

MolcaS(tm) Slapaf module prints internal coordinates of the molecule, this  code scans for them and generates a dialog(1)
driven script to allow the user select individual geometry parts consisting in bonds, angles, dihedrals
and outofplane components.
 
Dialog script must be ran separately and renders a dialog.out file with choosen info consisting on
double quoted geometry components, in the form "<tag> <type> <Atom> <Atom> ..."
All extracted geometry components are in commented form in the generated dialog script source.
