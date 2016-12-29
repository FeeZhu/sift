for /f "delims= " %%a in ('dir /s/b/p/w *.tif') do (
(echo %%~a
echo 4)>>train_list.txt
)
pause