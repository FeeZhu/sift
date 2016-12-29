for /f "delims= " %%a in ('dir /s/b/p/w *.tif') do (
(echo %%~a
echo 6)>>train_list.txt
)
pause