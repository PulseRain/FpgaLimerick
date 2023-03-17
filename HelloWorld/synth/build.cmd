::################################################################################################
::## Copyright (C) 2023 PulseRain Technology, LLC
::##
::## Please see the LICENCE file distributed with this work for additional
::## information regarding copyright ownership.
::##
::## Licensed under the Apache License, Version 2.0 (the "License");
::## you may not use this file except in compliance with the License.
::## You may obtain a copy of the License at
::##
::## https:##www.apache.org/licenses/LICENSE-2.0
::##
::## Unless required by applicable law or agreed to in writing, software
::## distributed under the License is distributed on an "AS IS" BASIS,
::## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::##
::## Please see the License for the specific language governing permissions and
::## limitations under the License.
::################################################################################################

@set prj_name=HelloWorld_ArtyA7_100T

cd .. && call sbt "runMain com.pulserain.fpga.NcoCounter 100000000 3"

echo on

cd synth && call vivado -mode batch -source build.tcl -tclargs %prj_name%


@type %prj_name%\%prj_name%.runs\impl_1\*timing_summary_routed.rpt 2>&1 | findstr /C:"All user specified timing constraints are met" >NUL 2>&1
@if %ERRORLEVEL% equ 0 (
  echo:
  echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
  echo ^=^=^=^> Timing Passed!
  echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
) else (
  echo:
  echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
  echo ^=^=^=^> Timing Failed!
  echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
)

