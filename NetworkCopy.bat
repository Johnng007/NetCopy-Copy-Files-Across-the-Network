:: ==================================================================================
:: NAME     : Copy Files Across The Network.
:: AUTHOR   : Ebuka John Onyejegbu.
:: CONTACT  : onyejegbujohne@gmail.com
:: VERSION  : 1.0.
:: ==================================================================================


:: Screen settings.
:: /************************************************************************************/
:mode

echo off
title NetCopy.
color 47

goto permission
:: /************************************************************************************/


:: Print Top Text.
:: /*************************************************************************************/
:print
cls
echo.
echo.NetCopy - Move Files Accross the Network.
echo.
echo.%*
echo.

goto :eof
:: /************************************************************************************/


:: Checking for Administrator elevation.
:: /************************************************************************************/
:permission
openfiles>nul 2>&1
 
if %errorlevel% EQU 0 goto terms
 
call :print Checking for Administrator elevation.

echo.    You are not running as Administrator.
echo.    This batch cannot do it's job without elevation.
echo.
echo.    You must run this tool as Administrator.
echo.
echo.Press any key to continue . . .
pause>nul
goto :eof
:: /************************************************************************************/


:: Terms.
:: /*************************************************************************************/
:terms
call :print Terms and Conditions.

echo.    The methods inside this batch copies files/Folders securely across the network.
echo.    This batch is coded by Ebuka John Onyejegbu.
echo.    onyejegbujohne@gmail.com
echo.
echo.    NOTE: batch files are almost always flagged by anti-virus.
echo.

choice /c YN /n /m "Do you want to continue with this process? (Yes/No) "
if %errorlevel% EQU 1 goto Menu
if %errorlevel% EQU 2 goto Close

echo.
echo.An unexpected error has occurred.
echo.
echo.Press any key to continue . . .
pause>nul
goto :eof
:: /*************************************************************************************/


:: Menu of tool.
:: /*************************************************************************************/
:Menu
call :print Main menu.

echo.     FOLDER SHARING
echo.     1. Copy Folders from This PC To Another.
echo.     2. Copy Folders from a Remote PC to another.
echo      FILE SHARING
echo.     3. Copy Files from This PC To Another.
echo.     4. Copy Files from a Remote PC to another.
echo      MASS COPY
echo      5. Copying Folders from one PC to Many PCs.
echo      PRINTER SHARING
echo      6. Connect a remote PC to a Printer (BETA)
echo.     7. Close.
echo.

set /p option=Select option: 

if %option% EQU 1 (
    call :Copy1
) else if %option% EQU 2 (
    call :Copy2
) else if %option% EQU 3 (
    call :Copy3
)else if %option% EQU 4 (
    call :Copy4	
)else if %option% EQU 5 (
    call :Copy5
)else if %option% EQU 6 (
    call :Copy6
)else if %option% EQU 7 (
    goto Close
) else (
    echo.
    echo.Invalid option.
    echo.
    echo.Press any key to continue . . .
    pause>nul
)

goto Menu
:: /*************************************************************************************/
:: Copying Folders from your PC to another PC.
:: /*************************************************************************************/
:Copy1

call :print Setting up Folder transfer parameters
SETLOCAL EnableDelayedExpansion
SET /P "TerminalName=Enter the IP Address of the PC you wish to copy Folders to: "
ECHO Do you wish to copy Folders to this PC !TerminalName! ?
ECHO NOTE: Folders will be copied to the c:\NETSHARE of this PC
PAUSE
SET /P "FilePath=Enter the path to the Folder you wish to copy e.g C:\CLIENT\OFFICE: "
ECHO Do you wish to copy this Folder: !FilePath! ?
PAUSE

SET "SourcePath=!FilePath!"
SET "TargetPath=\\!TerminalName!\C$\"

IF NOT EXIST "!TargetPath!" (
    call :print Target PC is unreachable, make sure its on network.
    echo.Press any key to continue . . .
    pause>nul
    goto :eof
)

ECHO Target PC has been reached!
ECHO Copying Folders! Here we go...

IF EXIST "%TargetPath%\NETSHARE" (
    ECHO The NETSHARE folder already exists..
) ELSE (
    ECHO No NETSHARE Folder exists... Let's sort that out!
    MKDIR "%TargetPath%\NETSHARE"
    IF ERRORLEVEL 1 (
		call :print Failed to create NETSHARE folder "%TargetPath%\NETSHARE".
        echo.Press any key to continue . . .
        pause>nul
        goto :eof
    )
)
ECHO ECHO Copying files now ...
robocopy "%SourcePath%\*" "%TargetPath%\NETSHARE" /e
call :print The Folder was moved successfully.
echo.Press any key to continue . . .
pause>nul
goto :eof

