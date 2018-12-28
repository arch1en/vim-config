import vim
import sys

c = __import__("config").Config()

def main():
	GetDir(sys.args[0])

def GetDir(Type):
	Type = Type.lower()
	Result = ""
	if Type == "engine":
		Result = c.UnrealEngineDir
	elif Type == "project":
		Result = c.UnrealProjectDir
	elif Type == "msvc":
		Result = c.MSVCDir
	elif Type == "compilation_database":
		Result = c.CompilationDatabaseDir
	else:
		Result = "Wrong command"
	return Result
	
if __name__ == "__main__":
    main()