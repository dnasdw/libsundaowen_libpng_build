IF DEFINED VS90COMNTOOLS (
  SET GENERATOR="Visual Studio 9 2008 Win64"
) ELSE IF DEFINED VS120COMNTOOLS (
  SET GENERATOR="Visual Studio 12 Win64"
) ELSE IF DEFINED VS110COMNTOOLS (
  SET GENERATOR="Visual Studio 11 Win64"
) ELSE IF DEFINED VS100COMNTOOLS (
  SET GENERATOR="Visual Studio 10 Win64"
)
SET target_lib_suffix=
IF NOT DEFINED GENERATOR (
  ECHO Can not find VC2008 or VC2010 or VC2012 or VC2013 installed!
  GOTO ERROR
)
SET cwdir=%CD%
SET rootdir=%~dp0
SET target=windows_x86_64
SET prefix=%rootdir%%target%
SET /P version=<"%rootdir%version.txt"
RD /S /Q "%rootdir%%version%"
MD "%rootdir%%version%"
XCOPY "%rootdir%..\%version%" "%rootdir%%version%" /S /Y
RD /S /Q "%rootdir%build"
MD "%rootdir%build"
CD /D "%rootdir%build"
cmake -C "%rootdir%CMakeLists-MSVC.txt" -DPNG_SHARED=OFF -DPNG_TESTS=OFF -DZLIB_INCLUDE_DIR="%rootdir%..\zlib\include\%target%" -DZLIB_LIBRARY="%rootdir%..\zlib\lib\%target%%target_lib_suffix%\zlibstatic.lib" -DCMAKE_INSTALL_PREFIX="%prefix%" -G %GENERATOR% "%rootdir%%version%"
cmake "%rootdir%%version%"
cmake --build . --target install --config Release --clean-first
RD /S /Q "%prefix%\include\libpng16"
MD "%rootdir%..\target\include\%target%"
XCOPY "%prefix%\include" "%rootdir%..\target\include\%target%" /S /Y
MD "%rootdir%..\target\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\libpng16_static.lib" "%rootdir%..\target\lib\%target%%target_lib_suffix%"
CD /D "%cwdir%"
RD /S /Q "%rootdir%%version%"
RD /S /Q "%rootdir%build"
RD /S /Q "%prefix%"
GOTO :EOF

:ERROR
PAUSE
