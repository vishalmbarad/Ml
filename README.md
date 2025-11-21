>>> Map Reduce <<<

>> Create a MyMenu db with a Collection called Restraunts containing Documents with Same or All of the following Fields => RestrauntId, RestrauntName, Grades, Cuisine, DOE, Rating

#1 >> Insert at Least 10 Documents in the above collection
#2 >> Use Map Reduce Function to Display Total Rating for Every Restraunt

|1|

-- use Mydb
-- db.createCollection("Restraunts")

-- db.Restraunts.insertMany([
{
	RestrauntId:101,
	RestrauntName: "Salva",
	Grades: "3 star",
	Cuisine: ["Indian","Veg","Non Veg","Chinese"],
	DOE: "1-1-2001",
	Rating: 4
},
{
	RestrauntId:102,
	RestrauntName: "Sufra",
	Grades: "3 star",
	Cuisine: ["Indian","Non Veg"],
	DOE: "12-11-2008",
	Rating: 4.5
},
{
	RestrauntId:103,
	RestrauntName: "South King",
	Grades: "2 star",
	Cuisine: ["Indian","Veg","South Indian"],
	DOE: "17-11-2012",
	Rating: 3
},
{
	RestrauntId:102,
	RestrauntName: "Sufra",
	Grades: "3 star",
	Cuisine: ["Indian","Non Veg"],
	DOE: "12-11-2008",
	Rating: 3.8
},
{
	RestrauntId:105,
	RestrauntName: "China Town",
	Grades: "3.5 star",
	Cuisine: ["Non Veg","Chinese"],
	DOE: "10-6-2013",
	Rating: 3.8
},
{
	RestrauntId:105,
	RestrauntName: "China Town",
	Grades: "3.5 star",
	Cuisine: ["Non Veg","Chinese"],
	DOE: "10-6-2013",
	Rating: 3
},
{
	RestrauntId:107,
	RestrauntName: "Moti Mahal",
	Grades: "4 star",
	Cuisine: ["Indian","Veg","Non Veg"],
	DOE: "11-10-2009",
	Rating: 4
},
{
	RestrauntId:101,
	RestrauntName: "Salva",
	Grades: "3.5 star",
	Cuisine: ["Indian","Veg","Non Veg","Chinese"],
	DOE: "1-1-2001",
	Rating: 3.5
},
{
	RestrauntId:103,
	RestrauntName: "South King",
	Grades: "4 star",
	Cuisine: ["Indian","Veg","South Indian"],
	DOE: "17-11-2012",
	Rating: 4
},
{
	RestrauntId:107,
	RestrauntName: "Moti Mahal",
	Grades: "4 star",
	Cuisine: ["Indian","Veg","Non Veg"],
	DOE: "11-10-2009",
	Rating: 3.5
},
]);


--------------------------------------
Map Reduce


db.Restraunts.mapReduce(
  function() {
    emit(this.RestrauntId, this.Rating);
  },
  function(key, values) {
    return Array.sum(values);
  },
  {
    out: "TotalRatings" 
  }
);

db.TotalRatings.find().pretty();
