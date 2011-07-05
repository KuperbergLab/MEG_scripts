from pipeline as make_lingua

def writeTable(filename, data):
    
    myFile = open(filename, "w")
    myFile.close()  
    
    myFile = open(filename, "a")

    for row in data:
        for item in row:
            myFile.write(str(item))
            myFile.write("\t")
        myFile.write("\n")
    myFile.close()
    make_lingua(filename)
    
def writeList(filename, data):
    
    myFile = open(filename, "w")
    myFile.close()  
    
    myFile = open(filename, "a")

    for row in data:
        myFile.write(str(row))
        myFile.write("\n")
    myFile.close()
    make_lingua(filename)
