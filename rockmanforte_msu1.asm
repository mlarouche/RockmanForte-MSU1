arch snes.cpu

// MSU memory map I/O
constant MSU_STATUS($002000)
constant MSU_ID($002002)
constant MSU_AUDIO_TRACK_LO($002004)
constant MSU_AUDIO_TRACK_HI($002005)
constant MSU_AUDIO_VOLUME($002006)
constant MSU_AUDIO_CONTROL($002007)

// SPC communication ports
constant SPC_COMM_0($002140)

// MSU_STATUS possible values
constant MSU_STATUS_TRACK_MISSING($8)
constant MSU_STATUS_AUDIO_PLAYING(%00010000)
constant MSU_STATUS_AUDIO_REPEAT(%00100000)
constant MSU_STATUS_AUDIO_BUSY($40)
constant MSU_STATUS_DATA_BUSY(%10000000)

// Constants
constant FULL_VOLUME($FF)
constant DUCKED_VOLUME($60)
//constant FADE_DELTA(2)

// Variables
variable fadeState($7E0180)
variable fadeVolume($7E0181)
variable fadeDelta($7E0182)

// FADE_STATE possibles values
constant FADE_STATE_IDLE($00)
constant FADE_STATE_FADEOUT($01)
constant FADE_STATE_FADEIN($02)

// ==========
// = Macros =
// ==========
// seek converts SNES HiROM address to physical address
macro seek(variable offset) {
    origin (offset & $3FFFFF)
    base offset
}

macro CheckMSUPresence(labelToJump) {
    lda MSU_ID
    cmp.b #'S'
    bne {labelToJump}
}

// ===============
// = Code Hijack =
// ===============

// * NMI
seek($C0FFA8)
    jml MSU_VBlankUpdate
    
// * Play Music
seek($C00532)
    jsr MSU_Main

seek($C01A76)
    jsr MSU_Main

seek($C03B6E)
    jsr MSU_Main

seek($C040D2)
    jsr MSU_Main

seek($C04A4E)
    jsr MSU_Main

seek($C05A6D)
    jsr MSU_Main

seek($C05D45)
    jsr MSU_Main

seek($C05F13)
    jsr MSU_Main

seek($C0606B)
    jsr MSU_Main

seek($C0626B)
    jsr MSU_Main

seek($C06736)
    jsr MSU_Main

seek($C067A0)
    jsr MSU_Main

// * Play SFX
seek($C04B28)
    jsr MSU_SoundEffectsAndCommand

// ==============
// = MSU-1 Code =
// ==============
seek($C07970)
scope MSU_Main: {
    php
    // Backup A and Y in 16-bit mode
    rep #$30
    pha
    phy

    // Set all registers to 8-bit mode
    sep #$30
    tay

    // Check if MSU-1 is present
    CheckMSUPresence(MSUNotFound)

    // Check if the game to mute the music track
    lda $1fe0
    bne MSUNotFound

    // Set track
    tya
    sec
    sbc.b #$11
    tay
    sta MSU_AUDIO_TRACK_LO
    lda.b #$00
    sta MSU_AUDIO_TRACK_HI

CheckAudioStatus:
    lda MSU_STATUS

    and.b #MSU_STATUS_AUDIO_BUSY
    bne CheckAudioStatus

    // Check if track is missing
    lda MSU_STATUS
    and.b #MSU_STATUS_TRACK_MISSING
    bne TrackIsMissing

    // Play the song and add repeat if needed
    jsr TrackNeedLooping
    sta MSU_AUDIO_CONTROL

    // Set volume
    lda.b #FULL_VOLUME
    sta MSU_AUDIO_VOLUME

    // Reset the fade state machine
    lda.b #$00
    sta fadeState

    // Exit
    rep #$30
    ply
    pla
    plp
    rts

TrackIsMissing:
    lda #$00
    sta MSU_AUDIO_CONTROL

MSUNotFound:
    rep #$30
    ply
    pla
    plp

    // Original code
    jsr $4a54
    
    rts
}

scope TrackNeedLooping: {
    // Capcom Logo
    cpy.b #00
    beq NoLooping
    // Title Screen
    cpy.b #01
    beq NoLooping
    // Stage Selected Jingle
    cpy.b #06
    beq NoLooping
    // King Castle Intro
    cpy.b #19
    beq NoLooping
    // Victory / Boss Defeated
    cpy.b #21
    beq NoLooping
    // Credits
    cpy.b #25
    beq NoLooping

    // Track is Looping
    lda.b #$03
    rts

NoLooping:
    lda.b #$01
    rts
}

scope MSU_SoundEffectsAndCommand: {
    php

    sep #$20
    pha

    CheckMSUPresence(MSUNotFound)

    pla
    // $F2 is a command to stop music immediately
    cmp.b #$F2
    beq .StopMusic
    // $F5 is a command to resume music
    //cmp.b #$F5
    //beq .ResumeMusic
    // $F6 is a command to fade-out music
    cmp.b #$F6
    beq .FadeOutMusic
    // If not, play the sound as the game excepts to
    bra .PlaySound

//.ResumeMusic:
//    // Stop the SPC music if any
//    lda.b #$F6
//    sta SPC_COMM_0
//
//    // Resume music then fade-in to full volume
//    lda.b #$03
//    sta MSU_AUDIO_CONTROL
//    lda.b #FADE_STATE_FADEIN
//    sta fadeState
//    lda.b #$00
//    sta fadeVolume
//    bra .CleanupAndReturn

.FadeOutMusic:
    sta SPC_COMM_0

    lda MSU_STATUS
    and.b #MSU_STATUS_AUDIO_PLAYING
    beq .CleanupAndReturn

    // Fade-out current music then stop it
    lda.b #FADE_STATE_FADEOUT
    sta fadeState
    lda.b #FULL_VOLUME
    sta fadeVolume
    tya
    sta fadeDelta
    bra .CleanupAndReturn

.StopMusic:
    sta SPC_COMM_0

    lda #$00
    sta MSU_AUDIO_CONTROL
    bra .CleanupAndReturn

MSUNotFound:
    pla
.PlaySound:
    sta SPC_COMM_0
.CleanupAndReturn:
    plp
    rts
}

scope MSU_VBlankUpdate: {
    php
    sep #$20
    pha

    CheckMSUPresence(OriginalCode)

    // Switch on fade state
    lda fadeState
    cmp.b #FADE_STATE_IDLE
    beq OriginalCode
    cmp.b #FADE_STATE_FADEOUT
    beq .FadeOutUpdate
    //cmp.b #FADE_STATE_FADEIN
    //beq .FadeInUpdate
    bra OriginalCode

.FadeOutUpdate:
    lda fadeVolume
    sec
    sbc fadeDelta
    bcs +
    lda.b #$00
+;
    sta fadeVolume
    sta MSU_AUDIO_VOLUME
    beq .FadeOutCompleted
    bra OriginalCode

//.FadeInUpdate:
//    lda fadeVolume
//    clc
//    adc.b #FADE_DELTA
//    bcc +
//    lda.b #FULL_VOLUME
//+;
//    sta fadeVolume
//    sta MSU_AUDIO_VOLUME
//    cmp.b #FULL_VOLUME
//    beq .SetToIdle
//    bra OriginalCode

.FadeOutCompleted:
    lda.b #$00
    sta MSU_AUDIO_CONTROL
.SetToIdle:
    lda.b #FADE_STATE_IDLE
    sta fadeState

OriginalCode:
    pla
    plp
    jml $C0010F
}