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

@set prj_name=JtagDDR

echo on

call vivado -mode batch -source gen.tcl -tclargs %prj_name%