:: /*************************************************************************************/
:: Copying Folders from a Remote PC to Another Remote PC.
:: /*************************************************************************************/
:Copy2

call :print Setting up Folder transfer parameters
SETLOCAL EnableDelayedExpansion
SET /P "SourceTerminalName=Enter the IP Address of the PC you wish to copy Folders from: "
ECHO Do you wish to copy Folders from this PC: !SourceTerminalName! ?
PAUSE
SET /P "DestinationTerminalName=Enter the IP Address of the PC you wish to copy Folders to: "
ECHO Do you wish to copy Folders to this PC: !DestinationTerminalName! ?
ECHO NOTE: Folders will be Copied to the c:\NETSHARE of this PC
PAUSE
SET /P "SourceFilePath=Enter the path to the Folder on the Source PC you wish to copy e.g Users\Ebuka\Pictures:"
ECHO Do you wish to copy this Folder: !SourceFilePath! ?
PAUSE

SET "SourcePath=\\!SourceTerminalName!\c$\!SourceFilePath!"
SET "TargetPath=\\!DestinationTerminalName!\c$\NETSHARE"

IF NOT EXIST "!TargetPath!" (
    call :print Target PC is unreachable, make sure its on network.
    echo.Press any key to continue . . .
    pause>nul
    goto :eof
)

ECHO Target PC has been reached!
ECHO Copying files! Here we go...

IF EXIST "%TargetPath%\NETSHARE" (
    ECHO The NETSHARE folder already exists..
) ELSE (
    ECHO No NETSHARE Folder exists... Let's sort that out!
    MKDIR "%TargetPath%\NETSHARE"
    IF ERRORLEVEL 1 (
        call :print Failed to create NETSHARE folder "%TargetPath%\NETSHARE".
        echo.Press any key to continue . . .
        pause>nul
        goto :eof
    )
)
ECHO Copying files now ...
robocopy "%SourcePath%\*" "%TargetPath%\NETSHARE\" /e
call :print The Folder was copied successfully.
echo.Press any key to continue . . .
pause>nul
goto :eof

:: /*************************************************************************************/
::                               FILE SHARING
:: /*************************************************************************************/

:: /*************************************************************************************/
:: Copying files from your PC to another PC.
:: /*************************************************************************************/
:Copy3

call :print Setting up file transfer parameters
SETLOCAL EnableDelayedExpansion
SET /P "TerminalName=Enter the IP Address of the PC you wish to copy files to: "
ECHO Do you wish to copy files to this PC !TerminalName! ?
ECHO NOTE: Files will be copied to the c:\NETSHARE of this PC!
PAUSE
SET /P "FilePath=Enter the path to the file you wish to copy e.g C:\CLIENT\JAVA"
ECHO Do you wish to copy a file in this Folder: !FilePath! ?
PAUSE
SET /P "File=Enter the file name you wish to copy e.g java8u28.exe: "
ECHO Do you wish to copy this Folder: !File! ?
PAUSE

SET "SourcePath=!FilePath!"
SET "TargetPath=\\!TerminalName!\C$\"
SET "SourceFile=!File!"

IF NOT EXIST "!TargetPath!" (
    call :print Target PC is unreachable, make sure its on network.
    echo.Press any key to continue . . .
    pause>nul
    goto :eof
)

ECHO Target PC has been reached!
ECHO Copying files! Here we go...

IF EXIST "%TargetPath%\NETSHARE" (
    ECHO The NETSHARE folder already exists..
) ELSE (
    ECHO No NETSHARE Folder exists... Let's sort that out!
    MKDIR "%TargetPath%\NETSHARE"
    IF ERRORLEVEL 1 (
		call :print Failed to create NETSHARE folder "%TargetPath%\NETSHARE".
        echo.Press any key to continue . . .
        pause>nul
        goto :eof
    )
)
ECHO Copying files now ...
robocopy "%SourcePath%\*" "%TargetPath%\NETSHARE" %SourceFile%
call :print The File was copied successfully.
echo.Press any key to continue . . .
pause>nul
goto :eof

:: /*************************************************************************************/
:: Copying Files from a Remote PC to Another Remote PC.
:: /*************************************************************************************/
:Copy4

