; ==============================================================================
; Project: Media Utility & Wallpaper Setter (FASM)
; Description: Downloads an image and an audio file from web sources, sets the 
;              downloaded image as the desktop wallpaper, and opens both files.
; Author: GitHub Repository Contributor
; ==============================================================================

format PE GUI 4.0
entry start

include 'win32a.inc'

section '.data' data readable writeable
    ; URLs and local paths for the image
    img_url     db 'https://pbs.twimg.com/media/FGH_shaXwAQOUid.png',0
    img_path    db 'images.png',0
    
    ; URLs and local paths for the audio file
    aud_url     db 'https://archive.org/download/gs_mac-demarco-salad-days/1-01%20Salad%20Days.mp3',0
    aud_path    db 'audio.mp3',0
    
    ; Execution commands using Windows Explorer wrapper
    cmd_image   db 'explorer.exe images.png',0
    cmd_audio   db 'explorer.exe audio.mp3',0

section '.code' readable executable
start:
    ; 1. Download the image file
    push 0
    push 0
    push img_path
    push img_url
    push 0
    call [URLDownloadToFileA]

    ; 2. Download the audio file
    push 0
    push 0
    push aud_path
    push aud_url
    push 0
    call [URLDownloadToFileA]

    ; 3. Set the downloaded image as the desktop wallpaper
    ; SystemParametersInfoA(SPI_SETDESKWALLPAPER, 0, filePath, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE)
    push 3          ; SPIF_UPDATEINIFILE (1) | SPIF_SENDCHANGE (2) = 3
    push img_path   ; Path to the image file
    push 0          ; Reserved
    push 20         ; SPI_SETDESKWALLPAPER
    call [SystemParametersInfoA]

    ; 4. Open the image file via explorer
    push 1          ; SW_SHOW
    push cmd_image  ; Command string for image
    call [WinExec]

    ; 5. Open the audio file via explorer
    push 1          ; SW_SHOW
    push cmd_audio  ; Command string for audio
    call [WinExec]

inf_loop:
    push 1000
    call [Sleep]
    jmp inf_loop

section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL', \
            urlmon,   'URLMON.DLL', \
            user32,   'USER32.DLL'

    import kernel32, Sleep, 'Sleep', \
                     WinExec, 'WinExec'
                     
    import urlmon,   URLDownloadToFileA, 'URLDownloadToFileA'
    
    import user32,   SystemParametersInfoA, 'SystemParametersInfoA'
