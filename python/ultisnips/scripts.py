
def test():
    print("test")

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