call :print Setting up file transfer parameters
SETLOCAL EnableDelayedExpansion
SET /P "SourceTerminalName=Enter the network path to the file you wish to copy: e.g \\127.0.0.1\c$\CLIENT"
ECHO Do you wish to copy files from this PC: !SourceTerminalName! ?
PAUSE
SET /P "DestinationTerminalName=Enter the IP Address of the PC you wish to move files to: "
ECHO Do you wish to copy files to this PC: !DestinationTerminalName! ?
ECHO NOTE: Files will be moved to the c:\NETSHARE of this PC
PAUSE
SET /P "SourceFile=Enter the file name you wish to copy e.g java8u28.exe: "
ECHO Do you wish to copy this Folder: !File! ?
PAUSE

SET "SourcePath=!SourceTerminalName!"
SET "TargetPath=\\!DestinationTerminalName!\c$\"
SET "SourceFile=!File!"

IF NOT EXIST "!TargetPath!" (
    call :print Target PC is unreachable, make sure its on network.
    echo.Press any key to continue . . .
    pause>nul
    goto :eof
)

ECHO Target PC has been reached!
ECHO Copying files! Here we go...

IF EXIST "%TargetPath%\NETSHARE" (
    ECHO The NETSHARE folder already exists..
) ELSE (
    ECHO No NETSHARE Folder exists... Let's sort that out!
    MKDIR "%TargetPath%\NETSHARE"
    IF ERRORLEVEL 1 (
        call :print Failed to create NETSHARE folder "%TargetPath%\NETSHARE".
        echo.Press any key to continue . . .
        pause>nul
        goto :eof
    )
)
ECHO Copying files now ...
robocopy "%SourcePath%\*" "%TargetPath%\NETSHARE\" %SourceFile%  
call :print The File was copied successfully.
echo.Press any key to continue . . .
pause>nul
goto :eof

:: /*************************************************************************************/
::                                 MASS COPY
:: /*************************************************************************************/


:: /*************************************************************************************/
:: Copying Folders from one PC to Many PCs.
:: /*************************************************************************************/
:Copy5

call :print Setting up Folder transfer parameters
SETLOCAL EnableDelayedExpansion
SET /P "PCList=Enter the PC List Path e.g \\127.0.0.1\c$\PCList\List.txt: "
ECHO Do you wish to use this list: !PCList! ?
PAUSE
SET /P "DeploymentKit=Enter the Path to the Deployment Folder e.g \\127.0.0.1\c$\UPDATE: "
ECHO Do you wish to deploy this Folder: !DeploymentKit! ?
PAUSE
SET /P "LogPath=Enter the path to where you wish to log successful/failed attempts e.g \\127.0.0.1\c$\LOGS"
ECHO Do you wish to use this path: !LogPath! ?
PAUSE

SET "PCListPath=!PCList!"
SET "DeployKit=!DeploymentKit!"
SET "LogsPath=!LogPath!"


ECHO Copying files now ...

cls
For /F "usebackq tokens=*" %%a in ("%PCListPath%") Do (
   COPY "%DeployKit%" "\\%%a\C$\NETSHARE" /y &&(
          >>%LogsPath%\success.txt echo.%%a
   ) ||(
         >>%LogsPath%\failure.txt echo.%%a
   )
)
pause>nul
goto :eof

:: /*************************************************************************************/
::                                 PRINTER SHARING
:: /*************************************************************************************/

:: /*************************************************************************************/
:: Connect a remote PC to a remote USB Connected Printer (BETA)
:: The Printer should be shared on the PC its connected to
:: /*************************************************************************************/
:Copy6

call :print Setting up printer sharing parameters
SETLOCAL EnableDelayedExpansion
SET /P "SourceTerminalName=Enter the Host printer share path e.g \\10.51.21.45\HOMEPRINTER: "
ECHO We would assume this contains the PC IP address and shared printer Name !SourceTerminalName! ?
PAUSE
SET /P "DestinationTerminalName=Enter the Proposed Destination printer share path e.g \\10.51.22.70\HOMEPRINTER: "
ECHO Do you wish to use this file path !DestinationTerminalName! ?
PAUSE


SET "SourcePath=!SourceTerminalName!"
SET "TargetPath=!DestinationTerminalName!"

REM add the specified printer to the specified computer

@Echo On
rundll32 printui.dll,PrintUIEntry /ga /c%TargetPath% /n%SourcePath%
@Echo off

REM stop the print spooler on the specified computer and wait until the sc command finishes

@Echo On
start /wait sc %TargetPath% stop spooler
@Echo off

REM start the print spooler on the specified computer and wait until the sc command finishes

@Echo On
start /wait sc %TargetPath% start spooler
call :print The Printer installed successfully, Please check Devices & Printers.
echo.Press any key to continue . . .
pause>nul
goto :eof

:: /*************************************************************************************/
:: End tool.
:: /*************************************************************************************/
:close

exit
:: /*************************************************************************************/