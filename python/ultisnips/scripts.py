
def test():
    print("test")

def CreateNew(Match):
	print(Match)
	if Match.group(0) == "class":
		CreateClass(Match.group(1))
	elif Match.group(0) == "uobject":
		CreateUObject(Match.group(1))
	else:
		print("Wrong argument 0")
	
def CreateClass(Name):
	return """
	#ifndef """+Name.upper()+"""_H
	#define """+Name.upper()+"""_H
	
	class """+Name+"""
	{
		// Default constructor
		"""+Name+"""();	
		
		// Copy constructor
		"""+Name+"""(const """+Name+"""& RHS);
		
		// Copy assignment operator
		"""+Name+"""& operator=(const """+Name+"""& Other);
		
		// Move constructor
		"""+Name+"""("""+Name+"""&& Other);
		
		// Move assignment operator
		"""+Name+"""& operator=("""+Name+"""&& Other);
		
		
	}
	
	#endif //"""+Name.upper()+"""
	"""
	
def CreateUObject(ProjectApi, ClassName):
    return """
    #include "CoreMinimal.h"
    #include "UObject/NoExportTypes.h"
    #include """+ClassName+""".generated.h"

    UCLASS()
    class """+ProjectApi+""" U"""+ClassName+""" : public UObject
    {
        GENERATED_BODY()
        public:
        """+t[0]+"""
    }
    """
