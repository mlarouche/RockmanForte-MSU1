@ECHO OFF

del rockmanforte_msu1.sfc

copy rockmanforte_original.sfc rockmanforte_msu1.sfc
copy rockmanforte_english.sfc rockmanforte_msu1_english.sfc

bass -o rockmanforte_msu1.sfc rockmanforte_msu1.asm
bass -o rockmanforte_msu1_english.sfc rockmanforte_msu1.asm
