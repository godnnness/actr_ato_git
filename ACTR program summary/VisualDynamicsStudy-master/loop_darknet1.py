import os

cwd = os.getcwd()


movie_list = ["BatvSup", "SuicideSquad", "Stoker", "TheRoom", "MemoriesofMurder", "Madeo", "AllaboutMyWife", "ColdEyes", "OurSunhi"]

for index, movie in enumerate(movie_list):
	if index%5 == 1: 
		print("Making new folder for %s" %movie)
		os.system("mkdir ../%s" %(movie))

		os.chdir("../")
		print("Darknet run started for %s" %(movie))
		os.system("./darknet detector demo cfg/combine9k.data cfg/yolo9000.cfg ../yolo9000-weights/yolo9000.weights  -prefix ./%s/frame ./%s_2fps.mp4 -thresh 0.15" %(movie, movie))
		print("Darknet completed for %s" %(movie))
		
		print("Make new Collection folder for %s" %(movie))
		os.system("mkdir %s" %(movie))
		os.system("mv %s_2fps.mp4_Detected_objects.csv %s_Detected_objects.csv" %(movie, movie))
		os.chdir("./Collection")
		os.system("mv ../%s_Detected_objects.csv ./%s/" %(movie, movie))