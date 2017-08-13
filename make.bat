@ECHO OFF

del rockmanforte_msu1.sfc

rem copy rockmanforte_original.sfc rockmanforte_msu1.sfc
copy rockmanforte_english.sfc rockmanforte_msu1.sfc

bass -o rockmanforte_msu1.sfc rockmanforte_msu1.asm
