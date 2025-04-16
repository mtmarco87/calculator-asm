# Set the Visual Studio version (2017 or 2022) or autodiscover if not provided
VS_VERSION ?=
# Set the path to vcvarsall.bat or autodiscover if not provided
VCVARSALL_PATH ?=

# Path to vswhere.exe for autodiscovery
VSWHERE_PATH = C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe

# If VCVARSALL_PATH is not provided, attempt autodiscovery or use hardcoded paths
ifeq ($(VCVARSALL_PATH),)
    # If VS_VERSION is not provided, attempt autodiscovery
    ifeq ($(VS_VERSION),)
        # Check if vswhere.exe exists using shell
        VSWHERE_EXISTS := $(shell if exist "$(VSWHERE_PATH)" echo yes)
        ifeq ($(VSWHERE_EXISTS),yes)
            VCVARSALL_PATH := $(shell "$(VSWHERE_PATH)" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find **/vcvarsall.bat 2>nul)
            ifeq ($(VCVARSALL_PATH),)
                $(error Could not autodiscover vcvarsall.bat. Ensure Visual Studio is installed or specify VS_VERSION or VCVARSALL_PATH manually.)
            endif
        else
            $(error vswhere.exe not found. Please install Visual Studio Installer or specify VS_VERSION or VCVARSALL_PATH manually.)
        endif
    else
        # If VS_VERSION is provided, use hardcoded paths
        ifeq ($(VS_VERSION), 2017)
            VCVARSALL_PATH = C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
        else ifeq ($(VS_VERSION), 2022)
            VCVARSALL_PATH = C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat
        else
            $(error Unsupported Visual Studio version. Set VS_VERSION to 2017 or 2022, or specify VCVARSALL_PATH manually.)
        endif
    endif
endif

# Check if vcvarsall.bat exists using shell
VCVARSALL_EXISTS := $(shell if exist "$(VCVARSALL_PATH)" echo yes)
ifeq ($(VCVARSALL_EXISTS),)
    $(error Could not find vcvarsall.bat at the specified path: $(VCVARSALL_PATH).)
endif

# Build rules
calculator: calculator.obj
	call "$(VCVARSALL_PATH)" amd64 && link /OUT:out\calculator.exe out\calculator.obj

calculator.obj: calculator.asm
	if not exist out mkdir out
	nasm -f win64 calculator.asm -o out\calculator.obj -g