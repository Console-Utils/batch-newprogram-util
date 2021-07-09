@echo off
setlocal enableextensions

call :init
set /a "init_error_level=%errorlevel%"
if %init_error_level% gtr 0 exit /b %init_error_level%

call :clear_arguments args

set /a "i=0"
:copy_options
    set "option=%~1"
    if defined option (
        set "args[%i%]=%option%"
        shift
        set /a "i+=1"
        goto copy_options
    )

set /a "i=0"
:main_loop
    set /a "j=%i% + 1"
    call set "option=%%args[%i%]%%"
    call set "value=%%args[%j%]%%"

    set /a "is_help=%false%"
    if "%option%" == "-h" set /a "is_help=%true%"
    if "%option%" == "--help" set /a "is_help=%true%"

    if "%is_help%" == "%true%" (
        call :help
        exit /b %ec_success%
    )

    set /a "is_version=%false%"
    if "%option%" == "-v" set /a "is_version=%true%"
    if "%option%" == "--version" set /a "is_version=%true%"

    if "%is_version%" == "%true%" (
        call :version
        exit /b %ec_success%
    )

    set /a "is_language=%false%"
    if "%option%" == "-l" set /a "is_language=%true%"
    if "%option%" == "--language" set /a "is_language=%true%"

    if "%is_language%" == "%true%" (
        set "language=%value%"
        set /a "i+=2"
        goto main_loop
    )

    set /a "is_path=%false%"
    if "%option%" == "-p" set /a "is_path=%true%"
    if "%option%" == "--path" set /a "is_path=%true%"

    if "%is_path%" == "%true%" (
        set "program_path=%value%"
        set /a "i+=2"
        goto main_loop
    )

    set /a "is_options=%false%"
    if "%option%" == "-o" set /a "is_options=%true%"
    if "%option%" == "--options" set /a "is_options=%true%"

    if "%is_options%" == "%true%" (
        set "options=%value%"
        set /a "i+=2"
        goto main_loop
    )

	if defined option (
		echo %em_wrong_option%
		exit /b %ec_wrong_option%
	)
	
	if defined options set "options_copy=%options: =%"
	if not defined options_copy (
		set "options=%options_copy%"
	)

set /a "is_right_language=%false%"
if "%language%" == "csharp" set /a "is_right_language=%true%"
if "%language%" == "pascal" set /a "is_right_language=%true%"

if "%is_right_language%" == "%false%" (
	echo %em_wrong_language%
	exit /b %ec_wrong_language%
)

echo %program_path%| sed "s/^.*\///" > "%temp_file%"
set /p program_name=<%temp_file%

echo %program_path%| sed -r "s/\/%program_name:.=\.%$//" > "%temp_file%"
set /p program_path=<%temp_file%

if not exist "%program_path%" (
	del "%temp_file%"
	echo %em_wrong_path%
	exit /b %ec_wrong_path%
)

del "%temp_file%"
cd "%program_path%"

set /a "is_right_program_name=%true%"
if "%program_name%" == "%temp_file%" set /a "is_right_program_name=%false%"
if exist "%program_name%" set /a "is_right_program_name=%false%"

if "%is_right_program_name%" == "%false%" (
	echo %em_wrong_program_name%
	exit /b %ec_wrong_program_name%
)

call :new_%language%_program "%program_name%" "%options%"
if exist "%temp_file%" del "%temp_file%"

exit /b %ec_success%

:init
	set "temp_file=tmp.txt"
	
    set /a "ec_success=0"
    set /a "ec_wrong_option=2"
	set /a "ec_wrong_language=2"
	set /a "ec_wrong_path=2"
	set /a "ec_wrong_program_name=2"

    set "em_wrong_option=Specified option is not supported."
	set "em_wrong_language=Specified language name must be one of: csharp, pascal."
	set "em_wrong_path=Specified path doesn't exist."
	set "em_wrong_program_name=Specified program already exists or has invalid ^(%temp_file%^) name."

    set /a "true=0"
    set /a "false=1"

    set "language="
	set "program_path=%CD%"
	set "options="

	set /a "is_wine=%false%"
	if defined WINEDEBUG set /a "is_wine=%true%"
	
	set "gnu_path=C:\Program Files (x86)\GnuWin32\bin"
	set "PATH=%gnu_path%;%PATH%"
exit /b %ec_success%

:help
    echo Simple program generator for C# and PascalABC.NET.
    echo.
    echo Syntax:
    echo    newprogram [options]
    echo.
    echo Options:
    echo    -h^|--help - writes help and exits
    echo    -v^|--version - writes version and exits
    echo    -l^|--language - specifies language name [Available value set is: csharp, pascal.]
    echo    -p^|--path - specifies program path
	echo    -o^|--options - specifies program options with values via space
    echo.
    echo Error codes:
    echo    - 0 - Success
	echo    - 2 - Specified option is not supported.
    echo    - 2 - Specified language name must be one of: csharp, pascal.
	echo    - 2 - Specified path doesn't exist.
	echo    - 2 - Specified program already exists or has invalid (%temp_file%) name.
    echo.
    echo Examples:
    echo    - newprogram --help
    echo    - newprogram --language csharp --path "path/to/program" --options "--help --version"
exit /b %ec_success%

:version
    echo 1.1.1 ^(c^) 2021 year
exit /b %ec_success%

:clear_arguments
    set "ca_array_name=%~1"

    set /a "ca_i=0"
    :ca_clear_arguments_loop
        call set "ca_argument=%%%ca_array_name%[%ca_i%]%%"
        if defined ca_argument (
            set "%ca_array_name%[%ca_i%]="
            set /a "ca_i+=1"
            goto ca_clear_arguments_loop
        )
