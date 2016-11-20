IF DEFINED VS140COMNTOOLS (
  SET GENERATOR="Visual Studio 14 Win64"
  SET target_lib_suffix=_msvc14
)
IF NOT DEFINED GENERATOR (
  ECHO Can not find VC2015 installed!
  GOTO ERROR
)
SET rootdir=%~dp0
SET cwdir=%CD%
SET target=windows_x86_64
SET prefix=%rootdir%%target%
SET /P version=<"%rootdir%version.txt"
RD /S /Q "%rootdir%%version%"
MD "%rootdir%%version%"
XCOPY "%rootdir%..\%version%" "%rootdir%%version%" /S /Y
RD /S /Q "%rootdir%project"
MD "%rootdir%project"
CD /D "%rootdir%project"
cmake -C "%rootdir%CMakeLists.txt" -DPNG_SHARED=OFF -DPNG_TESTS=OFF -DZLIB_INCLUDE_DIR="%rootdir%..\zlib\include\%target%" -DZLIB_LIBRARY="%rootdir%..\zlib\lib\%target%%target_lib_suffix%\zlibstatic.lib" -DCMAKE_INSTALL_PREFIX="%prefix%" -G %GENERATOR% "%rootdir%%version%"
cmake "%rootdir%%version%"
cmake --build . --target install --config Release --clean-first
RD /S /Q "%prefix%\include\libpng16"
MD "%rootdir%..\target\include\%target%"
XCOPY "%prefix%\include" "%rootdir%..\target\include\%target%" /S /Y
MD "%rootdir%..\target\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\libpng16_static.lib" "%rootdir%..\target\lib\%target%%target_lib_suffix%"
CD /D "%cwdir%"
RD /S /Q "%rootdir%%version%"
RD /S /Q "%rootdir%project"
RD /S /Q "%prefix%"
GOTO :EOF

:ERROR
PAUSE
