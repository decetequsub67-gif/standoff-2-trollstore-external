@echo off
echo Cleaning up Zone.Identifier trash files...
powershell -Command "Get-ChildItem -Path . -Recurse -Include '*Zone*', '*Identifier*' -Exclude 'delete_junk.bat' -ErrorAction SilentlyContinue | Remove-Item -Force"
echo Done!
pause