exit /b %ec_success%

:new_csharp_program
	set "ncp_file_name=%~1"
	set "ncp_options=%~2"
	
	call :generate_csharp_usings "%ncp_file_name%"
	call :generate_csharp_body "%ncp_file_name%" "%ncp_options%"
exit /b %ec_success%

:generate_csharp_usings
	set "gcu_file_name=%~1"
	
	echo using System;> "%gcu_file_name%"
	echo using System.Linq;>> "%gcu_file_name%"
	echo using System.Collections.Generic;>> "%gcu_file_name%"
exit /b %ec_success%

:generate_csharp_body
	set "gcb_file_name=%~1"
	set "gcb_options=%~2"
	
	echo.>> "%gcb_file_name%"
	echo internal class Program>> "%gcb_file_name%"
	echo {>> "%gcb_file_name%"
	echo     public static void Main^(string[] args^)>> "%gcb_file_name%"
	echo     {>> "%gcb_file_name%"
	
	if not defined gcb_options (
		echo     }>> "%gcb_file_name%"
		echo }>> "%gcb_file_name%"
		exit /b %ec_success%
	)
	
	echo         for ^(var i = 0; i ^< args.Length; i++^)>> "%gcb_file_name%"
	echo         {>> "%gcb_file_name%"
	echo             string option = args[i];>> "%gcb_file_name%"
	echo             string value = i + 1 ^< args.Length ? args[i + 1] : string.Empty;>> "%gcb_file_name%"
	echo.>> "%gcb_file_name%"
	echo             switch ^(option^)>> "%gcb_file_name%"
	echo             {>> "%gcb_file_name%"

	for %%s in (%gcb_options%) do (
		echo                 case "%%s": >> "%gcb_file_name%"
		echo %%s| sed -r "s/[[:punct:]]//g; s/(.)(.*)/                    \u\1\2();/" >> "%gcb_file_name%"
		echo                     break;>> "%gcb_file_name%"
	)
	
	echo                 default:>> "%gcb_file_name%"
	echo                     Console.Error.WriteLine^($"Option {option} is unsupported now."^);>> "%gcb_file_name%"
	echo                     break;>> "%gcb_file_name%"
	echo             }>> "%gcb_file_name%"
	echo         }>> "%gcb_file_name%"	
	echo     }>> "%gcb_file_name%"
	echo.>> "%gcb_file_name%"
	
	call :generate_csharp_option_handlers "%gcb_file_name%" %options%
	
	echo }>> "%gcb_file_name%"
exit /b %ec_success%

:generate_csharp_option_handlers
	set "gsoh_file_name=%~1"
	shift
	
	:gsoh_while_option_defined
		set "gsoh_option=%~1"
		set "gsoh_next_option=%~2"
		
		if defined gsoh_option (
			echo %gsoh_option%| sed -r "s/[[:punct:]]//g; s/(.)(.*)/    private static void \u\1\2()/" >> "%gsoh_file_name%"
			echo     {>> "%gsoh_file_name%"
			echo     }>> "%gsoh_file_name%"
		) else (
			exit /b %ec_success%
		)
		
		if defined gsoh_next_option (
			echo.>> "%gsoh_file_name%"
		)
		
		shift
		goto gsoh_while_option_defined
exit /b %ec_success%

:new_pascal_program
	set "npp_file_name=%~1"
	set "npp_options=%~2"
	
	call :generate_pascal_usings "%npp_file_name%"
	call :generate_pascal_body "%npp_file_name%" "%npp_options%"
exit /b %ec_success%

:generate_pascal_usings
	set "gpu_file_name=%~1"
	
	echo uses System;> "%gpu_file_name%"
	echo uses System.Linq;>> "%gpu_file_name%"
	echo uses System.Collections.Generic;>> "%gpu_file_name%"
exit /b %ec_success%

:generate_pascal_body
	set "gpb_file_name=%~1"
	set "gpb_options=%~2"
	
	echo.>> "%gpb_file_name%"
	
	if not defined gpb_options (
		echo begin>> "%gpb_file_name%"
		echo end.>> "%gpb_file_name%"
		exit /b %ec_success%
	)
	
	for %%s in (%gpb_options%) do (
		echo %%s| sed -r "s/[[:punct:]]//g; s/(.)(.*)/procedure \u\1\2();/" >> "%gpb_file_name%"
		echo begin>> "%gpb_file_name%"
		echo end;>> "%gpb_file_name%"
		echo.>> "%gpb_file_name%"
	)
	
	echo begin>> "%gpb_file_name%"
	echo     for var i := 0 to ParamCount^(^) - 1 do>> "%gpb_file_name%"
	echo     begin>> "%gpb_file_name%"
	echo         var option = args[i];>> "%gpb_file_name%"
	echo         var value = i + 1 ^< args.Length ? args[i + 1] : string.Empty;>> "%gpb_file_name%"
	echo.>> "%gpb_file_name%"
	echo         case option of>> "%gpb_file_name%"

	for %%s in (%gpb_options%) do (
		echo             "%%s": >> "%gpb_file_name%"
		echo             begin >> "%gpb_file_name%"
		echo %%s| sed -r "s/[[:punct:]]//g; s/(.)(.*)/                \u\1\2();/" >> "%gpb_file_name%"
		echo             end; >> "%gpb_file_name%"
	)
	
	echo             else:>> "%gpb_file_name%"
	echo                 Console.Error.WriteLine^($"Option {option} is unsupported now."^);>> "%gpb_file_name%"
	echo         end;>> "%gpb_file_name%"	
	echo     end;>> "%gpb_file_name%"
	echo end.>> "%gpb_file_name%"
exit /b %ec_success%
