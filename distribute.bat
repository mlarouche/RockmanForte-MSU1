@ECHO OFF

del /q RockmanForte_MSU1.zip
del /q RockmanForte_MSU1_Music.7z

mkdir RockmanForte_MSU1
ucon64 -q --snes --chk rockmanforte_msu1.sfc
ucon64 -q --mki=rockmanforte_original.sfc rockmanforte_msu1.sfc

copy rockmanforte_msu1.ips RockmanForte_MSU1
copy README.txt RockmanForte_MSU1
copy rockmanforte_msu1.msu RockmanForte_MSU1
copy rockmanforte_msu1.xml RockmanForte_MSU1
copy manifest.bml RockmanForte_MSU1

"C:\Program Files\7-Zip\7z" a -r RockmanForte_MSU1.zip RockmanForte_MSU1

"C:\Program Files\7-Zip\7z" a RockmanForte_MSU1_MSU1_Music.7z *.pcm

del /q rockmanforte_msu1.ips
rmdir /s /q RockmanForte_MSU1_MSU1
