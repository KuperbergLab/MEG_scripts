def readTable(filename):
	
	myFile = open(filename, "r")
	temp = 1
	dataTable = []
	
	while temp:
		temp = myFile.readline()
		temp = temp.strip()
		temp = temp.split()
		if temp:
			dataTable.append(temp)

	myFile.close()
	
	return dataTable


def readList(filename):

	myFile = open(filename, "r")
	temp = 1
	dataList = []
	
	while temp:
		temp = myFile.readline()
		temp = temp.strip()
		if temp:
			dataList.append(temp)
	myFile.close()
	
	return dataList