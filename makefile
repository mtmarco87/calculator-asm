calculator: calculator.obj
	call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64 && link /OUT:out\calculator.exe out\calculator.obj

calculator.obj: calculator.asm
	if not exist out mkdir out	
	nasm -f win64 calculator.asm -o out\calculator.obj -g