@echo off
set MAPROOT="../../_maps/"
set TGM=1
py mapmerger.py %1 %MAPROOT% %TGM%
pause