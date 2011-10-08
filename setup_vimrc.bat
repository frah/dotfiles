@echo off

mklink %USERPROFILE%\_vimrc %~p0.vimrc
mklink /D %USERPROFILE%\.vim %~p0.vim

git submodule update

