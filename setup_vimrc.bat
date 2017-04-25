@echo off

copy /B /D %~p0.vimrc %USERPROFILE%\_vimrc
copy /B /D %~p0_gvimrc %USERPROFILE%\_gvimrc
xcopy /S /I /D %~p0.vim %USERPROFILE%\.vim
