#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.
#

!define AppName "Apache Directory Studio"
!define AppVersion "1.1.0 RC2"
!define OutFile "Apache_Directory_Studio_1.1.0_RC2_Windows"
!define ShortName "Apache Directory Studio"
!define JRE_VERSION "1.5.0"
!define Vendor "Apache Software Foundation"
!define Project "Apache Directory"

!define JAVA_URL "http://java.sun.com/javase/downloads/index_jdk5.jsp"

!macro CreateInternetShortcut FILENAME URL ;ICONFILE ICONINDEX
WriteINIStr "${FILENAME}.url" "InternetShortcut" "URL" "${URL}"
!macroend

!include "MUI.nsh"
!include "Sections.nsh"

;--------------------------------
;Configuration

  ;General
  Name "${AppName}"
  OutFile "${OutFile}.exe"

  ;Folder selection page
  InstallDir "$PROGRAMFILES\${AppName}"

  ;Get install folder from registry if available
  InstallDirRegKey HKLM "SOFTWARE\${Vendor}\${ShortName}" ""

; Installation types
;InstType "Studio Only"

BrandingText "${AppName} - ${AppVersion}"
XPStyle on

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "utils\header_studio.bmp"
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_WELCOMEFINISHPAGE_BITMAP "utils\welcome_studio.bmp"
!define iconfile "utils\studio-installer.ico"
!define MUI_ICON "${iconfile}"
!define MUI_UNICON "${iconfile}"

;--------------------------------
;Pages

  ; License page
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "release\LICENSE.txt"

  !define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Installation complete"
  !define MUI_PAGE_HEADER_TEXT "Installing"
  !define MUI_PAGE_HEADER_SUBTEXT "Please wait while ${AppName} is being installed."

  !insertmacro MUI_PAGE_COMPONENTS

  # The main installation directory

  Var STUDIO_HOME_DIR
  !define MUI_DIRECTORYPAGE_VARIABLE          $STUDIO_HOME_DIR  ;selected by user
  !define MUI_DIRECTORYPAGE_TEXT_DESTINATION  "Apache Directory Studio Install Directory"     ;descriptive text
  !define MUI_DIRECTORYPAGE_TEXT_TOP          "This is the location where you would like to install Apache Directory Studio."
  !insertmacro MUI_PAGE_DIRECTORY  ; this pops-up the GUI page

  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

; Uninstall  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES


;--------------------------------
;Modern UI Configuration

  !define MUI_ABORTWARNING

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Language Strings

  ;Description
  LangString DESC_SecServerFiles ${LANG_ENGLISH} "Apache Directory Server Application Files"
  LangString DESC_SecStudioFiles ${LANG_ENGLISH} "Apache Directory Studio Application Files"
  LangString DESC_SecStudioConnections ${LANG_ENGLISH} "Example connections to locally installed server"
  LangString DESC_SecInstanceFiles ${LANG_ENGLISH} "Example server instance"

  ;Header
  LangString TEXT_JRE_TITLE ${LANG_ENGLISH} "Java Runtime Environment"
  LangString TEXT_JRE_SUBTITLE ${LANG_ENGLISH} "Installation"
  LangString TEXT_PRODVER_TITLE ${LANG_ENGLISH} "Installed version of ${AppName}"
  LangString TEXT_PRODVER_SUBTITLE ${LANG_ENGLISH} "Installation cancelled"

;--------------------------------
;Installer Sections


SectionGroup "Apache Directory Studio"
Section "Application Files" SecStudioFiles
  SectionIn 1 3
  SetOutPath "$STUDIO_HOME_DIR"
  File /r "release\*"

  ;Store install folder
  WriteRegStr HKLM "SOFTWARE\${Vendor}\${Project}\Studio" "InstallDir" "$STUDIO_HOME_DIR"

  CreateDirectory "$SMPROGRAMS\Apache Directory Suite\Studio"
  CreateShortCut "$SMPROGRAMS\Apache Directory Suite\Studio\Studio.lnk" "$STUDIO_HOME_DIR\Apache Directory Studio.exe" "" "$STUDIO_HOME_DIR\Apache Directory Studio.exe" 0

  # Probably need to filter the file here (put in instance home)

  ;Store install folder
  WriteRegStr HKLM "SOFTWARE\${Vendor}\${Project}\Studio" "InstallDir" $STUDIO_HOME_DIR
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" "DisplayName" "${AppName} - (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" "DisplayIcon" "$STUDIO_HOME_DIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" "UninstallString" '"$STUDIO_HOME_DIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" "NoModify" "1"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" "NoRepair" "1"

  ;Create uninstaller
  WriteUninstaller "$STUDIO_HOME_DIR\Uninstall.exe"

  CreateDirectory "$SMPROGRAMS\Apache Directory Suite\Studio"

  CreateShortCut "$SMPROGRAMS\Apache Directory Suite\Studio\Uninstall.lnk" "$STUDIO_HOME_DIR\uninstall.exe" "" "$STUDIO_HOME_DIR\uninstall.exe" 0


SectionEnd
Section "Example Connections" SecStudioConnections
  SectionIn 1 3

  IfFileExists "$PROFILE\.ApacheDirectoryStudio\.metadata\.plugins\org.apache.directory.studio.ldapbrowser.core\browserconnections.xml" End 0
  SetOutPath "$PROFILE\.ApacheDirectoryStudio\.metadata\.plugins\org.apache.directory.studio.ldapbrowser.core"
  File "utils\browserconnections.xml"

  IfFileExists "$PROFILE\.ApacheDirectoryStudio\.metadata\.plugins\org.apache.directory.studio.connection.core\connections.xml" End 0
  SetOutPath "$PROFILE\.ApacheDirectoryStudio\.metadata\.plugins\org.apache.directory.studio.connection.core"
  File "utils\connections.xml"
End:

SectionEnd
SectionGroupEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStudioFiles} $(DESC_SecStudioFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecStudioConnections} $(DESC_SecStudioConnections)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;---------------------------------
; Functions

;--------------------------------
;Installer Functions

Function .onInit
    SetCurInstType 0
    SetAutoClose false
    StrCpy $STUDIO_HOME_DIR "$PROGRAMFILES\Apache Directory Studio"

    ;Verifying if Studio is already installed
    ReadRegStr $R0 HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio" \
    "UninstallString"
    StrCmp $R0 "" done

    ;Studio is already installed
    ;Asking before running the uninstaller
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
    "${AppName} is already installed. $\n$\nClick 'OK' to remove the \
    previous version $\nor 'Cancel' to cancel this installation." \
    IDOK uninst
    Abort
  
    ;Running the uninstaller
    uninst:
        ClearErrors
        ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
 
        IfErrors no_remove_uninstaller
        ;You can either use Delete /REBOOTOK in the uninstaller or add some code
        ;here to remove the uninstaller. Use a registry key to check
        ;whether the user has chosen to uninstall. If you are using an uninstaller
        ;components page, make sure all sections are uninstalled.
        no_remove_uninstaller:
  
    done:
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  ReadRegStr $STUDIO_HOME_DIR HKLM "SOFTWARE\${Vendor}\${Project}\Studio" "InstallDir"

  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Project} Studio"
  DeleteRegKey HKLM  "SOFTWARE\${Vendor}\${Project}\Studio"

  ; remove shortcuts, if any.
  RMDir /r "$SMPROGRAMS\Apache Directory Suite\Studio"

  ; remove files in root, then all dirs created by the installer.... leave user added or instance dirs.
  RMDir /r "$STUDIO_HOME_DIR"  ;Studio install dir

SectionEnd

