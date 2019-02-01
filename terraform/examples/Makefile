

taxi-all-results:
	echo '"Cloud","Instance Type/Shape","Cluster size","Benchmark","Mean","Min","Max","Iterations","Username"' > allresults.csv
	cat */results.csv >> allresults.csv
	gsed -i 's/-[0-9]\+//g' allresults.csv


